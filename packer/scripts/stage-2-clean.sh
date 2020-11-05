#!/bin/bash

yum install -y make automake gcc bz2

# Mount the disk image
mkdir /tmp/isomount
mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /tmp/isomount

# Install the drivers
cd /tmp/isomount/
bash VBoxLinuxAdditions.run --nox11
usermod -aG vboxsf vagrant

# Cleanup
cd
umount /tmp/isomount
rm -rf /tmp/isomount /root/VBoxGuestAdditions.iso

# clean all
yum update -y
yum clean all


# Install vagrant default key
mkdir -pm 700 /home/vagrant/.ssh
curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh


# Remove temporary files
rm -rf /tmp/*
rm  -f /var/log/wtmp /var/log/btmp
rm -rf /var/cache/* /usr/share/doc/*
rm -rf /var/cache/yum
rm -rf /vagrant/home/*.iso
rm  -f ~/.bash_history
history -c

rm -rf /run/log/journal/*

# Fill zeros all empty space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync
grub2-set-default 0
echo "###   Hi from secone stage" >> /boot/grub2/grub.cfg
