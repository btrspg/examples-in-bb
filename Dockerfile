FROM ubuntu:18.04
MAINTAINER CHEN Yuelong <yuelong.chen.btr@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV R_BASE_VERSION 3.6.1
ARG packages='build-essential libcurl4-openssl-dev libssl-dev \
    libxml2-dev software-properties-common python python-dev python-pip git'

RUN apt update && \
    apt install -y $packages && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt update && \
    apt install -y r-base=${R_BASE_VERSION}* \
                   r-base-dev=${R_BASE_VERSION}* \
                   r-recommended=${R_BASE_VERSION}* && \
    echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    pip install jupyterlab


RUN Rscript -e "install.packages('BiocManager');BiocManager::install('Biobase');install.packages('devtools');"
RUN Rscript -e "devtools::install_github('IRkernel/IRkernel');IRkernel::installspec()"
COPY jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN apt autoclean && \
    apt purge -y build-essential software-properties-common git && \
    rm -rf /var/lib/apt/lists/*

CMD /bin/bash