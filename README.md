# LaTeX Template with `acmart` Support and Nix Flake Setup

This repository provides a general LaTeX template with support for the `acmart` package, optimized for building academic papers in ACM’s format. The setup is powered by a Nix flake environment, enabling consistent and reproducible builds across different systems, and includes a CI/CD pipeline to build and deploy PDF outputs for each commit and tag.

## Features

- **Nix Flake Development Environment**: Provides all necessary LaTeX packages in a reproducible environment.
- **Support for `acmart`**: Custom derivation to fetch and build the `acmart` LaTeX package from CTAN.
- **GitHub Actions CI/CD**:
  - **PR Builds**: Builds the LaTeX document for each PR and posts a link to the generated PDF as a comment.
  - **Deployment**: Automatically deploys PDFs for commits merged into `master` and for tags, publishing them to GitHub Pages for easy access.

## Prerequisites

### Installing Nix

To install Nix, use the default installer:

```bash
curl -L https://nixos.org/nix/install | sh
```

Enable flakes if not already enabled:

```bash
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Setting Up the Development Environment

1. Clone this repository:

```bash
git clone https://github.com/kayagokalp/latex-template.git
cd latex-template
```

2. Enter the Nix development shell:

```
nix develop
```

This command sets up a shell environment with all necessary dependencies, including LaTeX packages and the acmart class.

## Building the LaTeX Document

With the development environment set up, you can build your document using the provided build script:

```bash
./build.sh
```

The compiled PDF will be in the out directory.

## CI/CD Workflow

This project includes a GitHub Actions CI/CD pipeline in '.github/workflows/ci.yml':

1. PR Builds: Each PR triggers a build, and a link to the generated PDF is posted in the PR comments.
2. Deploy on Merges to `master` 
  - Builds the document on merges to `master` and publishes it to the `gh-pages` branch.
  - Available at: `https://kayagokalp.github.io/latex-template/latest.pdf`

3. Deploy Tagged Releases: 
  - Builds PDFs for tags, available at `https://kayagokalp.github.io/latex-template/<tag>.pdf`

## Custom acmart Support

The acmart LaTeX class is fetched and built directly from CTAN using a custom Nix derivation, ensuring the latest version is always available. Additional packages can be added to the Nix flake file (flake.nix) as needed.

## Summary of Key Files

- `flake.nix`: Defines the Nix flake for setting up a LaTeX environment, including acmart.
- `build.sh`: Custom build script for compiling the LaTeX document.
- `setup.sh`: Custom setup script to install tlmgr packages, (might be needed to use this template without nix)
- `.github/workflows/ci.yml`: GitHub Actions workflow for CI/CD, managing PR builds, deployments on merge, and tagged releases

## How to Use This Template

1. Clone this repo
2. Update `src/main.tex` with your content
3. Push changes by opening a PR, the CI pipeline will automatically build a preview. To see changes locally use `build.sh`

## License

This project is licensed under the MIT License. See the LICENSE file for details.
