#!/bin/bash

X264_VERSION=""
SHELL_PATH=`pwd`
X264_PATH=$SHELL_PATH/
#输出路径
PREFIX=$SHELL_PATH/x264_android
LAST_VERSION=$1
ANDROID_API=$2
NDK=$3
 
#需要编译的Android API版本，21以及以上才有arm64 和 x86_64版本
if [ ! "$ANDROID_API" ]
then
ANDROID_API=21
fi
#需要编译的NDK路径，NDK版本需大等于r15
if [ ! "$NDK" ]
then
NDK=/home/cq/Android/Sdk/ndk-bundle
fi
echo ANDROID_API=$ANDROID_API
echo NDK=$NDK
 
#需要编译的平台:arm arm64 x86 x86_64
ARCHS=(arm arm64 x86 x86_64)
TRIPLES=(arm-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android)
TRIPLES_PATH=(arm-linux-androideabi-4.9 aarch64-linux-android-4.9 x86-4.9 x86_64-4.9)
 
FF_CONFIGURE_FLAGS="--enable-static --enable-pic --disable-cli --disable-asm"
 


for i in "${!ARCHS[@]}";
do
    ARCH=${ARCHS[$i]}
    TOOLCHAIN=$NDK/toolchains/${TRIPLES_PATH[$i]}/prebuilt/linux-x86_64
    SYSROOT=$NDK/platforms/android-$ANDROID_API/arch-$ARCH/
    ISYSROOT=$NDK/sysroot
    ASM=$ISYSROOT/usr/include/${TRIPLES[$i]}
    CROSS_PREFIX=$TOOLCHAIN/bin/${TRIPLES[$i]}-
    PREFIX_ARCH=$PREFIX/$ARCH
 
    FF_CFLAGS="-I$ASM -isysroot $ISYSROOT -D__ANDROID_API__=$ANDROID_API -U_FILE_OFFSET_BITS -DANDROID"
 
    ./configure \
    --prefix=$PREFIX_ARCH \
    --sysroot=$SYSROOT \
    --host=${TRIPLES[$i]} \
    --cross-prefix=$CROSS_PREFIX \
    $FF_CONFIGURE_FLAGS \
    --extra-cflags="$FF_CFLAGS" \
    --extra-ldflags="" \
    $ADDITIONAL_CONFIGURE_FLAG || exit 1
    make -j3 install || exit 1
    make distclean
    rm -rf "$PREFIX_ARCH/lib/pkgconfig"
    if [[ $FF_CONFIGURE_FLAGS == *--enable-shared* ]]
    then
        mv $PREFIX_ARCH/lib/libx264.so.* $PREFIX_ARCH/lib/libx264.so
    fi
done
 
echo "Android x264 bulid success!"

