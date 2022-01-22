FROM lthn/build:compile
WORKDIR /build
COPY ./build-src .
RUN chmod +x ./build.sh
ENTRYPOINT ["./build"]