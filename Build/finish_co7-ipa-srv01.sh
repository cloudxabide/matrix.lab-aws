#!/bin/bash

# Purpose:   This script will deploy freeIPA on this node and configure DNS
# Author:    
# Date:      2019-06-21
# Status:    WIP (Work In Progress)

ADMINPASSWD="Passw0rd"
PKGS="freeipa-server ipa-server-dns"

# Update the firewall settings according to installation doc
DEFAULTZONE=$(firewall-cmd --get-default-zone)
firewall-cmd --permanent --zone=${DEFAULTZONE} --add-port={80/tcp,123/tcp,443/tcp,389/tcp,636/tcp,88/tcp,445/tcp,464/tcp,53/tcp,7389/tcp,138/tcp,139/tcp}
firewall-cmd --permanent --zone=${DEFAULTZONE} --add-port={53/udp,88/udp,123/udp,138/udp,139/udp,445/udp,464/udp}
firewall-cmd --permanent --zone=${DEFAULTZONE} --add-service=${ntp,freeipa-ldap,freeipa-ldaps,dns}
firewall-cmd --reload
firewall-cmd --list-ports
firewall-cmd --list-all

# Install freeIPA
$(which yum) -y install ${PKGS}

case `uname -n` in
  co7-ipa-srv01.matrix.lab)

# Provide install options to use
# Use --no-ntp for IPA/IDM (Sec 2.4.6 from Install Guide)
IPA_OPTIONS="
--realm=MATRIX.LAB
--domain=matrix.lab
--ds-password=Passw0rd
--admin-password=Passw0rd
--hostname=co7-idm-srv01.matrix.lab
--ip-address=10.10.10.121
--setup-dns --no-forwarders
--mkhomedir
--unattended"

CERTIFICATE_OPTIONS="
--subject="

echo "NOTE:  If this is a VM, you may see a warning/notice about entropy"
echo "  in another window, run:  rngd -r /dev/urandom -o /dev/random -f"

echo "ipa-server-install -U $IPA_OPTIONS $CERTIFICATE_OPTIONS"
ipa-server-install -U $IPA_OPTIONS $CERTIFICATE_OPTIONS
echo $ADMINPASSWD | kinit admin
klist

# Initial DNS configuration
ipa dnszone-add 10.10.10.in-addr.arpa.  # "public"
ipa dnsrecord-add matrix.lab co7-idm-srv01 --a-rec 10.10.10.121
ipa dnsrecord-add matrix.lab co7-idm-srv02 --a-rec 10.10.10.122
ipa dnsrecord-add 10.10.10.in-addr.arpa 121 --ptr-rec co7-idm-srv01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 122 --ptr-rec co7-idm-srv02.matrix.lab.
ipa dnszone-mod --allow-transfer='192.168.0.0/24;10.0.0.0/8;127.0.0.1' matrix.lab.

# Add some users
echo "Passw0rd" | ipa user-add morpheus --uid=1000 --gidnumber=1000 --first=Morpheus --last=Manager --email=morpheus@matrix.lab --homedir=/home/morpheus --shell=/bin/bash --password
echo "Passw0rd" | ipa user-add mansible --uid=1001 --gidnumber=1001 --first=Mansible --last=McChicken --email=mansible@matrix.lab --homedir=/home/mansible --shell=/bin/bash --password
echo "Passw0rd" | ipa user-add jradtke --uid=2025 --gidnumber=2025 --first=James --last=Radtke --manager=Mansible --email=jradtke@matrix.lab --homedir=/home/jradtke --shell=/bin/bash --password

  ;;
  *)
    echo "Not the *master* node, adding to Domain"
  ;;
esac



case `uname -n` in
  co7-ipa-srv01.matrix.lab)

