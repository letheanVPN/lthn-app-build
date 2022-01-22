FROM lthn/build:compile as build

ARG BRANCH=next
ARG BUILD=osx
ARG GIT_REPO=https://gitlab.com/lthn.io/projects/chain/lethean.git
ARG BUILD_PATH=/lethean/chain/contrib/depends

ENV PACKAGE=""

RUN git clone --depth 1 --branch ${BRANCH} ${GIT_REPO} && \
        make -C ${BUILD_PATH} download-${BUILD}

FROM scratch as export-image
COPY --from=build /lethean/chain/contrib/depends/sources /
