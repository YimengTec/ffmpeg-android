#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd ffmpeg

# --enable-shared LDFLAGS should be empty
LDFLAGS=""

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac

echo "${NDK_ABI} and ${CPU} and ${TARGET_OS}"

make clean

./configure \
--target-os="$TARGET_OS" \
--cross-prefix="$CROSS_PREFIX" \
--arch="$NDK_ABI" \
--enable-cross-compile \
--enable-runtime-cpudetect \
--sysroot="$NDK_SYSROOT" \
--enable-pic \
--enable-libx264 \
--enable-pthreads \
--enable-version3 \
--enable-hardcoded-tables \
--enable-gpl \
--enable-yasm \
--enable-shared \
--disable-static \
--disable-debug \
--disable-doc \
--disable-ffmpeg \
--disable-ffserver \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-symver \
--pkg-config="${2}/ffmpeg-pkg-config" \
--prefix="${2}/build/${1}" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS" \
--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-libs="-lm" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

make -j${NUMBER_OF_CORES} && make install || exit 1

popd
