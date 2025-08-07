FROM ubuntu:24.04

# Author label
LABEL maintainer="Delilah Maloney <Delilah.Maloney@tufts.edu>"

# Help message
LABEL description="This container contains Morpho installed on ubuntu:24.04.https://github.com/Morpho-lang/morpho"

# Set environment variables
ENV PATH=/opt/morpho/bin:$PATH \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
    
# Download and install Anaconda
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends build-essential wget git ca-certificates locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN  apt install build-essential cmake \
    && apt install libglfw3-dev libsuitesparse-dev liblapacke-dev povray libfreetype6-dev libunistring-dev

# Build Morpho
RUN git clone https://github.com/Morpho-lang/morpho.git \
    && cd morpho \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make install \
    && cd ../../

# Build Morpho-cli
RUN git clone https://github.com/Morpho-lang/morpho-cli.git \
    && cd morpho-cli \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && sudo make install \
    && cd ../../
# Build Morphoview
RUN git clone https://github.com/Morpho-lang/morpho-morphoview.git \
    && cd morpho-morphoview \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && sudo make install

# Set default shell to bash
SHELL ["/bin/bash", "-c"]