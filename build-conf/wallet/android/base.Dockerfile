FROM debian:stretch as base

ARG THREADS=1
ARG ANDROID_NDK_REVISION=21d
ARG ANDROID_NDK_HASH=bcf4023eb8cb6976a4c7cff0a8a8f145f162bf4d
ARG ANDROID_SDK_REVISION=4333796
ARG ANDROID_SDK_HASH=92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9
ARG QT_VERSION=5.15.2

WORKDIR /opt/android
ENV WORKDIR=/opt/android

ENV ANDROID_NATIVE_API_LEVEL=28
ENV ANDROID_API=android-${ANDROID_NATIVE_API_LEVEL}
ENV ANDROID_CLANG=aarch64-linux-android${ANDROID_NATIVE_API_LEVEL}-clang
ENV ANDROID_CLANGPP=aarch64-linux-android${ANDROID_NATIVE_API_LEVEL}-clang++
ENV ANDROID_NDK_ROOT=${WORKDIR}/android-ndk-r${ANDROID_NDK_REVISION}
ENV ANDROID_SDK_ROOT=${WORKDIR}/tools
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=${JAVA_HOME}/bin:${PATH}
ENV PREFIX=${WORKDIR}/prefix
ENV TOOLCHAIN_DIR=${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64

RUN apt-get update \
    && apt-get install -y ant automake build-essential ca-certificates-java file gettext git libc6 libncurses5 \
    libssl-dev libstdc++6 libtinfo5 libtool libz1 openjdk-8-jdk-headless openjdk-8-jre-headless pkg-config python3 \
    unzip wget && rm -rf /var/lib/apt/lists/*

RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_REVISION}.zip \
    && unzip -q sdk-tools-linux-${ANDROID_SDK_REVISION}.zip \
    && rm -f sdk-tools-linux-${ANDROID_SDK_REVISION}.zip

RUN wget -q https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip \
    && unzip -q android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip \
    && rm -f android-ndk-r${ANDROID_NDK_REVISION}-linux-x86_64.zip

RUN cd ${ANDROID_SDK_ROOT} && echo y | ./bin/sdkmanager "platform-tools" "platforms;${ANDROID_API}" "tools" > /dev/null
RUN cp -r ${WORKDIR}/platforms ${WORKDIR}/platform-tools ${ANDROID_SDK_ROOT}

ENV HOST_PATH=${PATH}
ENV PATH=${TOOLCHAIN_DIR}/aarch64-linux-android/bin:${TOOLCHAIN_DIR}/bin:${PATH}
