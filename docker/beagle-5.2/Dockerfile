FROM quay.io/biocontainers/beagle:5.2_21Apr21.304--hdfd78af_0
LABEL maintainer="hachiya@genome-analytics.co.jp"

WORKDIR /tools

# conform-gt
RUN wget https://faculty.washington.edu/browning/conform-gt/conform-gt.24May16.cee.jar

# bref
RUN wget https://faculty.washington.edu/browning/beagle/bref3.28Jun21.220.jar

CMD ["/bin/bash"]
