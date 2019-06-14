FROM ubuntu:18.04

# author
LABEL Mantainer="Guido Chari"

# Arguments
ARG GRAAL_VERSION=1.0.0-rc16
ARG GRAAL_LIBS_LOCATION="/opt/graal/jre/lib"

# Update sources and install dependencies
RUN apt-get update -yq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq git python-pip make curl openjdk-8-jdk ant zip unzip nodejs pkg-config zlib1g-dev libssl-dev libncurses5-dev libbz2-dev libffi-dev nano && \
    pip install pycparser && rm -rf /var/lib/apt/lists/*

# Clone all required repositories and download Graal and Pypy
# At this point Graal still requires a JVMCI enabled java 8 jdk 
# PyPy Sources are also needed to compile RTruffleMATE because they contain RPyhton. Compiling pypy from sources was failing that is why I download both, a release and the sources
RUN set -eux && \
    git clone --depth 1 https://github.com/charig/are-we-fast-yet.git -b master /opt/Benchmarks/AreWeFast && \
    git clone --depth 1 https://github.com/charig/som.git -b reflectiveCompiler /opt/Som && \
    git clone --depth 1 https://github.com/charig/MatePerformance.git -b master /opt/MatePerformance && \
    git clone --depth 1 https://github.com/charig/ReBench.git -b envVarsSupport /opt/ReBench &&  \
    curl --fail --silent --location --retry 3 https://github.com/oracle/graal/releases/download/vm-$GRAAL_VERSION/graalvm-ce-$GRAAL_VERSION-linux-amd64.tar.gz | gunzip | tar x -C /opt/ && \
    curl --fail --silent --location --retry 3 https://github.com/graalvm/openjdk8-jvmci-builder/releases/download/jvmci-20-b03/openjdk-8u212_1-jvmci-20-b03-linux-amd64.tar.gz | gunzip | tar x -C /opt/ && \
    curl -L --fail --silent --location --retry 3 https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v7.1.1-linux64.tar.bz2 | tar xj -C /opt/ && \
    curl -L --fail --silent --location --retry 3 https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v7.1.1-src.tar.bz2 | tar xj -C /opt/ 

# Links, Build MATE and Rebench
RUN cd /opt/ && \
    ln -s graalvm-ce-$GRAAL_VERSION graal && \
    ln -s openjdk1.8.0_212-jvmci-20-b03 openjdk8JVMCI && \
    ln -s /opt/pypy2.7-v7.1.1-linux64/bin/pypy /usr/local/bin/pypy && \
    ln -s pypy2.7-v7.1.1-src pypy && \
    git clone --depth 1 https://github.com/charig/TruffleMATE.git -b master /opt/TruffleMate && \
    git clone --depth 1 https://github.com/charig/RTruffleMATE.git -b metaobjectInShape /opt/RTruffleMate/MOInShape && \
    git clone --depth 1 https://github.com/charig/RTruffleMATE.git -b metaobjectInObject /opt/RTruffleMate/MOInObject && \
    cd /opt/TruffleMate && ant compile -Dgraallib.dir=$GRAAL_LIBS_LOCATION && \
    cd /opt/RTruffleMate/MOInShape && ln -s /opt/pypy pypy && export JIT=1 && make && \
    cd /opt/RTruffleMate/MOInObject && ln -s /opt/pypy pypy && export JIT=1 && make && \
    cd /opt/ReBench && pip install .

# Install Pharo VM and a stable pharo image (64 bits)
RUN mkdir /opt/Pharo && cd /opt/Pharo && set -eux && curl --fail --silent --location --retry 3 get.pharo.org/64/vm70 | bash
RUN cd /opt/Pharo && set -eux && curl --fail --silent --location --retry 3 get.pharo.org/64/stable | bash 

# Build Java, ST benchmarks
RUN cd /opt/Benchmarks/AreWeFast/benchmarks/Java && ant jar && \
    cd /opt/Benchmarks/AreWeFast/benchmarks/Smalltalk/ && \
    cp /opt/Pharo/Pharo.image . && \
    cp /opt/Pharo/*.sources . && \
    /opt/Pharo/pharo Pharo.image build-image.st && \
    mv AWFY.image AWFY_Pharo.image && \
    mv AWFY.changes AWFY_Pharo.changes && \
    rm /opt/Benchmarks/AreWeFast/benchmarks/Smalltalk/Pharo.image && \
    rm /opt/Benchmarks/AreWeFast/benchmarks/Smalltalk/Pharo.changes && \
    cd /opt/Som/Examples/Benchmarks/Mate/Tracing/ && \
    curl --fail --silent --location --retry 3 https://mtgjson.com/json/AllSets.json.zip | gunzip
    #download_zip "AllSets-x.json.zip" "https://mtgjson.com/json/AllSets-x.json.zip"
    #download_zip "AllSets.json.zip" "https://mtgjson.com/json/AllSets.json.zip"
    #python cleanJsonFile "AllSets-x"
    #python cleanJsonFile "AllSets"
