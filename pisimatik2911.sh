repo=$1
kurpak=$2
dizin=kur
isodizin=iso_icerik
root="root"
root_pass="toor"
hostname="pisilinux"
live_kul="pisix"
live_pass="pisix"
usershell=/bin/bash
masa="kde"
iso_etiket="PisiLive"
iso_isim="pisi"
kernelno="4.2.6"
#kernelno="3.19.8"
bos_imaj="/opt/ext3fs.img"

mesaj () {
    printf "\033[1m$@\n\033[m"
}

rootfs_olustur () {
	python rootfs_olustur.py $dizin $repo
}

servis_baslat () {
	chroot $dizin /bin/bash -c "rm -r /boot/boot"
	chroot $dizin /bin/bash -c "service dbus on"
	chroot $dizin /bin/bash -c "service dbus start"
}

kernel_kur (){
	#base sistemin kurulumu
	chroot $dizin /bin/bash -c "pisi -y it -c system.base"
	chroot $dizin /bin/bash -c "pisi -y it kernel --ignore-dep"	
	chroot $dizin /bin/bash -c "pisi rm mkinitramfs --ignore-safety --ignore-dep"
}

initrd_kur () {
	#dracut uzak entegre1
	#dracutlink="xxx"
	#curl $dracutlink -o dracut.tar.xz
	#tar xf dracut.tar.xz -C paket/

	#dracut lokal entegre1
	rsync -av paket/dracut/ $dizin/opt
	chroot $dizin /bin/bash -c "pisi -y it /opt/*.pisi"
}

paket_kur () {
	while read p; do
	  chroot $dizin /bin/bash -c "pisi -y it ""$p"
	done < $kurpak
}
chroot_ayir () {
	umount $dizin/proc
	umount $dizin/sys 
}

ayarlar () {
	#chroot $dizin /bin/bash -c "pisi cp"
	rm -r $dizin/boot/initramfs*
	#hostname 
	echo $hostname > $dizin/etc/hostname
	#mevcut parola dosyasinin aktarilmasi
	chroot $dizin /bin/bash -c "useradd -m -c $root -G root -s $usershell $root"

    chroot $dizin /bin/bash -c "groupadd -g 18 messagebus"
    chroot $dizin /bin/bash -c "useradd -m -d /var/run/dbus -r -s /bin/false -u 18 -g 18 messagebus -c D-Bus Message Daemon"
    chroot $dizin /bin/bash -c "/sbin/ldconfig -X"
    
    chroot $dizin /bin/bash -c "/usr/bin/udevadm hwdb --update"
	
	chroot $dizin /bin/bash -c  "useradd -m -c $live_kul -G sudo,audio,video,cdrom,wheel -s $usershell $live_kul"
	chroot $dizin /bin/bash -c  "passwd -d $live_kul >/dev/null 2>&1"
	# Setup default root/user password (pisilinux).
	#iptal gcc
	chroot $dizin sh -c "echo "$root:$root_pass" | chpasswd -c SHA512"
	chroot $dizin sh -c "echo "$live_kul:$live_pass" | chpasswd -c SHA512"
	#fstab ayarlama
	#cp eklenti/fstab $dizin/etc/
	cp eklenti/tamir $dizin/usr/local/bin/
	#dns sunucu ayarlama
	mv $dizin/etc/resolv.conf $dizin/etc/resolv.conf.orj
	cp /etc/resolv.conf $dizin/etc/
	chroot $dizin /bin/bash -c "pisi -y it avahi"
	#ikon ayarlama 
	chroot $dizin /bin/bash -c "mkdir -p /root/.icons"
	chroot $dizin /bin/bash -c "mkdir -p /root/.icons/default"
	chroot $dizin /bin/bash -c "mkdir -p /root/.icons/default/cursors"
	chroot $dizin /bin/bash -c "ln -s /usr/share/icons/Adwaita/* /root/.icons/default/"
	chroot $dizin /bin/bash -c "pisi rm sddm --ignore-safety --ignore-dep"
}

aygit_ayar () {
	rm -r -f $dizin/dev
	mkdir -p $dizin/dev
	#mknod -m 600 $dizin/dev/console c 5 1
	#mknod -m 666 $dizin/dev/null c 1 3
	#mknod -m 666 $dizin/dev/random c 1 8
	#mknod -m 666 $dizin/dev/urandom c 1 9
	chmod 777 $dizin/tmp
} 

