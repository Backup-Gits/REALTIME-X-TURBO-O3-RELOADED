#!/bin/bash

#  find . -type f -name "*.rej" orig

time cd /usr/src/linux

time make CC=gcc LD=ld.bfd mrproper

time cp config-rt .config

time make CC=gcc LD=ld.bfd oldconfig prepare

time sleep 2

time source /etc/profile ; time env-update

time clear

echo "Export Clang Env Vars"

export CC="clang"
export CXX="clang++"
export LD="ld.lld"
export AR="llvm-ar"
export AS="clang"
export NM="llvm-nm"
export RANLIB="llvm-ranlib"
export STRIP="llvm-strip"
export OBJCOPY="llvm-objcopy"
export OBJDUMP="llvm-objdump"
export HOSTCC="clang"
export HOSTLD="ld.lld"
export HOSTAR="llvm-ar"
export CFLAGS="-O3 -march=haswell -fno-stack-protector -pipe"
export CXXFLAGS="${CFLAGS}"
export FCFLAGS="${CFLAGS}"
export FFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export KCFLAGS="-O3 -march=haswell -fno-stack-protector -pipe"
export LDFLAGS="-Wl,-O2 -Wl,--as-needed,-z,now -fuse-ld=lld -Wl,--hash-style=gnu"


#time make CC=clang LD=ld.lld oldconfig  #V=0 -j5 LLVM=1 LLVM_IAS=1 CROSS_COMPILE=x86_64-pc-linux-gnu- CLANG_TRIPLE=x86_64-pc-linux-gnu- oldconfig prepare nconfig
#clear#sleep 3#time make CC=clang LD=ld.lld #V=0 -j5 LLVM=1 LLVM_IAS=1 CROSS_COMPILE=x86_64-pc-linux-gnu- CLANG_TRIPLE=x86_64-pc-linux-gnu-
time clear ; time sleep 3 ; time date


time make CC=clang LD=ld.lld oldconfig


time make CC=clang LD=ld.lld -j5 bzImage modules install modules_install headers_install

