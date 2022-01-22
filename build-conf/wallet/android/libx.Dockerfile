ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-android-base
ARG THREADS=1



ARG ZLIB_VERSION=1.2.11
ARG ZLIB_HASH=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1
RUN wget -q https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz \
    && tar -xzf zlib-${ZLIB_VERSION}.tar.gz \
    && rm zlib-${ZLIB_VERSION}.tar.gz \
    && cd zlib-${ZLIB_VERSION} \
    && CC=${ANDROID_CLANG} CXX=${ANDROID_CLANGPP} ./configure --prefix=${PREFIX} --static \
    && make -j${THREADS} \
    && make -j${THREADS} install \
    && rm -rf $(pwd)


ARG ICONV_VERSION=1.16
ARG ICONV_HASH=e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04
RUN wget -q http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${ICONV_VERSION}.tar.gz \
    && echo "${ICONV_HASH}  libiconv-${ICONV_VERSION}.tar.gz" | sha256sum -c \
    && tar -xzf libiconv-${ICONV_VERSION}.tar.gz \
    && rm -f libiconv-${ICONV_VERSION}.tar.gz \
    && cd libiconv-${ICONV_VERSION} \
    && CC=${ANDROID_CLANG} CXX=${ANDROID_CLANGPP} ./configure --build=x86_64-linux-gnu --host=aarch64 --prefix=${PREFIX} --disable-rpath \
    && make -j${THREADS} \
    && make -j${THREADS} install

ARG ZMQ_VERSION=v4.3.3
ARG ZMQ_HASH=04f5bbedee58c538934374dc45182d8fc5926fa3
RUN git clone https://github.com/zeromq/libzmq.git -b ${ZMQ_VERSION} --depth 1 \
    && cd libzmq \
    && git checkout ${ZMQ_HASH} \
    && ./autogen.sh \
    && CC=${ANDROID_CLANG} CXX=${ANDROID_CLANGPP} ./configure --prefix=${PREFIX} --host=aarch64-linux-android \
    --enable-static --disable-shared \
    && make -j${THREADS} \
    && make -j${THREADS} install \
    && rm -rf $(pwd)

ARG SODIUM_VERSION=1.0.18
ARG SODIUM_HASH=4f5e89fa84ce1d178a6765b8b46f2b6f91216677
RUN set -ex \
    && git clone https://github.com/jedisct1/libsodium.git -b ${SODIUM_VERSION} --depth 1 \
    && cd libsodium \
    && test `git rev-parse HEAD` = ${SODIUM_HASH} || exit 1 \
    && ./autogen.sh \
    && CC=${ANDROID_CLANG} CXX=${ANDROID_CLANGPP} ./configure --prefix=${PREFIX} --host=aarch64-linux-android --enable-static --disable-shared \
    && make -j${THREADS} install \
    && rm -rf $(pwd)

RUN git clone -b libgpg-error-1.38 --depth 1 git://git.gnupg.org/libgpg-error.git \
    && cd libgpg-error \
    && git reset --hard 71d278824c5fe61865f7927a2ed1aa3115f9e439 \
    && ./autogen.sh \
    && CC=${ANDROID_CLANG} CXX=${ANDROID_CLANGPP} ./configure --host=aarch64-linux-android --prefix=${PREFIX} --disable-rpath --disable-shared --enable-static --disable-doc --disable-tests \
    && PATH=${TOOLCHAIN_DIR}/bin:${HOST_PATH} make -j${THREADS} \
    && make -j${THREADS} install \
    && rm -rf $(pwd)

RUN git clone -b libgcrypt-1.8.5 --depth 1 git://git.gnupg.org/libgcrypt.git \
    && cd libgcrypt \
    && git reset --hard 56606331bc2a80536db9fc11ad53695126007298 \
    && ./autogen.sh \
    && CC=${ANDROID_CLANG} CXX=${ANDROID_CLANGPP} ./configure --host=aarch64-linux-android --prefix=${PREFIX} --with-gpg-error-prefix=${PREFIX} --disable-shared --enable-static --disable-doc --disable-tests \
    && PATH=${TOOLCHAIN_DIR}/bin:${HOST_PATH} make -j${THREADS} \
    && make -j${THREADS} install \
    && rm -rf $(pwd)

