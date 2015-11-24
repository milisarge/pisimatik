dizin=kur
squash_olustur() {
    mkdir -p tmp
    mkdir -p tmp/LiveOS
    fallocate -l 32G tmp/LiveOS/rootfs.img
    mkdir -p temp-root
    mkfs.ext4 tmp/LiveOS/rootfs.img
    mount -o loop tmp/LiveOS/rootfs.img temp-root
    rsync -a kur/ temp-root
    umount temp-root
    rm -rf temp-root 
    rm -rf $dizin
    mkdir -p iso_icerik/LiveOS
    mksquashfs tmp iso_icerik/LiveOS/squashfs.img -comp xz
    chmod 444 iso_icerik/LiveOS/squashfs.img
    rm -rf tmp
}

squash_olustur
