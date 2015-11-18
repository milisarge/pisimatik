dizin=kur
umount $dizin/proc
umount $dizin/sys
rm -r $dizin
rm *.iso
rm *.log
rm iso_icerik/boot/pisi.sqfs
rm iso_icerik/boot/kernel*
rm iso_icerik/boot/initrd*
rm iso_icerik/LiveOS/*.img
rm -rf temp-root tmp
rm -rf iso_icerik/repo
