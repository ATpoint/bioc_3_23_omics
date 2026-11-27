#!/usr/bin/env Rscript

# Disable Ubuntu binary package management if present
if ("bspm" %in% rownames(installed.packages())) bspm::disable()

# Install Bioconductor manager if not present
if (!"BiocManager" %in% rownames(installed.packages())) {
    install.packages("BiocManager")
}

# Read R package list
packages <- trimws(readLines("/tmp/install_r_pkgs.txt"))
packages <- packages[nzchar(packages) & !startsWith(packages, "#")]

# Install packages
cpu_file <- "/sys/fs/cgroup/cpu.max"
n_cores <- parallel::detectCores()

if (file.exists(cpu_file)) {
    cpu <- scan(cpu_file, what = "", quiet = TRUE)
    if (cpu[1] != "max") {
        n_cores <- min(n_cores, ceiling(as.numeric(cpu[1]) / as.numeric(cpu[2])))
    }
}

n_cores <- max(1L, n_cores - 1L)

BiocManager::install(
    packages, ask = FALSE, update = FALSE, type = "source", Ncpus = n_cores
)

missing <- setdiff(gsub(".*\\/", "", packages), rownames(installed.packages()))
if (length(missing)) stop("Failed to install: ", paste(missing, collapse = "\n"))