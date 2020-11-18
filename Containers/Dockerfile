FROM ubuntu:18.04

# author
LABEL Mantainer="Dardo Marasca"

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
    git clone --depth 1 https://github.com/charig/som.git -b reflectiveCompiler-metaobjectInObject /opt/Som && \
    git clone --depth 1 https://github.com/charig/MatePerformance.git -b master /opt/MatePerformance && \
    git clone --depth 1 https://github.com/charig/ReBench.git -b envVarsSupport /opt/ReBench &&  \
    curl -L --fail --silent --location --retry 3 https://downloads.python.org/pypy/pypy2.7-v7.3.2-linux64.tar.bz2 | tar xj -C /opt/ && \
    curl -L --fail --silent --location --retry 3 https://downloads.python.org/pypy/pypy2.7-v7.3.2-src.tar.bz2 | tar xj -C /opt/

RUN cd /opt/ && \
    ln -s /opt/pypy2.7-v7.3.2-linux64/bin/pypy /usr/local/bin/pypy && \
    ln -s pypy2.7-v7.3.2-src pypy && \
    git clone --depth 1 https://github.com/gefarion/RTruffleMATE.git -b metaobjectInShape /opt/RTruffleMate/MOInShape && \
    git clone --depth 1 https://github.com/gefarion/RTruffleMATE.git -b metaobjectInObject /opt/RTruffleMate/MOInObject && \
    cd /opt/RTruffleMate/MOInShape && ln -s /opt/pypy pypy && export JIT=1 && make && \
    cd /opt/RTruffleMate/MOInObject && ln -s /opt/pypy pypy && export JIT=1 && make && \
    cd /opt/ReBench && pip install .

# Build Java, ST, benchmarks
RUN cd /opt/Benchmarks/AreWeFast/benchmarks/Java && ant jar