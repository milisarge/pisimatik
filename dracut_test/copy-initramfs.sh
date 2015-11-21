#!/bin/sh

# Copy the initramfs back to the new rootfs for proper shutdown.

cp /run/initramfs/live/boot/initrd $NEWROOT/boot/initrd

