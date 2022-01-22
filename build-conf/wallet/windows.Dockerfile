ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-windows-base
ARG QT_VERSION=5.15.2
ARG THREADS=1
ENV BRANCH=next
ENV SOURCE_DATE_EPOCH=1397818193


COPY --from=lthn/build:wallet-lib-windows-cmake /usr /usr
COPY --from=lthn/build:wallet-lib-windows-libx / /depends

RUN git clone git://code.qt.io/qt/qt5.git -b ${QT_VERSION} --depth 1 && \
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
    git clone git://code.qt.io/qt/qtxmlpatterns.git -b ${QT_VERSION} --depth 1 && \
    ./configure --prefix=/depends/x86_64-w64-mingw32 -xplatform win32-g++ \
    -device-option CROSS_COMPILE=/usr/bin/x86_64-w64-mingw32- \
    -I $(pwd)/qtbase/src/3rdparty/angle/include \
    -opensource -confirm-license -release -static -static-runtime -opengl dynamic -no-angle \
    -no-avx -no-openssl -no-sql-sqlite \
    -no-feature-qml-worker-script -no-openssl -no-sql-sqlite \
    -qt-freetype -qt-harfbuzz -qt-libjpeg -qt-libpng -qt-pcre -qt-zlib \
    -skip gamepad -skip location -skip qt3d -skip qtactiveqt -skip qtandroidextras \
    -skip qtcanvas3d -skip qtcharts -skip qtconnectivity -skip qtdatavis3d -skip qtdoc \
    -skip qtgamepad -skip qtlocation -skip qtmacextras -skip qtnetworkauth -skip qtpurchasing \
    -skip qtscript -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport \
    -skip qtspeech -skip qttools -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel \
    -skip qtwebengine -skip qtwebsockets -skip qtwebview -skip qtwinextras -skip qtx11extras \
    -skip serialbus -skip webengine \
    -nomake examples -nomake tests -nomake tools && \
    make -j$THREADS && \
    make -j$THREADS install && \
    cd qttools/src/linguist/lrelease && \
    ../../../../qtbase/bin/qmake && \
    make -j$THREADS && \
    make -j$THREADS install && \
    cd ../../../.. && \
    rm -rf $(pwd)

CMD git clone --branch ${BRANCH} --recursive --depth 1 https://gitlab.com/lthn.io/projects/chain/wallet-gui.git \
    && cd /wallet-gui && make depends root=/depends target=x86_64-w64-mingw32 tag=win-x64 -j${THREADS}