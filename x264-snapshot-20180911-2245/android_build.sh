#!/bin/sh
ANDROID_NDK="/home/cq/Android/Sdk/ndk-bundle"
SDK_VERSION=28
#ARCH=arm64
ARCH=arm

if [ "$ARCH" = "arm64" ]
then
    PLATFORM_PREFIX="aarch64-linux-android-"
    HOST="aarch64"
    PLATFORM_VERSION=4.9
else
    PLATFORM_PREFIX="arm-linux-androideabi-"
    HOST="arm"
    PLATFORM_VERSION=4.9
fi

PREFIX=$(pwd)/android/${ARCH}

SYSROOT=$ANDROID_NDK/platforms/android-${SDK_VERSION}/arch-${ARCH}
TOOLCHAIN=$ANDROID_NDK/toolchains/${PLATFORM_PREFIX}${PLATFORM_VERSION}/prebuilt/linux-x86_64
CC=c$TOOLCHAIN/bin/${PLATFORM_PREFIX}gcc
CXX=$TOOLCHAIN/bin/${PLATFORM_PREFIX}c++
CROSS_PREFIX=$TOOLCHAIN/bin/${PLATFORM_PREFIX}
NM=$TOOLCHAIN/bin/${PLATFORM_PREFIX}nm

./configure \
    --prefix=$PREFIX \
    --cross-prefix=$CROSS_PREFIX \
    --sysroot=$SYSROOT \
    --host=arm-linux \
    --prefix=$PREFIX \
    --enable-static \
    --enable-pic \
    --disable-asm \
    --disable-cli \
    --host=arm-linux \
