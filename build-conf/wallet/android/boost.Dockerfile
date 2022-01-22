ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-android-base
ARG THREADS=1

ARG BOOST_VERSION=1_74_0
ARG BOOST_VERSION_DOT=1.74.0
ARG BOOST_HASH=83bfc1507731a0906e387fc28b7ef5417d591429e51e788417fe9ff025e116b1
RUN wget -q https://downloads.sourceforge.net/project/boost/boost/${BOOST_VERSION_DOT}/boost_${BOOST_VERSION}.tar.bz2 \
    && echo "${BOOST_HASH}  boost_${BOOST_VERSION}.tar.bz2" | sha256sum -c \
    && tar -xf boost_${BOOST_VERSION}.tar.bz2 \
    && rm -f boost_${BOOST_VERSION}.tar.bz2 \
    && cd boost_${BOOST_VERSION} \
    && PATH=${HOST_PATH} ./bootstrap.sh --prefix=${PREFIX} \
    && PATH=${TOOLCHAIN_DIR}/bin:${HOST_PATH} ./b2 --build-type=minimal link=static runtime-link=static \
    --with-chrono --with-date_time --with-filesystem --with-program_options --with-regex --with-serialization \
    --with-system --with-thread --with-locale --build-dir=android --stagedir=android toolset=clang threading=multi \
    threadapi=pthread target-os=android -sICONV_PATH=${PREFIX} \
    cflags='--target=aarch64-linux-android' \
    cxxflags='--target=aarch64-linux-android' \
    linkflags='--target=aarch64-linux-android --sysroot=${ANDROID_NDK_ROOT}/platforms/${ANDROID_API}/arch-arm64 ${ANDROID_NDK_ROOT}/sources/cxx-stl/llvm-libc++/libs/arm64-v8a/libc++_shared.so -nostdlib++' \
    install -j${THREADS} \
    && rm -rf $(pwd)