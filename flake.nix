{
  description = "Nix flake to set up LaTeX environment for acmart";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      latexPackages = [
        pkgs.texlive.ifmtarg
        pkgs.texlive.amscls
        pkgs.texlive.amsfonts
        pkgs.texlive.amsmath
        pkgs.texlive.xint
        pkgs.texlive.preprint
        pkgs.texlive.booktabs
        pkgs.texlive.caption
        pkgs.texlive.comment
        pkgs.texlive.cm_super
        pkgs.texlive.cmap
        pkgs.texlive.doclicense
        pkgs.texlive.draftwatermark
        pkgs.texlive.environ
        pkgs.texlive.etoolbox
        pkgs.texlive.fancyhdr
        pkgs.texlive.float
        pkgs.texlive.fontaxes
        pkgs.texlive.geometry
        pkgs.texlive.graphics
        pkgs.texlive.hyperref
        pkgs.texlive.hyperxmp
        pkgs.texlive.iftex
        pkgs.texlive.inconsolata
        pkgs.texlive.libertine
        pkgs.texlive.ncctools
        pkgs.texlive.microtype
        pkgs.texlive.mmap
        pkgs.texlive.count1to
        pkgs.texlive.multitoc
        pkgs.texlive.prelim2e
        pkgs.texlive.ragged2e
        pkgs.texlive.everyshi
        pkgs.texlive.everysel
        pkgs.texlive.mweights
        pkgs.texlive.natbib
        pkgs.texlive.newtx
        pkgs.texlive.oberdiek
        pkgs.texlive.pdftex
        pkgs.texlive.refcount
        pkgs.texlive.setspace
        pkgs.texlive.textcase
        pkgs.texlive.totpages
        pkgs.texlive.trimspaces
        pkgs.texlive.upquote
        pkgs.texlive.url
        pkgs.texlive.xcolor
        pkgs.texlive.xkeyval
        pkgs.texlive.xstring
      ];

      texLiveEnv = pkgs.texlive.combine {
        inherit latexPackages;
      };

    in
    {
      packages.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          texLiveEnv                        # Custom TeX Live environment
          pkgs.git                          # Git for version control
          pkgs.curl                         # Curl for downloading
          pkgs.ghostscript                  # PDF processing
          pkgs.nix                          # Nix package manager
          pkgs.xz                           # XZ compression for TeX Live
          pkgs.jq                           # JSON processor for GitHub actions
        ];

        shellHook = ''
          echo "LaTeX environment set up with Nix-packaged TeX Live dependencies."
        '';
      };

      devShells.default = self.packages.x86_64-linux.default;

      apps.build = {
        type = "app";
        program = "${pkgs.bash}/bin/bash -c ./build.sh";
      };
    };
}
