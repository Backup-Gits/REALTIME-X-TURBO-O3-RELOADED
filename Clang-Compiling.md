Dirty Way To Add ZFS Git Master To The Kernel And Compile With Clang HoW-TO :::

clone the repo and copy to /usr/src with the name linux-5.4.7-rt-jsX or what ever after edit Makefile
eselect set kernel linux-5.4.7-rt-jsX

echo "Prepare Kernel for ZFS with GCC Dont Add Full Realtime RT Yet"

cd /usr/src/linux
make mrproper
zcat /proc/config.gz >> .config
make oldconfig prepare 

echo "Inject ZFS To The Kernel"

env EXTRA_ECONF='--enable-linux-builtin' ebuild /var/db/repos/gentoo/sys-fs/zfs-kmod/zfs-kmod-9999.ebuild clean configure
(cd /var/tmp/portage/sys-fs/zfs-kmod-9999/work/zfs-kmod-9999/ && ./copy-builtin /usr/src/linux)
cd /usr/src/linux

echo "Export Compiler Flags + Optimizations for Intel Env-Vars For Clang And ld.lld Linker"

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
export CFLAGS="-O3 -march=native -falign-functions=32 -fno-stack-protector -fomit-frame-pointer -fstrict-aliasing -pipe"
export CXXFLAGS="${CFLAGS}"
export FCFLAGS="${CFLAGS}"
export FFLAGS="${CFLAGS}"
export CPPFLAGS="${CFLAGS}"
export KCFLAGS="-march=native -O3 -falign-functions=32 -fno-stack-protector -fstrict-aliasing -pipe"
export LDFLAGS="-Wl,-O2 -Wl,--as-needed,-z,now -fuse-ld=lld -Wl,--hash-style=gnu"

echo "Time To Configure The Kernel Select ZFS And RT And Other Options"
source /etc/profile ; env-update
zcat /proc/config.gz >> .config
make CC=clang LD=ld.lld oldconfig prepare nconfig
time make V=1 -j5 CC=clang LD=ld.lld all ; make install ; make mdoules_install  

