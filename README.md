# bioc_3_23_omics

A Docker-based RStudio environment for reproducible analyses. 
Built on `bioconductor/bioconductor_docker:RELEASE_3_23` to keep R, Bioconductor, scientific software, and Python tools together in one portable (aka monolithic) environment.

## Contents

- **R/Bioconductor:** Packages from `pkgs_r.txt`, installed by `install_r_pkgs.R`; fixed CRAN snapshot (2026-11-22) and Bioconductor container repositories.
- **MEME Suite 5.5.9:** Compiled under `/opt/meme` for motif analysis; executables added to `PATH`.
- **Python:** `scverse` virtual environment created through `reticulate`, with `scanpy`, `anndata`, `macs3`, and `snapatac2`.
- **RStudio:** Customized preferences from `rstudio-prefs.json`.

The software is separated into Docker build layers to make updates easier and reuse cached steps. The CRAN snapshot is fixed, but GitHub and Python packages are not fully version-pinned.

## Build

From the directory containing the Dockerfile and installation scripts:

```bash
docker build --progress=plain -t atpoint/bioc_3_23_omics:1.0 .
```

## Run RStudio

```bash
docker run -d --name bioc-omics -p 8787:8787 -e PASSWORD=change-me -v "$(pwd)":/projectdir atpoint/bioc_3_23_omics:1.0
```

Open <http://localhost:8787> and sign in with username `rstudio` and the password supplied above. The current host directory is mounted at `/projectdir`, so project files persist outside the container.