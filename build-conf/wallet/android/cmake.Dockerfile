ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-android-base
ARG THREADS=1


ARG OPENSSL_VERSION=1.1.1g
ARG OPENSSL_HASH=ddb04774f1e32f0c49751e21b67216ac87852ceb056b75209af2443400636d46
RUN wget -q https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && tar -xzf openssl-${OPENSSL_VERSION}.tar.gz \
    && rm openssl-${OPENSSL_VERSION}.tar.gz \
    && cd openssl-${OPENSSL_VERSION} \
    && ANDROID_NDK_HOME=${ANDROID_NDK_ROOT} ./Configure CC=${ANDROID_CLANG} CXX=${ANDROID_CLANGPP} \
    android-arm64 no-asm no-shared --static \
    --with-zlib-include=${PREFIX}/include --with-zlib-lib=${PREFIX}/lib \
    --prefix=${PREFIX} --openssldir=${PREFIX} \
    && sed -i 's/CNF_EX_LIBS=-ldl -pthread//g;s/BIN_CFLAGS=-pie $(CNF_CFLAGS) $(CFLAGS)//g' Makefile \
    && ANDROID_NDK_HOME=${ANDROID_NDK_ROOT} make -j${THREADS} \
    && make -j${THREADS} install \
    && rm -rf $(pwd)

RUN git clone -b v3.19.7 --depth 1 https://github.com/Kitware/CMake \
    && cd CMake \
    && git reset --hard 22612dd53a46c7f9b4c3f4b7dbe5c78f9afd9581 \
    && PATH=${HOST_PATH} ./bootstrap \
    && PATH=${HOST_PATH} make -j${THREADS} \
    && PATH=${HOST_PATH} make -j${THREADS} install \
    && rm -rf $(pwd)