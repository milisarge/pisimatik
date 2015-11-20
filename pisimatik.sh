repo=$1
kurpak=$2
dizin=kur
isodizin=iso_icerik
#temel chroot ortaminin olusturulmasi
python rootfs_olustur.py $dizin $repo &&

#gerekli servislerin baslatilmasi
chroot $dizin /bin/bash -c "rm -r /boot/boot"
chroot $dizin /bin/bash -c "service dbus on"
chroot $dizin /bin/bash -c "service dbus start"

#base sistemin kurulumu
#chroot $dizin /bin/bash -c "pisi -y it -c system.base"
chroot $dizin /bin/bash -c "pisi rm mkinitramfs --ignore-safe --ignore-dep"
chroot $dizin /bin/bash -c "pisi -y it kernel --ignore-dep"


#dracut uzak entegre1
#dracutlink="xxx"
#curl $dracutlink -o dracut.tar.xz
#tar xf dracut.tar.xz -C paket/

#dracut lokal entegre1
rsync -av paket/dracut/ $dizin/opt
chroot $dizin /bin/bash -c "pisi -y it /opt/*.pisi"

while read p; do
  chroot $dizin /bin/bash -c "pisi -y it ""$p"
done < $kurpak

#chroot ayirma-umount
umount $dizin/proc
umount $dizin/sys 

#paket ayarlama
#chroot $dizin /bin/bash -c "pisi cp"
rm -r $dizin/boot/initramfs*

#repo olusturma
#chroot $dizin /bin/bash -c "cd /var/cache/pisi/packages/ && pisi ix . --skip-signing"
#mkdir -p $isodizin/repo
#rsync -av $dizin/var/cache/pisi/packages/ $isodizin/repo

#mevcut parola dosyasinin aktarilmasi
mv $dizin/etc/shadow $dizin/etc/shadow.orj
cp /etc/shadow $dizin/etc/
#fstab ayarlama
#mv $dizin/etc/fstab $dizin/etc/fstab.orj
#cp eklenti/fstab $dizin/etc/
cp eklenti/tamir $dizin/usr/local/bin/
cp eklenti/tint2rc $dizin/opt/

#ikon ayarlama 
chroot $dizin /bin/bash -c "mkdir -p /root/.icons"
chroot $dizin /bin/bash -c "mkdir -p /root/.icons/default"
chroot $dizin /bin/bash -c "mkdir -p /root/.icons/default/cursors"
chroot $dizin /bin/bash -c "ln -s /usr/share/icons/Adwaita/cursors /root/.icons/default/"

#dns sunucu ayarlama
mv $dizin/etc/resolv.conf $dizin/etc/resolv.conf.orj
cp /etc/resolv.conf $dizin/etc/

#cache yedekleme
rsync -av $dizin/var/cache/pisi/packages/* paket/



rm -r -f $dizin/dev
mkdir -p $dizin/dev
mknod -m 600 $dizin/dev/console c 5 1
mknod -m 666 $dizin/dev/null c 1 3
mknod -m 666 $dizin/dev/random c 1 8
mknod -m 666 $dizin/dev/urandom c 1 9

chmod 777 $dizin/tmp
#mkinitramfs eski
#touch $dizin/etc/initramfs.conf
#echo "liveroot=LABEL=PisiLive" > $dizin/etc/initramfs.conf
masakos="startlxqt"
echo "exec "$masakos > $dizin/root/.xinitrc

rm -r -f $dizin/var/cache/pisi/packages/*
rm -r -f $dizin/tmp/*

#mkinitramfs eski
#chroot $dizin /bin/bash -c "mkinitramfs"
#dracut entegre2


mkdir -p $dizin/usr/lib/dracut/modules.d/01milis
cp dracut/* $dizin/usr/lib/dracut/modules.d/01milis/
chroot $dizin /bin/bash -c "mkdir -p /run/lock/files.ldb && touch /run/lock/files.ldb/LOCK"
chroot $dizin /bin/bash -c "chmod +x /usr/local/bin/tamir"
chroot $dizin /bin/bash -c "service xdm start"
chroot $dizin /bin/bash -c "dracut -N --xz --force-add milis --omit systemd /boot/initramfs.img 3.19.8"

mv $dizin/boot/kernel* $isodizin/boot/kernel
mv $dizin/boot/initramfs* $isodizin/boot/initrd

#eski vers.
#mksquashfs $dizin $isodizin/boot/pisi.sqfs
./squash.sh
genisoimage -l -V PisiLive -R -J -pad -no-emul-boot -boot-load-size 4 -boot-info-table -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o milis_pisi.iso $isodizin && isohybrid milis_pisi.iso
