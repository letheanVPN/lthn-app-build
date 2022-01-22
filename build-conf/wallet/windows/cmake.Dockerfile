ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-windows-base as build
ARG THREADS=1

RUN git clone -b v3.19.7 --depth 1 https://github.com/Kitware/CMake \
    && cd CMake \
    && git reset --hard 22612dd53a46c7f9b4c3f4b7dbe5c78f9afd9581 \
    && ./bootstrap \
    && make -j${THREADS} \
    && make -j${THREADS} install

