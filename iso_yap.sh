iso_olustur () {
	genisoimage -l -V PisiLive -R -J -pad -no-emul-boot -boot-load-size 4 -boot-info-table  \
	-b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o pisi.iso iso_icerik && isohybrid pisi.iso
}
iso_olustur
