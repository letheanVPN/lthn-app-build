ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-android-base
ARG THREADS=1
ARG QT_VERSION=5.15.2

RUN git clone git://code.qt.io/qt/qt5.git -b ${QT_VERSION} --depth 1 \
    && cd qt5 \
    && perl init-repository --module-subset=default,-qtwebengine \
    && PATH=${HOST_PATH} ./configure -v -developer-build -release \
    -xplatform android-clang \
    -android-ndk-platform ${ANDROID_API} \
    -android-ndk ${ANDROID_NDK_ROOT} \
    -android-sdk ${ANDROID_SDK_ROOT} \
    -android-ndk-host linux-x86_64 \
    -no-dbus \
    -opengl es2 \
    -no-use-gold-linker \
    -no-sql-mysql \
    -opensource -confirm-license \
    -android-arch arm64-v8a \
    -prefix ${PREFIX} \
    -nomake tools -nomake tests -nomake examples \
    -skip qtwebengine \
    -skip qtserialport \
    -skip qtconnectivity \
    -skip qttranslations \
    -skip qtpurchasing \
    -skip qtgamepad -skip qtscript -skip qtdoc \
    -no-warnings-are-errors \
    && sed -i '213,215d' qtbase/src/3rdparty/pcre2/src/sljit/sljitConfigInternal.h \
    && PATH=${HOST_PATH} make -j${THREADS} \
    && PATH=${HOST_PATH} make -j${THREADS} install \
    && cd qttools/src/linguist/lrelease \
    && ../../../../qtbase/bin/qmake \
    && PATH=${HOST_PATH} make -j${THREADS} install \
    && cd ../../../.. \
    && rm -rf $(pwd)
