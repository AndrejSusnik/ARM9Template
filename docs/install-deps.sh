#!/bin/bash

if [[ $UID != 0 ]]; then
    echo "Ta skripta potrebuje skrbniške pravice za delovanje. Poženite jo kot skrbnik:"
    echo "sudo $0 $*"
    exit 1
fi

echo "Prenašanje in inštalacija GCC za ARM"
wget -q --show-progress https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -P /temp 

tar -xf /temp/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C /temp >/dev/null 2>&1
mv /temp/gcc-arm-none-eabi-10.3-2021.10 /usr/share

ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gdb /usr/bin/arm-none-eabi-gdb
ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-ld /usr/bin/arm-none-eabi-ld
ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-objcopy /usr/bin/arm-none-eabi-objcopy
ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-gcc
ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-g++ /usr/bin/arm-none-eabi-g++
ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-objdump /usr/bin/arm-none-eabi-objdump
ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-size /usr/bin/arm-none-eabi-size
ln -s /usr/share/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-nm /usr/bin/arm-none-eabi-nm

echo "Prenašanje instalacija emulatorja ARM procesorja"
wget -q --show-progress https://github.com/xpack-dev-tools/qemu-arm-xpack/releases/download/v7.1.0-1/xpack-qemu-arm-7.1.0-1-linux-x64.tar.gz -P /temp
    
mkdir -p ~/.local/xPacks/qemu-arm
cd ~/.local/xPacks/qemu-arm

tar xvf /temp/xpack-qemu-arm-7.1.0-1-linux-x64.tar.gz >/dev/null 2>&1
chmod -R -w xpack-qemu-arm-7.1.0-1
    
ln -s ~/.local/xPacks/qemu-arm/xpack-qemu-arm-7.0.0-1/bin/qemu-system-gnuarmeclipse /usr/bin/qemu-system-gnuarmeclipse
