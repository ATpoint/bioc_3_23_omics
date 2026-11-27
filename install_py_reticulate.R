# Install a core set of python (scverse) infrastructure via reticulate

if(!"reticulate" %in% rownames(installed.packages()))
    install.packages("reticulate")

venv_path <- "/opt/venvs/scverse"
pkgs_install <- c("scanpy", "anndata", "macs3", "snapatac2")
reticulate::virtualenv_create(venv_path, python = "3.12", packages = pkgs_install)