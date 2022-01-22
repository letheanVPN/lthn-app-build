# Compile images

- `lthn/build:compile` Compile base image

## Windows

### Dockerfile
- 64: `COPY --from=lthn/build:depends-x86_64-w64-mingw32 / chain/contrib/depends`
- 32: `COPY --from=lthn/build:depends-i686-w64-mingw32 / chain/contrib/depends` 

### Commandline
- 64: `docker run -v %cd%:/build -it lthn/build:windows-64`
- 32: `docker run -v %cd%:/build -it lthn/build:windows-32`

## Linux
 
### Dockerfile
- 64: `COPY --from=lthn/build:depends-x86_64-unknown-linux-gnu / chain/contrib/depends`
- 32: `COPY --from=lthn/build:depends-i686-pc-linux-gnu / chain/contrib/depends`
- freebsd: `COPY --from=lthn/build:depends-x86_64-unknown-freebsd / chain/contrib/depends`

### Commandline
- 64: `docker run -v $(pwd):/build -it lthn/build:linux-64`
- 32: `docker run -v $(pwd):/build -it lthn/build:linux-32`
- freebsd: `docker run -v $(pwd):/build -it lthn/build:freebsd`

## ARM

### Dockerfile
- 32: `COPY --from=lthn/build:depends-arm-linux-gnueabihf / chain/contrib/depends`
- 64: `COPY --from=lthn/build:depends-aarch64-linux-gnu / chain/contrib/depends`

### Commandline
- 32: `docker run -v $(pwd):/build -it lthn/build:arm-7`
- 64: `docker run -v $(pwd):/build -it lthn/build:arm-8`

## RISCV
### Dockerfile

- 64: `COPY --from=lthn/build:depends-riscv64-linux-gnu / chain/contrib/depends`

### Commandline
- 64: `docker run -v $(pwd):/build -it lthn/build:riscv-64`

## Using the precompiled assets

```dockerfile
FROM lthn/build:compile as build

WORKDIR /lethean

COPY . .
COPY --from=lthn/build:depends-riscv64-linux-gnu --chown=root:root / /lethean/chain/contrib/depends

ARG THREADS=1

RUN git submodule update --init --force --depth 1

RUN make -j${THREADS} -C /lethean/chain depends target=riscv64-linux-gnu
    

FROM scratch as export-image
COPY --from=builder /lethean/chain/build/release/bin/ /
```

Run the above Dockerfile using the -o flag to export the 'export-image' stage to your local directory.

`docker build -o artifacts .`


