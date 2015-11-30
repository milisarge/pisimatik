#!/bin/sh -x
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

echo "pisilinux" > ${NEWROOT}/etc/hostname

USERNAME=$(getarg live.user)
USERSHELL=$(getarg live.shell)

[ -z "$USERNAME" ] && USERNAME=pisix
[ -x $NEWROOT/bin/bash -a -z "$USERSHELL" ] && USERSHELL=/bin/bash
[ -z "$USERSHELL" ] && USERSHELL=/bin/sh

# Create /etc/default/live.conf to store USER.
echo "USERNAME=$USERNAME" >> ${NEWROOT}/etc/default/live.conf
chmod 644 ${NEWROOT}/etc/default/live.conf

if ! grep -q ${USERSHELL} ${NEWROOT}/etc/shells ; then
    echo ${USERSHELL} >> ${NEWROOT}/etc/shells
fi

# Create new user and remove password. We'll use autologin by default.
chroot ${NEWROOT} useradd -m -c $USERNAME -G audio,video,wheel -s $USERSHELL $USERNAME
chroot ${NEWROOT} passwd -d $USERNAME >/dev/null 2>&1

# Setup default root/user password (pisilinux).
chroot ${NEWROOT} sh -c 'echo "root:toor" | chpasswd -c SHA512'
chroot ${NEWROOT} sh -c "echo "$USERNAME:pisix" | chpasswd -c SHA512"

# Enable sudo permission by default.
if [ -f ${NEWROOT}/etc/sudoers ]; then
    echo "${USERNAME}  ALL=(ALL) NOPASSWD: ALL" >> ${NEWROOT}/etc/sudoers
fi

cp /run/initramfs/live/boot/kernel $NEWROOT/boot/kernel
pisi cp
service dbus start
rm /etc/sddm.conf
cp /etc/sddm.confr /etc/sddm.conf



