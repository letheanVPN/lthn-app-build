ARG IMG_PREFIX=lthn
FROM ${IMG_PREFIX}/build:wallet-linux-base as build
ARG THREADS=1

RUN find /usr -type f > /files-to-delete.txt

RUN git clone -b release-64-2 --depth 1 https://github.com/unicode-org/icu && \
    cd icu/icu4c/source && \
    git reset --hard e2d85306162d3a0691b070b4f0a73e4012433444 && \
    ./configure --disable-shared --enable-static --disable-tests --disable-samples && \
    make -j$THREADS && \
    make -j$THREADS install

RUN wget https://downloads.sourceforge.net/project/boost/boost/1.73.0/boost_1_73_0.tar.gz && \
    echo "9995e192e68528793755692917f9eb6422f3052a53c5e13ba278a228af6c7acf boost_1_73_0.tar.gz" | sha256sum -c && \
    tar -xzf boost_1_73_0.tar.gz && \
    rm boost_1_73_0.tar.gz && \
    cd boost_1_73_0 && \
    ./bootstrap.sh && \
    ./b2 --with-atomic --with-system --with-filesystem --with-thread --with-date_time --with-chrono --with-regex --with-serialization --with-program_options --with-locale variant=release link=static runtime-link=static cflags="${CFLAGS}" cxxflags="${CXXFLAGS}" install -a --prefix=/usr && \
    rm -rf $(pwd)

RUN cat /files-to-delete.txt | xargs rm -f

FROM scratch
COPY --from=build /usr /usr
