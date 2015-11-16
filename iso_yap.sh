generate_iso_image() {
        xorriso -as mkisofs \
        -iso-level 3 -rock -joliet \
        -max-iso9660-filenames -omit-period \
        -omit-version-number -relaxed-filenames -allow-lowercase \
        -volid "PL" \
        -eltorito-boot /boot/isolinux/isolinux.bin \
        -eltorito-catalog /boot/isolinux/boot.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        -output test.iso iso_icerik
}

generate_iso_image
