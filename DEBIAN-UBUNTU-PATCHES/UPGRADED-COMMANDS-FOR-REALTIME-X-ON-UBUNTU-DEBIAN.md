### NEEDS-FIX = Look On The Video On My Channel For A Temporary Solution ###

#SET MODPROBED-DB
cd /usr/src
git clone --depth=1 https://github.com/graysky2/modprobed-db.git -b master MODPROBED-DB
cd MODPROBED-DB ; make ; make install
which modprobed-db ; modprobed-db
modprobed-db store

echo "#- Install Build System -#"

apt-get build-dep linux linux-image-$(uname -r)
apt-get install git build-essential kernel-package fakeroot libncurses5-dev libssl-dev
apt-get install ccache bison flex libncurses-dev flex bison openssl libssl-dev dkms 
apt-get install libelf-dev libudev-dev libpci-dev libiberty-dev autoconf

cd /usr/src


echo "#- Download And Unpack REALTIME-X Sources -#"

wget https://github.com/javashin/REALTIME-X/archive/master.zip
unzip master.zip
mv REALTIME-X-master linux-5.4.7-rtjsX

ln -s /usr/src/linux-5.4.7-rt-jsX /usr/src/linux

echo "#- Patch Kernel For Ubuntu -#"

cd /usr/src/linux

sed -i 's/-rt-jsX/-rt-jsx/g' Makefile

patch -p1 -i DEBIAN-UBUNTU-PATCHES/0001*.patch
patch -p1 -i DEBIAN-UBUNTU-PATCHES/0002*.patch
patch -p1 -i DEBIAN-UBUNTU-PATCHES/0003*.patch
patch -p1 -i DEBIAN-UBUNTU-PATCHES/0004*.patch
patch -p1 -i DEBIAN-UBUNTU-PATCHES/0005*.patch


echo "#- Pre-Configure-Kernel-For-ZFS INSTALL -#"

cd /usr/src/linux
make mrproper
mkdir Ununtu-PPA
cd Ubuntu-PPA
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.7/linux-headers-5.4.7-050407_5.4.7-050407.201912311234_all.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.7/linux-headers-5.4.7-050407-generic_5.4.7-050407.201912311234_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.7/linux-headers-5.4.7-050407-lowlatency_5.4.7-050407.201912311234_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.7/linux-image-unsigned-5.4.7-050407-generic_5.4.7-050407.201912311234_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.7/linux-image-unsigned-5.4.7-050407-lowlatency_5.4.7-050407.201912311234_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.7/linux-modules-5.4.7-050407-generic_5.4.7-050407.201912311234_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.7/linux-modules-5.4.7-050407-lowlatency_5.4.7-050407.201912311234_amd64.deb
dpkg -i *.deb
cd ..
cp /boot/config-5.4.7*-lowlatency	/usr/src/linux/.config
make olddefconfig prepare

echo "#- ZFS-MODULES-SOURCE-INJECTION -#"

cd /usr/src

git clone --depth=1 https://github.com/zfsonlinux/zfs.git -b master ZFS-MASTER

cd ZFS-MASTER

NOCONFIGURE=1 ./autogen.sh

./configure --build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu --disable-dependency-tracking --disable-silent-rules --with-config=kernel --with-linux=/usr/src/linux --with-linux-obj=/usr/src/linux --disable-debug --enable-linux-builtin

./copy-builtin /usr/src/linux

cd /usr/src/linux

cp /boot/config-5.4.7*-lowlatency /usr/src/linux/.config

make oldconfig prepare

modprobed-db
modprobed-db store
modprobed-db recall

make /home/javashin/.config/modprobed.db localmodconfig

echo "#- Configure The Kernel -#"

make nconfig

echo "#- For More Optimizations for Intel use : export KCFLAGS=-march=native -O3 -falign-functions=32 -fno-stack-protector -fstrict-aliasing -pipe -#"


echo "#- Compile with #time make -j5 V=1 deb-pkg# -#"

echo "#- Install With #dpkg -i linux-headers-5.4.7-rt-jsx_5.4.7-rt-jsx-1_amd64.deb linux-image-5.4.7-rt-jsx_5.4.7-rt-jsx-1_amd64.deb linux-libc-dev_5.4.7-rt-jsx-1_amd64.deb# -#"