depo_yedekle () {
	rsync -av $dizin/var/cache/pisi/packages/* paket/
}

masa_ayarla () {
	echo "exec start"$masa > $dizin/root/.xinitrc
	echo "exec start"$masa > $dizin/home/$live_kul/.xinitrc
	echo "masa ayarlandı"
}

dosya_temizlik () {
	rm -r -f $dizin/var/cache/pisi/packages/*
	rm -r -f $dizin/tmp/*
}

initrd_olustur () {
	mkdir -p $dizin/usr/lib/dracut/modules.d/01milis
	cp dracut/* $dizin/usr/lib/dracut/modules.d/01milis/
	chroot $dizin /bin/bash -c "chmod +x /usr/local/bin/tamir"
	#chroot $dizin /bin/bash -c "service xdm on"
	#chroot $dizin /bin/bash -c "service sddm on"
	#chroot $dizin /bin/bash -c "/sbin/ldconfig"
    chroot $dizin /bin/bash -c "modprobe dm_multipath"
    chroot $dizin /bin/bash -c "modprobe usb_storage"
    chroot $dizin /bin/bash -c "udevadm hwdb --update"
    chroot $dizin /bin/bash -c "/sbin/depmod "$kernelno
	#kernelno=ls /boot/kernel* | xargs -n1 basename | sort -rV | head -1 | sed 's/kernel-//'
	#chroot $dizin /bin/bash -c "dracut -N --xz --force-add milis --omit systemd /boot/initramfs.img "$kernelno
	chroot $dizin /bin/bash -c "dracut --no-hostonly-cmdline -N --force --xz --force-add milis --add pollcdrom --add-drivers 'dm_multipath squashfs ext3 ext2 vfat msdos sr_mod sd_mod ehci_hcd uhci_hcd xhci_hcd xhci_pci ohci_hcd usb_storage usbhid dm_mod device-mapper ata_generic libata' /boot/initramfs.img "$kernelno
	
}

iso_ayarla () {
	cp $dizin/boot/kernel* $isodizin/boot/kernel
	mv $dizin/boot/initramfs* $isodizin/boot/initrd
} 

squashfs_olustur () {
    anayer=$(du -sm "$dizin"|awk '{print $1}')
    fazladan="$((anayer/6))"
    mkdir -p tmp
    mkdir -p tmp/LiveOS
    #fallocate -l 32G tmp/LiveOS/rootfs.img
    if [ -f $bos_imaj ];
	then
	   cp $bos_imaj tmp/LiveOS/ext3fs.img
	else
	   dd if=/dev/zero of=tmp/LiveOS/ext3fs.img bs=1MB count="$((anayer+fazladan))"
	fi
    mkfs.ext4 -F tmp/LiveOS/ext3fs.img
    mkfs.ext4 -L $iso_etiket tmp/LiveOS/ext3fs.img
    mkdir -p temp-root
    mount -o loop tmp/LiveOS/ext3fs.img temp-root
    cp -dpR $dizin/* temp-root/
    #rsync -a kur/ temp-root
    umount -l temp-root
    rm -rf temp-root 
    rm -rf $dizin
    mkdir -p iso_icerik/LiveOS
    mksquashfs tmp iso_icerik/LiveOS/squashfs.img -comp xz -b 256K -Xbcj x86
    chmod 444 iso_icerik/LiveOS/squashfs.img
    rm -rf tmp
}

iso_olustur () {
	genisoimage -l -V $iso_etiket -R -J -pad -no-emul-boot -boot-load-size 4 -boot-info-table  \
	-b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o $iso_isim.iso $isodizin && isohybrid $iso_isim.iso
}

temizlik () {
	chroot_ayir
	rm -r $dizin
	rm *.iso
	rm *.log
	rm iso_icerik/boot/pisi.sqfs
	rm iso_icerik/boot/kernel*
	rm iso_icerik/boot/initrd*
	rm iso_icerik/LiveOS/*.img
	rm -rf temp-root tmp
	rm -rf iso_icerik/repo
}	

#ana hareket noktası
mesaj "[0/15] temizlik yapılıyor..."
temizlik
mesaj "[1/15] root dizin yapısı oluşturuluyor..."
rootfs_olustur
mesaj "[2/15] gerekli servisler başlatılıyor..."
servis_baslat
mesaj "[3/15] kernel kuruluyor..."
kernel_kur
mesaj "[4/15] initram kuruluyor..."
initrd_kur
mesaj "[5/15] paketler kuruluyor..."
paket_kur
mesaj "[6/15] chroot ayrılıyor..."
chroot_ayir
mesaj "[7/15] ayarlar işletiliyor..."
ayarlar
mesaj "[8/15] aygit(/dev) dizini ayarlanıyor..."
aygit_ayar
mesaj "[9/15] indirilen paket deposu yedekleniyor..."
depo_yedekle 
mesaj "[10/15] otomatik masa ayarı yapılıyor..."
masa_ayarla
mesaj "[11/15] gereksiz dosyalar siliniyor..."
dosya_temizlik
mesaj "[12/15] initrd oluşturuluyor..."
initrd_olustur
mesaj "[13/15] iso ayarları yapılıyor..."
iso_ayarla
mesaj "[14/15] squashfs dosya imajı oluşturuluyor..."
squashfs_olustur
mesaj "[15/15] iso imajı oluşturuluyor..."
iso_olustur

# eski kodlar
#mkinitramfs eski
#touch $dizin/etc/initramfs.conf
#echo "liveroot=LABEL=PisiLive" > $dizin/etc/initramfs.conf

#mkinitramfs eski
#chroot $dizin /bin/bash -c "mkinitramfs"
#dracut entegre2

#dracuta gom
#chroot $dizin /bin/bash -c "mkdir -p /run/lock/files.ldb && touch /run/lock/files.ldb/LOCK"

#eski vers.
#mksquashfs $dizin $isodizin/boot/pisi.sqfs


