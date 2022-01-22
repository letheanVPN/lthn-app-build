ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-linux-base as build
ARG THREADS=1

RUN find /usr -type f > /files-to-delete.txt

RUN git clone -b xorgproto-2020.1 --depth 1 https://gitlab.freedesktop.org/xorg/proto/xorgproto && \
    cd xorgproto && \
    git reset --hard c62e8203402cafafa5ba0357b6d1c019156c9f36 && \
    ./autogen.sh && \
    make -j$THREADS && \
    make -j$THREADS install

RUN git clone -b 1.12 --depth 1 https://gitlab.freedesktop.org/xorg/proto/xcbproto && \
    cd xcbproto && \
    git reset --hard 6398e42131eedddde0d98759067dde933191f049 && \
    ./autogen.sh && \
    make -j$THREADS && \
    make -j$THREADS install


RUN git clone -b libXau-1.0.9 --depth 1 https://gitlab.freedesktop.org/xorg/lib/libxau && \
    cd libxau && \
    git reset --hard d9443b2c57b512cfb250b35707378654d86c7dea && \
    ./autogen.sh --enable-shared --disable-static && \
    make -j$THREADS && \
    make -j$THREADS install

RUN git clone -b 0.4.0 --depth 1 https://gitlab.freedesktop.org/xorg/lib/libxcb-util && \
    cd libxcb-util && \
    git reset --hard acf790d7752f36e450d476ad79807d4012ec863b && \
    git submodule init && \
    git clone --depth 1 https://gitlab.freedesktop.org/xorg/util/xcb-util-m4 m4 && \
    git -C m4 reset --hard f662e3a93ebdec3d1c9374382dcc070093a42fed && \
    ./autogen.sh --enable-shared --disable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN git clone -b 0.4.0 --depth 1 https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms && \
    cd libxcb-keysyms && \
    git reset --hard 0e51ee5570a6a80bdf98770b975dfe8a57f4eeb1 && \
    git submodule init && \
    git clone --depth 1 https://gitlab.freedesktop.org/xorg/util/xcb-util-m4 m4 && \
    git -C m4 reset --hard f662e3a93ebdec3d1c9374382dcc070093a42fed && \
    ./autogen.sh --enable-shared --disable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN git clone -b 0.3.9 --depth 1 https://gitlab.freedesktop.org/xorg/lib/libxcb-render-util && \
    cd libxcb-render-util && \
    git reset --hard 0317caf63de532fd7a0493ed6afa871a67253747 && \
    git submodule init && \
    git clone --depth 1 https://gitlab.freedesktop.org/xorg/util/xcb-util-m4 m4 && \
    git -C m4 reset --hard f662e3a93ebdec3d1c9374382dcc070093a42fed && \
    ./autogen.sh --enable-shared --disable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN git clone -b 0.4.1 --depth 1 https://gitlab.freedesktop.org/xorg/lib/libxcb-wm && \
    cd libxcb-wm && \
    git reset --hard 24eb17df2e1245885e72c9d4bbb0a0f69f0700f2 && \
    git submodule init && \
    git clone --depth 1 https://gitlab.freedesktop.org/xorg/util/xcb-util-m4 m4 && \
    git -C m4 reset --hard f662e3a93ebdec3d1c9374382dcc070093a42fed && \
    ./autogen.sh --enable-shared --disable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN git clone -b v3.10.0 --depth 1 https://github.com/protocolbuffers/protobuf && \
    cd protobuf && \
    git reset --hard 6d4e7fd7966c989e38024a8ea693db83758944f1 && \
    ./autogen.sh && \
    ./configure --enable-static --disable-shared && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN git clone -b 1.12 --depth 1 https://gitlab.freedesktop.org/xorg/lib/libxcb && \
    cd libxcb && \
    git reset --hard d34785a34f28fa6a00f8ce00d87e3132ff0f6467 && \
    ./autogen.sh --enable-shared --disable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    make -j$THREADS clean && \
    rm /usr/local/lib/libxcb-xinerama.so && \
    ./autogen.sh --disable-shared --enable-static && \
    make -j$THREADS && \
    cp src/.libs/libxcb-xinerama.a /usr/local/lib/ && \
    rm -rf $(pwd)

RUN git clone -b xkbcommon-0.5.0 --depth 1 https://github.com/xkbcommon/libxkbcommon && \
    cd libxkbcommon && \
    git reset --hard c43c3c866eb9d52cd8f61e75cbef1c30d07f3a28 && \
    ./autogen.sh --prefix=/usr --enable-shared --disable-static --enable-x11 --disable-docs && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN git clone -b 0.4.0 --depth 1 https://gitlab.freedesktop.org/xorg/lib/libxcb-image && \
    cd libxcb-image && \
    git reset --hard d882052fb2ce439c6483fce944ba8f16f7294639 && \
    git submodule init && \
    git clone --depth 1 https://gitlab.freedesktop.org/xorg/util/xcb-util-m4 m4 && \
    git -C m4 reset --hard f662e3a93ebdec3d1c9374382dcc070093a42fed && \
    ./autogen.sh --enable-shared --disable-static && \
    make -j$THREADS && \
    make -j$THREADS install && \
    rm -rf $(pwd)

RUN cat /files-to-delete.txt | xargs rm -f

FROM scratch
COPY --from=build /usr /usr