squash_olustur() {
    mkdir -p tmp
    mkdir -p tmp/LiveOS
    fallocate -l 4G tmp/LiveOS/ext3fs.img
    mkdir -p temp-root
    mkfs.ext3 -F -m1 tmp/LiveOS/ext3fs.img
    mount -o loop tmp/LiveOS/ext3fs.img temp-root
    cp -a kur/* temp-root/
    umount -f temp-root/
    mksquashfs tmp iso_icerik/LiveOS/squashfs.img -comp xz
    chmod 444 iso_icerik/LiveOS/squashfs.img
    rm -rf temp-root tmp
}

squash_olustur
