#!/bin/bash


id -u jradtke &>/dev/null || useradd -u2025 -G10 -c "James Radtke" -p '$6$MIxbq9WNh2oCmaqT$10PxCiJVStBELFM.AKTV3RqRUmqGryrpIStH5wl6YNpAtaQw.Nc/lkk0FT9RdnKlEJEuB81af6GWoBnPFKqIh.' jradtke

yum -y install cockpit
eystemctl enable cockpit.socket
systemctl enable cockpit.service
systemctl restart cockpit.service
systemctl restart cockpit.socket
firewall-cmd --permanent --add-service=cockpit

sed -i -e '24iallow 10.10.10.0\/24' /etc/chrony.conf
systemctl enable chronyd; systemctl start chronyd;
#chronyd -q 'pool 0.rhel.pool.ntp.org iburst';
chronyc -a 'burst 4/4'; sleep 10; chronyc -a makestep; sleep 2; hwclock --systohc; chronyc sources
firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload

systemctl disable cups iscsid.socket iscsi.service

INTERFACE=eno1
cat << EOF > /root/nmcli_cmds.sh
nmcli con add type bridge autoconnect yes con-name brkvm ifname brkvm ip4 10.10.10.18/24 gw4 10.10.10.1
nmcli con modify brkvm ipv4.address 10.10.10.18/24 ipv4.method manual
nmcli con modify brkvm ipv4.gateway 10.10.10.1
nmcli con modify brkvm ipv4.dns "10.10.10.121"
nmcli con modify brkvm +ipv4.dns "10.10.10.122"
nmcli con modify brkvm +ipv4.dns "8.8.8.8"
nmcli con modify brkvm ipv4.dns-search "matrix.lab corp.matrix.lab"
nmcli con delete $INTERFACE
nmcli con add type bridge-slave autoconnect yes con-name $INTERFACE ifname $INTERFACE master brkvm
systemctl stop NetworkManager; systemctl start NetworkManager
EOF
sh /root/nmcli_cmds.sh &

cp /etc/fstab /etc/fstab-`date +%F`
mkdir /data 
echo "/dev/mapper/vg_data-lv_data /data xfs defaults 0 0" >> /etc/fstab

# Add filesystem as loopback
echo "# BIND Mounts" >> /etc/fstab
echo "/data/images  /var/lib/libvirt/images none bind,defaults 0 0" >> /etc/fstab
mount -a
systemctl start libvirtd; systemctl enable libvirtd

# COPY THE ISOs to /data/images/

PKGS="httpd php syslinux tftp-server tftp dhcp-server nmap net-snmp"
yum -y install $PKGS


mkdir /var/www/OS
cat << EOF > /etc/httpd/conf.d/OS.conf
Alias "/OS" "/var/www/OS"
<Directory "/var/www/OS">
  Options FollowSymLinks Indexes
</Directory>
EOF
systemctl enable httpd
systemctl start httpd


yum -y install tftp tftp-server xinetd
mkdir /data/tftpboot
sed -i -e 's/^[ \t]\+disable[ \t]\+= yes/\tdisable\t\t\t = no/' /etc/xinetd.d/tftp
#sed -i -e 's/\/var\/lib\/tftpboot/\/data\/tftp/g' /etc/xinetd.d/tftp
echo "/data/tftpboot /var/lib/tftpboot none bind,defaults" >> /etc/fstab
mount -a
restorecon -RFvv /var/lib/tftpboot
systemctl restart xinetd
firewall-cmd --permanent --zone=public --add-service=tftp
firewall-cmd --permanent --zone=public --add-port=69/tcp
firewall-cmd --permanent --zone=public --add-port=69/udp
firewall-cmd --reload
for SVC in xinetd tftp
do
  systemctl enable $SVC
  systemctl start $SVC
done

#####################################
#####################################
#             AIDE
#   Install/configure AIDE
#####################################
#####################################
yum -y install aide
aide --init

test_aide() {
  mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
  aide --check

  touch /etc/test
  aide --check
  aide --update
}

update_aide(){
  aide --update
  mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
}

create_cron_for_aide() {
  # Create a weekly cron job that run to review the status and posts the file
  # to my web server
  cat << EOF > /etc/cron.weekly/check-aide
  #!/bin/bash
  MYDATE=\`date +%F\`
  OUTPUT=/tmp/check-aide-\${MYDATE}.html

  echo "<HTML><HEAD><TITLE>AIDE Check | \$MYDATE | &#169 LinuxRevolution</TITLE></HEAD><BODY><PRE>" > \${OUTPUT}
  aide --check >> \${OUTPUT}
  echo "</PRE></BODY></HTML>" >> \${OUTPUT}
  scp -i ~jradtke/.ssh/id_rsa-neo \${OUTPUT} jradtke@websrv:/var/www/html/Aide/
  EOF
  chmod 754 /etc/cron.weekly/check-aide
  /etc/cron.weekly/check-aide
}




`
