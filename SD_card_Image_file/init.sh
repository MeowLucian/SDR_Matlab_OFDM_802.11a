#!/bin/sh

cd /mnt

dmesg -n 8
echo 5 > /proc/sys/kernel/printk

echo "Configure network"
if [ -f /mnt/newip.sh ]; then
    source /mnt/newip.sh
else
    # Flush existing config
    ip addr flush dev eth0
    ip link set dev eth0 down
    # Set up new config
    ip addr add 192.168.3.2/24 dev eth0
    ip route add default via 192.168.3.1
    ip link set dev eth0 up
fi

echo "setting recv socket buffer limit to 1048576"
sysctl -w net.core.rmem_max=1048576 
echo "setting send socket buffer limit to 1048576"
sysctl -w net.core.wmem_max=1048576 
# Create device to program PL
# http://www.xilinx.com/support/answers/46913.html

if [ ! -e /dev/xdevcfg ]; then
    echo "Creating special character device for programming FPGA"
    mknod /dev/xdevcfg c 259 0 > /dev/null 
fi

if [ -f /mnt/system.bin ]; then
    echo "Programming bitstream"
    cat /mnt/system.bin > /dev/xdevcfg
    echo "Done programming bitstream"
else
    echo "No system.bin file found"
    exit 1
fi

echo "Load Kernel modules"

if [ -f /mnt/xilinx_axidma.ko ]; then
    insmod /mnt/xilinx_axidma.ko
else
    echo "xilinx_axidma.ko not found"
    exit 1
fi

if [ -f /mnt/mwadma.ko ]; then
    insmod /mnt/mwadma.ko
else
    echo "mwadma.ko not found"
    exit 1
fi

sleep 1
mdev -s

if [ -f /mnt/sdr_firmware.elf ]; then
    taskset 2 /mnt/sdr_firmware.elf
else
    echo "sdr_firmware.elf not found"
    exit 1
fi
