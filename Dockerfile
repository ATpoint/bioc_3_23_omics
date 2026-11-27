# syntax=docker/dockerfile:1

FROM bioconductor/bioconductor_docker:RELEASE_3_23

# R and Bioconductor configuration
ENV BIOCONDUCTOR_USE_CONTAINER_REPOSITORY=FALSE

# Use a fixed CRAN snapshot and compile packages from source.
# Remove the inherited BiocParallel worker limit in R sessions.
RUN printf '%s\n' \
    'options(' \
    '    pkgType = "source",' \
    '    repos = c(CRAN = "https://packagemanager.posit.co/cran/2026-11-24")' \
    ')' \
    'Sys.unsetenv("BIOCPARALLEL_WORKER_NUMBER")' \
    >> /usr/local/lib/R/etc/Rprofile.site

# MEME Suite for motif analysis (along with Bioc package "memes")
RUN mkdir -p /tmp/meme-build \
    && curl -fSL https://meme-suite.org/meme/meme-software/5.5.9/meme-5.5.9.tar.gz \
        -o /tmp/meme-build/meme.tar.gz \
    && tar -xzf /tmp/meme-build/meme.tar.gz -C /tmp/meme-build \
    && cd /tmp/meme-build/meme-5.5.9 \
    && ./configure --prefix=/opt/meme \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf /tmp/meme-build

ENV PATH="/opt/meme/bin:/opt/meme/libexec/meme-5.5.9:${PATH}"

# R and Bioconductor packages
COPY pkgs_r.txt /tmp/install_r_pkgs.txt
COPY install_r_pkgs.R /tmp/install_r_pkgs.R

# Optional GitHub authentication to avoid API rate limits
RUN --mount=type=secret,id=GITHUB_PAT,env=GITHUB_PAT \
    Rscript /tmp/install_r_pkgs.R

# Python and scverse environment
# Create a shared virtual environment writable by the RStudio user.
COPY install_py_reticulate.R /tmp/install_py_reticulate.R

RUN Rscript /tmp/install_py_reticulate.R \
    && chown -R rstudio:rstudio /opt/venvs \
    && rm -rf /root/.cache/pip \
    && printf '%s\n' \
        'RETICULATE_PYTHON=/opt/venvs/scverse/bin/python' \
        >> /usr/local/lib/R/etc/Renviron.site

# Custom RStudio configuration
COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
COPY rserver.conf /etc/rstudio/rserver.conf
