FROM bioconductor/bioconductor_docker:RELEASE_3_18

WORKDIR /opt

RUN apt-get update \
    && apt-get install time -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN R -e 'BiocManager::install("HIBAG")'

COPY run-hibag.sh /opt
COPY run-hibag.pl /opt

CMD ["/bin/bash"]
