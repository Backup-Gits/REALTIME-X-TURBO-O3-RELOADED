# REALTIME-X-SOURCES

Pre-Patched Linux Kernel Sources REALTIME-X
Total Rework Update to 5.4.7 Stable Kernel LTS.
Update 1 < > Added union Aufs Patches For 5.4 Kernel , more.


This Linux Kernel Have Some Additions That Are Not In The Main Tree.
Some Of Them Are Optimizations And New Features Like : >

1. CONFIG_PREEMPT_RT Patches > https://rt.wiki.kernel.org/index.php/Main_Page
   
   * Selecting Expert Mode In Kernel Config To Make The Linux Kernel Full Realtime

2. ZEN-SOURCES -ZEN Patches > https://github.com/zen-kernel/zen-kernel
   
   * ZEN-INTERACTIVE
   
   * mm-Proactive-compaction
   
   * ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-C 
   
3. Con Kolivas -CK Patches > http://ck-hack.blogspot.com/ 
   
   * MuQSS version 0.196 for linux-5.4 Multiple Queue Skiplist Scheduler As An Optional Choice.

4. Distro Specific Patches ArchLinux + Gentoo/Linux + Debian/Ubuntu + Intel Clear/Linux.

5. Added Script To Debloat The Linux Kernel And Free It Of Privative Firmware And Convert It Into -libre -gnu Linux.

6. Some Optimizations And Fixes Added .
  
   * LL-kconfig-add-750Hz-timer-interrupt-kernel-config Thanks To Piotr Górski .
  
   * zswap-b-tree.patch
  
   * turbosched-v4.patch
  
   * ZFS-fix.patch
  
   * -O3 patch To Compile With The Level 3 Of Compilers Optimizations.
  
   * graysky's GCC patch To Be Able To Select -march=native.
  
   * ksm-patches.patch userspace-assisted KSM Thanks To  Oleksandr Natalenko .

7. Wireward Patches Updates For 5.4 Kernel. 
   
   https://www.wireguard.com/

8. UnionFS AUFS

9. Conflict Fixing ETC.
   Carlos Jimenez (JavaShin-X) 2020.

* COPYING. =

The Linux Kernel is provided under:

	SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note

Being under the terms of the GNU General Public License version 2 only,
according with:

	LICENSES/preferred/GPL-2.0

With an explicit syscall exception, as stated at:

	LICENSES/exceptions/Linux-syscall-note

In addition, other licenses may also apply. Please see:

	Documentation/process/license-rules.rst

for more details.

### For Gentoo/Linux Only ###
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











