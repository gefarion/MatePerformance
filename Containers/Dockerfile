FROM ubuntu:19.04

# author
LABEL Mantainer="Guido Chari"

# Arguments
ARG GRAAL_VERSION_RELEASE=1.0.0-rc16
ARG GRAAL_VERSION_DEV=19.3
ARG GRAAL_DEV_LIBS_LOCATION="/opt/graal"
ARG GRAAL_RELEASE_LIBS_LOCATION="/opt/graalvm-ce-1.0.0-rc16/jre/lib"

# Update sources and install dependencies
RUN apt-get update -yq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq git python-pip make curl openjdk-8-jdk openjdk-11-jdk ant zip unzip nodejs pkg-config zlib1g-dev libssl-dev libncurses5-dev libbz2-dev libffi-dev nano libxml2-dev libtinfo5 && \
    pip install pycparser && rm -rf /var/lib/apt/lists/*

# Clone all required repositories and download Graal and Pypy
# PyPy Sources are also needed to compile RTruffleMATE because they contain RPyhton. Compiling pypy from sources was failing that is why I download both, a release and the sources
RUN set -eux && \
    git clone --depth 1 https://github.com/charig/are-we-fast-yet.git -b master /opt/Benchmarks/AreWeFast && \
    git clone --depth 1 https://github.com/charig/som.git -b reflectiveCompiler /opt/Som && \
    git clone --depth 1 https://github.com/charig/MatePerformance.git -b master /opt/MatePerformance && \
    git clone --depth 1 https://github.com/charig/ReBench.git -b envVarsSupport /opt/ReBench &&  \
    curl --fail --silent --location --retry 3 https://github.com/oracle/graal/releases/download/vm-$GRAAL_VERSION_RELEASE/graalvm-ce-$GRAAL_VERSION_RELEASE-linux-amd64.tar.gz | gunzip | tar x -C /opt/ && \
    curl --fail --silent --location --retry 3 https://github.com/graalvm/openjdk8-jvmci-builder/releases/download/jvmci-20-b03/openjdk-8u212_1-jvmci-20-b03-linux-amd64.tar.gz | gunzip | tar x -C /opt/ && \
    git clone --depth 1 https://github.com/oracle/graal.git -b release/graal-vm/$GRAAL_VERSION_DEV /opt/graal && \
    git clone --depth 1 https://github.com/graalvm/mx.git /opt/mx && \
    curl -L --fail --silent --location --retry 3 https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v7.2.0-linux64.tar.bz2 | tar xj -C /opt/ && \
    curl -L --fail --silent --location --retry 3 https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v7.2.0-src.tar.bz2 | tar xj -C /opt/ 

# Links, Build MATE and Rebench
RUN cd /opt/ && \
    export PATH=/opt/mx:$PATH && \
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/ && \
    curl --fail --silent --location --retry 3 http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu6_amd64.deb --output libssl1-0.deb && \
    dpkg -i libssl1-0.deb && \ 
    ln -s /opt/pypy2.7-v7.2.0-linux64/bin/pypy /usr/local/bin/pypy && \
    ln -s pypy2.7-v7.2.0-src pypy && \
    git clone --depth 1 https://github.com/charig/TruffleMATE.git -b java11 /opt/TruffleMateJ11 && \
    git clone --depth 1 https://github.com/charig/TruffleMATE.git -b java11 /opt/TruffleMateJ8 && \
    git clone --depth 1 https://github.com/charig/RTruffleMATE.git -b metaobjectInShape /opt/RTruffleMate/MOInShape && \
    git clone --depth 1 https://github.com/charig/RTruffleMATE.git -b metaobjectInObject /opt/RTruffleMate/MOInObject && \
    cd /opt/graal/compiler && mx build && \
    cd /opt/graal/truffle && mx build && \
    cd /opt/graal/sdk && mx build && \
    cd /opt/TruffleMateJ11 && ant compile -Dgraal.dir=$GRAAL_DEV_LIBS_LOCATION -DgraalVersion=.graalJava11 && \
    cd /opt/TruffleMateJ8 && JAVA_HOME=/opt/openjdk1.8.0_212-jvmci-20-b03 ant compile -Dgraal.dir=$GRAAL_RELEASE_LIBS_LOCATION -DgraalVersion=.graalJava8 && \
    cd /opt/RTruffleMate/MOInShape && ln -s /opt/pypy pypy && export JIT=1 && make && \
    cd /opt/RTruffleMate/MOInObject && ln -s /opt/pypy pypy && export JIT=1 && make && \
    cd /opt/ReBench && pip install .
    
# Install Pharo VM and a stable pharo image (64 bits)
RUN mkdir /opt/Pharo && cd /opt/Pharo && set -eux && curl --fail --silent --location --retry 3 get.pharo.org/64/vm70 | bash
RUN cd /opt/Pharo && set -eux && curl --fail --silent --location --retry 3 get.pharo.org/64/stable | bash 

# Build Java, ST, benchmarks
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
    curl --fail --silent --location --retry 3 https://mtgjson.com/json/AllCards.json.zip | gunzip > AllCards.json
