# bioc_3_23_omics

[![Build status](https://github.com/ATpoint/bioc_3_23_omics/actions/workflows/build.yml/badge.svg)](https://github.com/ATpoint/bioc_3_23_omics/actions)
[![Docker version](https://img.shields.io/docker/v/atpoint/bioc_3_23_omics?sort=semver)](https://hub.docker.com/r/atpoint/bioc_3_23_omics/tags)
[![Docker pulls](https://img.shields.io/docker/pulls/atpoint/bioc_3_23_omics)](https://hub.docker.com/r/atpoint/bioc_3_23_omics)
![Architectures](https://img.shields.io/badge/architectures-amd64%20%7C%20arm64-blue)
![Bioconductor](https://img.shields.io/badge/Bioconductor-3.23-blue)

A Docker-based RStudio environment for reproducible bioinformatics and omics analyses, built on `bioconductor/bioconductor_docker:RELEASE_3_23`.

The image combines R, Bioconductor, Python and scientific command-line software in a single portable environment.

## Contents

- **R and Bioconductor:** Packages defined in `pkgs_r.txt` and installed from source using `install_r_pkgs.R`.
- **CRAN:** Fixed repository snapshot dated 2026-11-24.
- **MEME Suite 5.5.9:** Compiled and installed under `/opt/meme`, with executables available on `PATH`.
- **Python:** Shared `scverse` virtual environment managed through `reticulate`, including `scanpy`, `anndata`, `macs3` and `snapatac2`.
- **RStudio Server:** Customized user preferences and server configuration.

## Automated builds

GitHub Actions automatically builds the Docker image whenever relevant source files or installation scripts change. Documentation-only changes do not trigger a rebuild.

- Native AMD64 builds for Intel and AMD systems.
- Native ARM64 builds for Apple Silicon and other ARM systems.
- Incremental image versioning (`1.0`, `1.1`, `1.2`, etc.).
- Automated publication of successful multi-architecture builds to Docker Hub.
- GitHub API authentication during package installation using temporary Docker build secrets.

Docker automatically selects the appropriate architecture when pulling the image.

All images are referenced using explicit version tags.

- [Available Docker image versions](https://hub.docker.com/r/atpoint/bioc_3_23_omics/tags)
- [GitHub Actions build history](https://github.com/ATpoint/bioc_3_23_omics/actions)

## Pull

Select a published version from Docker Hub and specify it explicitly:

```bash
VERSION="1.0"
docker pull atpoint/bioc_3_23_omics:${VERSION}
```

## Run RStudio

```bash
VERSION="1.0"

docker run -d --name bioc-omics \
  -p 8787:8787 \
  -e PASSWORD=change-me \
  -v "$(pwd)":/projectdir \
  atpoint/bioc_3_23_omics:${VERSION}
```

Open http://localhost:8787 and sign in with username `rstudio` and the password supplied above.

The current host directory is mounted at `/projectdir`, allowing project files to persist independently of the container.

## Build locally

```bash
docker build --progress=plain -t bioc-omics:local .
```

Optionally, an existing GitHub token can be supplied to avoid API rate limits:

```bash
docker build --progress=plain \
  --secret id=GITHUB_PAT,env=GITHUB_PAT \
  -t bioc-omics:local .
```

## Reproducibility

The CRAN snapshot and MEME Suite version are fixed. Versioned Docker images provide a reusable software environment for individual analyses.

GitHub and Python packages are not necessarily pinned to specific commits or versions. Consequently, rebuilding the same Dockerfile at a later date may produce a different software environment.

For reproducible analyses, retain the specific published image version or digest.
