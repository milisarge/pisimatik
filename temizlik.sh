dizin=kur
umount $dizin/proc
umount $dizin/sys
rm -r $dizin
rm *.iso
rm iso_icerik/boot/pisi.sqfs
rm iso_icerik/boot/kernel*
rm iso_icerik/boot/initrd*
