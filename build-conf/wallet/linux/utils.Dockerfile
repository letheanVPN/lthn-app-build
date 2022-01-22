ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-linux-base as base
ARG THREADS=1

FROM base as zlib
RUN find /usr -type f > /files-to-delete.txt
ARG THREADS=1
RUN git clone -b v1.2.11 --depth 1 https://github.com/madler/zlib && \
    cd zlib && \
    git reset --hard cacf7f1d4e3d44d871b605da3b647f07d718623f && \
    ./configure --static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)
RUN cat /files-to-delete.txt | xargs rm -f

FROM base as libusb
RUN find /usr -type f > /files-to-delete.txt
ARG THREADS=1
RUN git clone -b v1.0.23 --depth 1 https://github.com/libusb/libusb && \
    cd libusb && \
    git reset --hard e782eeb2514266f6738e242cdcb18e3ae1ed06fa && \
    ./autogen.sh --disable-shared --enable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)
RUN cat /files-to-delete.txt | xargs rm -f

FROM base as hidapi
RUN find /usr -type f > /files-to-delete.txt
ARG THREADS=1
RUN git clone -b hidapi-0.9.0 --depth 1 https://github.com/libusb/hidapi && \
    cd hidapi && \
    git reset --hard 7da5cc91fc0d2dbe4df4f08cd31f6ca1a262418f && \
    ./bootstrap && \
    ./configure --disable-shared --enable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)
RUN cat /files-to-delete.txt | xargs rm -f

FROM base as zmq
RUN find /usr -type f > /files-to-delete.txt
RUN git clone -b v4.3.2 --depth 1 https://github.com/zeromq/libzmq && \
    cd libzmq && \
    git reset --hard a84ffa12b2eb3569ced199660bac5ad128bff1f0 && \
    ./autogen.sh && \
    ./configure --disable-shared --enable-static --disable-libunwind --with-libsodium && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN cat /files-to-delete.txt | xargs rm -f

FROM base as libgpg-error
ARG THREADS=1
RUN find /usr -type f > /files-to-delete.txt
RUN git clone -b libgpg-error-1.38 --depth 1 git://git.gnupg.org/libgpg-error.git && \
    cd libgpg-error && \
    git reset --hard 71d278824c5fe61865f7927a2ed1aa3115f9e439 && \
    ./autogen.sh && \
    ./configure --disable-shared --enable-static --disable-doc --disable-tests && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN git clone -b libgcrypt-1.8.5 --depth 1 git://git.gnupg.org/libgcrypt.git && \
    cd libgcrypt && \
    git reset --hard 56606331bc2a80536db9fc11ad53695126007298 && \
    ./autogen.sh && \
    ./configure --disable-shared --enable-static --disable-doc && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN cat /files-to-delete.txt | xargs rm -f


FROM scratch as final

COPY --from=libgpg-error /usr /usr
COPY --from=zmq /usr /usr
COPY --from=hidapi /usr /usr
COPY --from=libusb /usr /usr
COPY --from=zlib /usr /usr

