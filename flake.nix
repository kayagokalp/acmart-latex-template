{
  description = "Nix flake to set up LaTeX environment for project with custom acmart";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Function to create a TeX Live environment per system
      systemShell = system: let
        pkgs = import nixpkgs { inherit system; };

        # Define required LaTeX packages as a set for compatibility with texlive.combine
        requiredPackages = {
          inherit (pkgs.texlive)
            scheme-small ifmtarg amscls amsfonts amsmath xint preprint
            booktabs caption comment cm-super cmap doclicense draftwatermark
            environ etoolbox fancyhdr float fontaxes geometry graphics
            hyperref hyperxmp iftex inconsolata libertine ncctools
            microtype mmap prelim2e ragged2e everyshi everysel
            mweights natbib newtx oberdiek pdftex refcount setspace
            textcase totpages trimspaces upquote url xcolor xkeyval xstring;
        };

        # Create the combined TeX Live environment
        texLiveEnv = pkgs.texlive.combine requiredPackages;

        # Custom derivation for acmart, downloaded from CTAN
        acmart = pkgs.stdenv.mkDerivation {
          pname = "acmart";
          version = "2023";

          src = pkgs.fetchurl {
            url = "https://mirrors.ctan.org/macros/latex/contrib/acmart.zip";
            sha256 = "sha256-9Tfe83/zd9Xa7+tjAbtkVSUgFQhmxkCqroSaAaSW2X0=";
          };

          nativeBuildInputs = [ pkgs.unzip texLiveEnv ];

          unpackPhase = ''
            unzip $src
            cd acmart
          '';

          buildPhase = ''
            pdflatex acmart.ins
          '';

          installPhase = ''
            mkdir -p $out/texmf/tex/latex/acmart
            cp *.cls $out/texmf/tex/latex/acmart/
            cp *.bst $out/texmf/tex/latex/acmart/
            cp *.bbx $out/texmf/tex/latex/acmart/
            cp *.cbx $out/texmf/tex/latex/acmart/
          '';

          TEXMFHOME = "$out/texmf";
        };

      in
      pkgs.mkShell {
        buildInputs = [
          texLiveEnv
          acmart
          pkgs.git
          pkgs.curl
          pkgs.ghostscript
          pkgs.nix
          pkgs.xz
          pkgs.jq
        ];

        shellHook = ''
          export TEXMFHOME=$HOME/.texmf:${acmart}/texmf
          echo "LaTeX environment set up with custom acmart package."
        '';
      };
    in
    {
      devShells.x86_64-linux.default = systemShell "x86_64-linux";
      devShells.aarch64-darwin.default = systemShell "aarch64-darwin";

      apps.x86_64-linux.build = {
        type = "app";
        program = "${nixpkgs.legacyPackages.x86_64-linux.bash}/bin/bash -c ./build.sh";
      };
    };
}
