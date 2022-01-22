ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-linux-base
ARG QT_VERSION=5.15.2
ARG THREADS=1
ARG IMG_BASE=${IMG_PREFIX}/build:wallet-linux-base

COPY --from=lthn/build:wallet-lib-linux-libx / /
COPY --from=lthn/build:wallet-lib-linux-boost / /
COPY --from=lthn/build:wallet-lib-linux-cmake / /
COPY --from=lthn/build:wallet-lib-linux-fontconfig / /
COPY --from=lthn/build:wallet-lib-linux-utils / /

RUN rm /usr/lib/x86_64-linux-gnu/libX11.a || true && \
    rm /usr/lib/x86_64-linux-gnu/libXext.a || true && \
    rm /usr/lib/x86_64-linux-gnu/libX11-xcb.a || true && \
    git clone git://code.qt.io/qt/qt5.git -b ${QT_VERSION} --depth 1 && \
        cd qt5 && \
        git clone git://code.qt.io/qt/qtbase.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtdeclarative.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtgraphicaleffects.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtimageformats.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtmultimedia.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtquickcontrols.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtquickcontrols2.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtsvg.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qttools.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qttranslations.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtx11extras.git -b ${QT_VERSION} --depth 1 && \
        git clone git://code.qt.io/qt/qtxmlpatterns.git -b ${QT_VERSION} --depth 1 && \
    sed -ri s/\(Libs:.*\)/\\1\ -lexpat/ /usr/local/lib/pkgconfig/fontconfig.pc && \
    sed -ri s/\(Libs:.*\)/\\1\ -lz/ /usr/local/lib/pkgconfig/freetype2.pc && \
    sed -ri s/\(Libs:.*\)/\\1\ -lXau/ /usr/local/lib/pkgconfig/xcb.pc && \
    sed -i s/\\/usr\\/X11R6\\/lib64/\\/usr\\/local\\/lib/ qtbase/mkspecs/linux-g++-64/qmake.conf && \
    ./configure --prefix=/usr -platform linux-g++-64 -opensource -confirm-license -release -static -no-avx \
    -opengl desktop -qpa xcb -xcb -xcb-xlib -feature-xlib -system-freetype -fontconfig -glib \
    -no-dbus -no-feature-qml-worker-script -no-linuxfb -no-openssl -no-sql-sqlite -no-kms -no-use-gold-linker \
    -qt-harfbuzz -qt-libjpeg -qt-libpng -qt-pcre -qt-zlib \
    -skip qt3d -skip qtandroidextras -skip qtcanvas3d -skip qtcharts -skip qtconnectivity -skip qtdatavis3d \
    -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtmacextras -skip qtnetworkauth -skip qtpurchasing \
    -skip qtscript -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qttools \
    -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview \
    -skip qtwinextras -skip qtx11extras -skip gamepad -skip serialbus -skip location -skip webengine \
    -nomake examples -nomake tests -nomake tools && \
    make -j$THREADS && \
    make -j$THREADS install && \
    cd qttools/src/linguist/lrelease && \
    ../../../../qtbase/bin/qmake && \
    make -j$THREADS && \
    make -j$THREADS install && \
    cd ../../../.. && \
    rm -rf $(pwd)


