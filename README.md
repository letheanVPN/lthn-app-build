# Lethean builder For Release 3.1.0


```dockerfile
FROM lthn/build:release-3.1.0 as builder
# Grab project files, from context or git/curl
COPY . . 
# Perform your build
RUN set -ex && make
# Start the end image
FROM ubuntu:16:04 as image
# Grab the assets you want to bring to the new image
COPY --from=builder /build/release/bin /usr/local/bin 

```
