ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-android-base
ARG QT_VERSION=5.15.2
ARG THREADS=1
ENV SOURCE_DATE_EPOCH=1397818193

COPY --from=${IMG_PREFIX}/build:wallet-lib-android-libx / /
COPY --from=${IMG_PREFIX}/build:wallet-lib-android-qt / /
COPY --from=${IMG_PREFIX}/build:wallet-lib-android-cmake / /
COPY --from=${IMG_PREFIX}/build:wallet-lib-android-boost / /

RUN cd tools \
    && wget -q http://dl-ssl.google.com/android/repository/tools_r25.2.5-linux.zip \
    && unzip -q tools_r25.2.5-linux.zip \
    && rm -f tools_r25.2.5-linux.zip \
    && echo y | ${ANDROID_SDK_ROOT}/tools/android update sdk --no-ui --all --filter build-tools-28.0.3

CMD set -ex \
    && cd /wallet-gui \
    && mkdir -p build/Android/release \
    && cd build/Android/release \
    && cmake \
    -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake" \
    -DCMAKE_PREFIX_PATH="${PREFIX}" \
    -DCMAKE_FIND_ROOT_PATH="${PREFIX}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DARCH="armv8-a" \
    -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_TOOLCHAIN=clang \
    -DBoost_USE_STATIC_RUNTIME=ON \
    -DLRELEASE_PATH="${PREFIX}/bin" \
    -DQT_ANDROID_APPLICATION_BINARY="lethean-wallet-gui" \
    -DWITH_SCANNER=ON \
    ../../.. \
    && PATH=${HOST_PATH} make generate_translations_header \
    && make -j${THREADS} -C src \
    && make -j${THREADS} apk
