dizin=kur
isodizin=iso_icerik
mkdir -p $dizin
python paket_cek.py $dizin &&
chroot $dizin /bin/bash -c "rm -r /boot/boot"
chroot $dizin /bin/bash -c "service dbus on"
chroot $dizin /bin/bash -c "service dbus start"
chroot $dizin /bin/bash -c "pisi -y it -c system.base"
chroot $dizin /bin/bash -c "pisi -y it kernel"
chroot $dizin /bin/bash -c "pisi cp"
mv $dizin/etc/shadow $dizin/etc/shadow.orj
cp /etc/shadow $dizin/etc/
mv $dizin/etc/resolv.conf $dizin/etc/resolv.conf.orj
cp /etc/resolv.conf $dizin/etc/
umount $dizin/proc
umount $dizin/sys
rm -r -f $dizin/dev
mkdir -p $dizin/dev
mknod -m 600 $dizin/dev/console c 5 1
mknod -m 666 $dizin/dev/null c 1 3
mknod -m 666 $dizin/dev/random c 1 8
mknod -m 666 $dizin/dev/urandom c 1 9
chmod 777 $dizin/tmp
touch $dizin/etc/initramfs.conf
echo "liveroot=LABEL=PisiLive" > $dizin/etc/initramfs.conf
rm -r -f $dizin/var/cache/pisi/packages/*
rm -r -f $dizin/tmp/*
chroot $dizin /bin/bash -c "mkinitramfs"
mv $dizin/boot/kernel* $isodizin/boot/kernel
mv $dizin/boot/initramfs* $isodizin/boot/initrd
mksquashfs $dizin $isodizin/boot/pisi.sqfs
genisoimage -l -V PisiLive -R -J -pad -no-emul-boot -boot-load-size 4 -boot-info-table -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o pisi_test.iso $isodizin && isohybrid pisi_test.iso
