ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-windows-base as build
ARG THREADS=1

RUN git clone -b libgpg-error-1.38 --depth 1 git://git.gnupg.org/libgpg-error.git && \
    cd libgpg-error && \
    git reset --hard 71d278824c5fe61865f7927a2ed1aa3115f9e439 && \
    ./autogen.sh && \
    ./configure --disable-shared --enable-static --disable-doc --disable-tests \
    --host=x86_64-w64-mingw32 --prefix=/depends/x86_64-w64-mingw32 && \
    make -j$THREADS && \
    make -j$THREADS install && \
    cd .. && \
    rm -rf libgpg-error

RUN git clone -b libgcrypt-1.8.5 --depth 1 git://git.gnupg.org/libgcrypt.git && \
    cd libgcrypt && \
    git reset --hard 56606331bc2a80536db9fc11ad53695126007298 && \
    ./autogen.sh && \
    ./configure --disable-shared --enable-static --disable-doc \
    --host=x86_64-w64-mingw32 --prefix=/depends/x86_64-w64-mingw32 \
    --with-gpg-error-prefix=/depends/x86_64-w64-mingw32 && \
    make -j$THREADS && \
    make -j$THREADS install && \
    cd .. && \
    rm -rf libgcrypt

FROM scratch
COPY --from=build /depends /depends