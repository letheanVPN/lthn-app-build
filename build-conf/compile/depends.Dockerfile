FROM lthn/build:compile as build

ARG THREADS=1
ARG BRANCH=next
ARG BUILD=x86_64-w64-mingw32
ARG GIT_REPO=https://gitlab.com/lthn.io/projects/chain/lethean.git
ARG BUILD_PATH=/lethean/chain/contrib/depends

COPY --from=lthn/build:sources-linux / /cache/linux
COPY --from=lthn/build:sources-win / /cache/win

RUN git clone --depth 1 --branch ${BRANCH} ${GIT_REPO};

ENV PACKAGE=""
RUN case ${BUILD} in \
    x86_64-unknown-linux-gnu) \
     PACKAGE="gperf cmake python3-zmq libdbus-1-dev libharfbuzz-dev"; \
      cp -r /cache/linux /lethean/chain/contrib/depends/sources; \
    ;; \
    i686-pc-linux-gnu) \
     PACKAGE="gperf cmake g++-multilib python3-zmq"; \
     cp -r /cache/linux /lethean/chain/contrib/depends/sources; \
    ;; \
    arm-linux-gnueabihf) \
     PACKAGE="python3 gperf g++-arm-linux-gnueabihf"; \
     cp -r /cache/linux /lethean/chain/contrib/depends/sources; \
    ;; \
    aarch64-linux-gnu) \
     PACKAGE="python3 gperf g++-aarch64-linux-gnu"; \
     cp -r /cache/linux /lethean/chain/contrib/depends/sources; \
    ;; \
    x86_64-w64-mingw32) \
     PACKAGE="cmake python3 g++-mingw-w64-x86-64 qttools5-dev-tools"; \
    cp -r /cache/win /lethean/chain/contrib/depends/sources; \
    ;; \
    i686-w64-mingw32) \
     PACKAGE="python3 g++-mingw-w64-i686 qttools5-dev-tools"; \
      cp -r /cache/win /lethean/chain/contrib/depends/sources; \
    ;; \
    riscv64-linux-gnu) \
     PACKAGE="python3 gperf g++-riscv64-linux-gnu"; \
     cp -r /cache/linux /lethean/chain/contrib/depends/sources; \
    ;; \
    x86_64-unknown-freebsd) \
     PACKAGE="clang-8 gperf cmake python3-zmq libdbus-1-dev libharfbuzz-dev"; \
     cp -r /cache/linux /lethean/chain/contrib/depends/sources; \
    ;; \
    esac \
    && apt-get update && apt-get install -y $PACKAGE;


RUN if [ ${BUILD} = x86_64-w64-mingw32 ] || [ ${BUILD} = i686-w64-mingw32 ]; then \
    update-alternatives --set ${BUILD}-g++ $(which ${BUILD}-g++-posix) && \
    update-alternatives --set ${BUILD}-gcc $(which ${BUILD}-gcc-posix); \
    fi

ENV BUILD_TARGET=${BUILD}
ENV BUILD_THREADS=1
ENV CCACHE_SIZE=100M
ENV CCACHE_TEMPDIR=/tmp/.ccache-temp
ENV CCACHE_COMPRESS=1
ENV CCACHE_DIR=$HOME/.ccache

RUN make -j${THREADS} -C ${BUILD_PATH} HOST=${BUILD}

CMD if [ -f "/build/chain/Makefile" ]; then \
        echo "Local code"; \
        cp -R /build /lethean ; \
    fi && \
    (cd /lethean && git submodule update --init --depth 1) && \
    make -j${BUILD_THREADS} -C /lethean/chain depends target=${BUILD_TARGET} && \
    mkdir -p /build/dist/${BUILD_TARGET} && \
    mv -f /lethean/chain/build/release/bin/* /build/dist/${BUILD_TARGET};

FROM scratch as export-image
COPY --from=build /lethean/chain/contrib/depends/built /built
