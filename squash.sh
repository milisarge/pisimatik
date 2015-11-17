squash_olustur() {
    mkdir -p tmp
    mkdir -p tmp/LiveOS
    fallocate -l 6G tmp/LiveOS/rootfs.img
    mkdir -p temp-root
    mkfs.ext3 -F -m1 tmp/LiveOS/rootfs.img
    mount -o loop tmp/LiveOS/rootfs.img temp-root
    cp -a kur/* temp-root/
    umount temp-root/
    mkdir -p iso_icerik/LiveOS
    mksquashfs tmp iso_icerik/LiveOS/squashfs.img -comp xz
    chmod 444 iso_icerik/LiveOS/squashfs.img
    rm -rf temp-root tmp
}

squash_olustur
