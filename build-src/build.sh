#!/usr/bin/env bash

BUILD_TARGET=x86_64-unknown-linux-gnu

if [[ -n $2 ]]; then
  case $2 in
  "win64")
  BUILD_TARGET=x86_64-w64-mingw32
  ;;
  "win32")
  BUILD_TARGET=i686-w64-mingw32
  ;;
  "macos")
  BUILD_TARGET=x86_64-apple-darwin11
  ;;
  "arm7")
  BUILD_TARGET=arm-linux-gnueabihf
  ;;
  "arm8")
  BUILD_TARGET=aarch64-linux-gnu
  ;;
  "riscv")
  BUILD_TARGET=riscv64-linux-gnu
  ;;
  "freebsd")
  BUILD_TARGET=x86_64-unknown-freebsd
  ;;
  "linux64")
  BUILD_TARGET=x86_64-unknown-linux-gnu
  ;;
  "linux32")
  BUILD_TARGET=i686-pc-linux-gnu
  ;;
esac
fi

echo "Lethean Builder Running Command \"$1\" for: ${BUILD_TARGET}"

case $1 in
"chain")
  shift
  rm src/.lthnkeep || echo "Could not delete .lthnkeep from build directory, not an error if this builds"
  git clone --depth 1 --recursive --branch next https://gitlab.com/lthn.io/projects/chain/lethean.git /lethean
  make -C /lethean/chain depends root=/depends target=$BUILD_TARGET
  ;;

*)
 echo "chain"
  ;;

esac
