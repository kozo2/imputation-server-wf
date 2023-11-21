FROM bioconductor/bioconductor_docker:RELEASE_3_18

WORKDIR /opt

RUN apt-get update \
        ## Install the python package tensorflow
        && apt-get install time -y \
        ## Remove packages in '/var/cache/' and 'var/lib'
        ## to remove side-effects of apt-get update
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*
RUN R -e 'BiocManager::install("HIBAG")'

COPY run-hibag.sh /opt
COPY run-hibag.pl /opt

CMD ["/bin/bash"]
