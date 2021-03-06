
prompt 1
timeout 200

ui gfxboot.c32 /boot/isolinux/init

label pisilinux
    kernel /boot/kernel
    append initrd=/boot/initrd root=live:CDLABEL=PisiLive  init=/sbin/init ro rd.luks=0 rd.md=0 rd.dm=0 loglevel=4 vconsole.unicode=1 rd.debug


label rescue
    kernel /boot/kernel
    append initrd=/boot/initrd yali=rescue 


label harddisk
    localboot 0x80

label memtest
    kernel /boot/memtest

label hardware
    kernel hdt.c32
