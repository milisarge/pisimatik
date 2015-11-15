repo=$1
dizin=kur
isodizin=iso_icerik
#temel chroot ortaminin olusturulmasi
python rootfs_olustur.py $dizin $repo &&

#gerekli servislerin baslatilmasi
chroot $dizin /bin/bash -c "rm -r /boot/boot"
chroot $dizin /bin/bash -c "service dbus on"
chroot $dizin /bin/bash -c "service dbus start"

#base sistemin kurulumu
chroot $dizin /bin/bash -c "pisi -y it -c system.base"
chroot $dizin /bin/bash -c "pisi -y it kernel"

#x11 kurulum
chroot $dizin /bin/bash -c "pisi -y it -c x11.server"
chroot $dizin /bin/bash -c "pisi -y it xorg-video-vesa"
chroot $dizin /bin/bash -c "pisi -y it xorg-video-vmware"
chroot $dizin /bin/bash -c "pisi -y it xorg-input-vmmouse"
chroot $dizin /bin/bash -c "pisi -y it xorg-input-evdev"
chroot $dizin /bin/bash -c "pisi -y it xorg-input-kbd"
chroot $dizin /bin/bash -c "pisi -y it xorg-input-mouse"
chroot $dizin /bin/bash -c "pisi -y it xkeyboard-config"
chroot $dizin /bin/bash -c "pisi -y it xinit"

#lxde masa kurulum
chroot $dizin /bin/bash -c "pisi -y it -c desktop.xfce"
#chroot $dizin /bin/bash -c "pisi -y it -c desktop.xfce4"
#chroot $dizin /bin/bash -c "pisi -y it -c desktop.mate"
#chroot $dizin /bin/bash -c "pisi -y it -c desktop.kde"

#giris yoneticisi kurulum
chroot $dizin /bin/bash -c "pisi -y it lxdm"

#paket ayarlama
chroot $dizin /bin/bash -c "pisi cp"

#mevcut parola dosyasinin aktarilmasi
mv $dizin/etc/shadow $dizin/etc/shadow.orj
cp /etc/shadow $dizin/etc/

#dns sunucu ayarlama
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
rsync -av $dizin/var/cache/pisi/packages/* paket/
rm -r -f $dizin/var/cache/pisi/packages/*
rm -r -f $dizin/tmp/*
chroot $dizin /bin/bash -c "mkinitramfs"
mv $dizin/boot/kernel* $isodizin/boot/kernel
mv $dizin/boot/initramfs* $isodizin/boot/initrd
mksquashfs $dizin $isodizin/boot/pisi.sqfs
genisoimage -l -V PisiLive -R -J -pad -no-emul-boot -boot-load-size 4 -boot-info-table -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o milis_pisi2.0.iso $isodizin && isohybrid milis_pisi2.0.iso
