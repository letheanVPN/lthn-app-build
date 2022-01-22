FROM ubuntu:bionic
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y build-essential libtool cmake autotools-dev automake pkg-config \
                    bsdmainutils curl git ca-certificates ccache wget libgtest-dev \
                    && cd /usr/src/gtest && cmake . && make && mv libg* /usr/lib/ \
                    && rm -rf /var/lib/apt/lists/*


