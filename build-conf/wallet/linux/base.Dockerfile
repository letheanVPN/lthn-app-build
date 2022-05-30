FROM ubuntu:20.04
ARG THREADS=1

ARG QT_VERSION=5.15.2

ENV CFLAGS="-fPIC"
ENV CPPFLAGS="-fPIC"
ENV CXXFLAGS="-fPIC"
ENV SOURCE_DATE_EPOCH=1397818193

RUN apt-get update
RUN apt-get install -y --no-install-recommends make build-essential automake gettext git gperf libgl1-mesa-dev libglib2.0-dev \
                   libpng12-dev libpthread-stubs0-dev libsodium-dev libtool-bin libudev-dev libusb-1.0-0-dev mesa-common-dev \
                   pkg-config python wget xutils-dev bison ca-certificates autopoint

