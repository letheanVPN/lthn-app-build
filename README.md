# Sponsors

Both Sponsors have free public access; meaning you are more than welcome to fork and use for yourself, for commercial projects, they have options for you too. 

## Build systems: Docker Inc
Docker Inc sponsor us with Opensource access, meaning the opensource community can leverage their very generous sponsorship, without affecting their personal quotas. 

With docker, Opensource developers have access to "pull and play" build environments, for any playform. <3 TY Docker 

![Docker](https://www.docker.com/sites/default/files/d8/2019-07/horizontal-logo-monochromatic-white.png)  

* [lthn/build](https://hub.docker.com/r/lthn/build)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [Free & Paid Information](https://www.docker.com/pricing)

## Secure Build Environments: Kasm Workspaces 

![Kasm Workspaces](https://kasmweb.com/docs/latest/_static/kasm_horizontal_logo_white.png)

With our concurrent licence sponsorship from [Kasm Workspaces](https://www.kasmweb.com/); we can not only test applications,
using [SANS SIFT Workstation](https://www.sans.org/tools/sift-workstation/);

We can build other OpenSource projects we partner / sponsor, so we can stand behind the code that produced a binary with fingerprint X; recorded in git, with its result in public domain.

folders depth to the `hour` depth of `timestamp_to_human(now)`; keyed with [mariadb](http://mariadb.com/kb/en/gtid/) - [gtid/](https://www.namebase.io/domains/gtid)



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


