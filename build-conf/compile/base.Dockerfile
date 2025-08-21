FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y build-essential libtool cmake autotools-dev automake pkg-config \
                    bsdmainutils curl git ccache wget libgtest-dev ca-certificates \
                    gperf make patch bison g++ pkgconf python3 xz-utils clang lld llvm zip  \
                    && rm -rf /var/lib/apt/lists/*


