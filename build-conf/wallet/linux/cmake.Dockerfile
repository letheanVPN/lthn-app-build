ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-linux-base as openssl
ARG THREADS=1
RUN find /usr -type f > /files-to-delete.txt
RUN wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz && \
    echo "ddb04774f1e32f0c49751e21b67216ac87852ceb056b75209af2443400636d46 openssl-1.1.1g.tar.gz" | sha256sum -c && \
    tar -xzf openssl-1.1.1g.tar.gz && \
    rm openssl-1.1.1g.tar.gz && \
    cd openssl-1.1.1g && \
    ./config no-asm no-shared no-zlib-dynamic --openssldir=/usr && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)


RUN git clone -b v3.18.4 --depth 1 https://github.com/Kitware/CMake && \
    cd CMake && \
    git reset --hard 3cc3d42aba879fff5e85b363ae8f21386a3f9f9b && \
    ./bootstrap && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN cat /files-to-delete.txt | xargs rm -f

FROM scratch
COPY --from=openssl /usr /usr