# Physical Machines
ipa dnsrecord-add matrix.lab sophos-xg          --a-rec 10.10.10.1
ipa dnsrecord-add matrix.lab firewall           --cname-rec='sophos-xg.matrix.lab.'
ipa dnsrecord-add matrix.lab gateway            --cname-rec='sophos-xg.matrix.lab.'
ipa dnsrecord-add matrix.lab cisco-sg300-28     --a-rec 10.10.10.2
ipa dnsrecord-add matrix.lab switch             --cname-rec='cisco-sg300-28.matrix.lab.'
ipa dnsrecord-add matrix.lab wifi               --a-rec 10.10.10.9
ipa dnsrecord-add matrix.lab zion               --a-rec 10.10.10.10
ipa dnsrecord-add matrix.lab neo                --a-rec 10.10.10.11
ipa dnsrecord-add matrix.lab neo-ilom           --a-rec 10.10.10.21
ipa dnsrecord-add matrix.lab trinity            --a-rec 10.10.10.12
ipa dnsrecord-add matrix.lab trinity-ilom       --a-rec 10.10.10.22
ipa dnsrecord-add matrix.lab morpheus           --a-rec 10.10.10.13
ipa dnsrecord-add matrix.lab morpheus-ilom      --a-rec 10.10.10.23
ipa dnsrecord-add matrix.lab seraph             --a-rec 10.10.10.17
ipa dnsrecord-add matrix.lab apoc               --a-rec 10.10.10.18
ipa dnsrecord-add matrix.lab websrv             --a-rec 10.10.10.20
# Virtual Machines
ipa dnsrecord-add matrix.lab rh7-sat6-srv01     --a-rec 10.10.10.102
ipa dnsrecord-add matrix.lab librenms           --cname-rec='rh7-nms-srv01.matrix.lab.'
ipa dnsrecord-add matrix.lab nagios        --a-rec 10.10.11.200
ipa dnsrecord-add matrix.lab jira         --a-rec 10.10.11.201
ipa dnsrecord-add matrix.lab rh7-ocp3-mst    --a-rec 10.10.10.170
ipa dnsrecord-add matrix.lab openshift       --cname-rec='rh7-ocp3-mst.matrix.lab.'
ipa dnsrecord-add matrix.lab ocp             --cname-rec='rh7-ocp3-mst.matrix.lab.'
ipa dnsrecord-add matrix.lab rh7-ocp3-mst01  --a-rec 10.10.10.171
ipa dnsrecord-add matrix.lab rh7-ocp3-mst03  --a-rec 10.10.10.173
ipa dnsrecord-add matrix.lab rh7-ocp3-inf01  --a-rec 10.10.10.175
ipa dnsrecord-add matrix.lab rh7-ocp3-inf02  --a-rec 10.10.10.176
ipa dnsrecord-add matrix.lab rh7-ocp3-inf03  --a-rec 10.10.10.177
ipa dnsrecord-add matrix.lab rh7-ocp3-app01  --a-rec 10.10.10.181
ipa dnsrecord-add matrix.lab rh7-ocp3-app02  --a-rec 10.10.10.182
ipa dnsrecord-add matrix.lab rh7-ocp3-reg01  --a-rec 10.10.10.191
ipa dnsrecord-add matrix.lab rh7-ocp3-reg02  --a-rec 10.10.10.192
ipa dnsrecord-add matrix.lab rh7-ocp3-reg03  --a-rec 10.10.10.193
ipa dnsrecord-add cloudapps.matrix.lab '*' --a-rec 10.10.10.180
# Add Forward Rules for Amazon resources (this list is incomplete - 2019-06-22)
# AWS_r53_ENDPOINTS="10.0.0.81 10.0.1.69 10.1.0.91 10.1.1.162"
ipa dnsforwardzone-add ec2.internal. --forwarder=10.0.0.81 --forwarder=10.1.0.91 --forward-policy=first
ipa dnsforwardzone-mod --forward-policy=only ec2.internal
ipa dnsforwardzone-mod CORP.matrix.lab. --forwarder=10.10.10.121 --forwarder=10.64.0.117 --forward-policy=only 
  ;;
esac

# System tuning
authconfig --enablemkhomedir --update

# Disable DNSSEC (temporary, hopefully?)... to work with AWS route 53
cp /etc/named.conf /etc/named.conf.`date +%F`
sed -i -e 's/dnssec-enable yes/dnssec-enable no/g' /etc/named.conf
sed -i -e 's/dnssec-validation yes/dnssec-validation no/g' /etc/named.conf
ipactl restart

exit 0

################################################
# Troubleshooting / Testing
ipa dnsforwardzone-show  ec2.internal
nslookup ip-10-0-0-81.ec2.internal
nslookup ip-10-0-0-123.ec2.internal

dig SRV _ldap._tcp matrix.lab.
dig SRV _ldap._tcp CORP.matrix.lab.
dig @forwarder corp.matrix.lab. SOA

