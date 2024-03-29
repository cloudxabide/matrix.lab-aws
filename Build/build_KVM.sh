#!/bin/sh
#
# Purpose:      This is a script create to process a single hostname as input 
#                 and fetch the configuration parameters from a configuration file
#               I created it to primarily save myself some time creating VMs in my lab.
#  Author:      James Radtke <jradtke@redhat.com>
#   NOTES:      This is NOT a Red Hat supported work, nor AWS

# VARS
GUESTNAME=${1}
CONFIG=./.myconfig
WEBSERVER=`ip a | grep inet | egrep -v 'inet6|host lo|br0' | awk '{ print $2 }' | cut -f1 -d\/ | head -1`
WEBSERVER="10.10.10.10"
BRIDGE=brkvm
BOOTOPTIONS=""

usage() {
  echo "ERROR: Pass a guestname" 
  echo "       $0 <hostname>"
  exit 9; 
}

if [ $# -ne 1 ]; then usage; fi 
if [ `whoami` != "root" ]; then echo "ERROR: you should be root"; exit 9; fi

# See if the VM is already running
virsh list | grep -w ${1} 
case $? in 
  0)
    echo "NOTE: VM ${1} already exists."; 
    exit 9
  ;;
  *)
    echo "NOTE: creating ${1}"
  ;;
esac

if [ ! -f $CONFIG ]
then
  echo "ERROR: No Config File found"
  exit 9
fi

grep -w ${GUESTNAME} $CONFIG 
case $? in 
  0)
    echo "SUCCESS:  $GUESTNAME found in $CONFIG"
  ;;
  *)
    echo "ERROR: $GUESTNAME not found in $CONFIG"; 
    exit 9
  ;;
esac

grep -w ${GUESTNAME} $CONFIG | awk -F':' '{ print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$14 }' \
  | while read GUESTNAME RELEASE NUMCPUS MEM HDDA HDDB HDDC RELEASETYPE RELEASEVER BIOSTYPE USE_SATELLITE DISCONNECTED PURPOSE INSTALL
do
  # DISPLAY SOME HELPFUL INFO
  echo $GUESTNAME $RELEASE $NUMCPUS $MEM $HDDA $HDDB $RELEASETYPE $RELEASEVER $BIOSTYPE $USE_SATELLITE $PURPOSE
  echo "GUESTNAME: $GUESTNAME"
  echo "RELEASE: $RELEASE"
  echo "NUMCPUS: $NUMCPUS"
  echo "MEM: $MEM"
  echo "HDDA: $HDDA"
  echo "HDDB: $HDDB"
  echo "HDDC: $HDDC"
  echo "RELEASETYPE: $RELEASETYPE"
  echo "RELEASEVER: $RELEASEVER"
  echo "BIOS TYPE: $BIOSTYPE"
  echo "USE SATELLITE: $USE_SATELLITE"
  echo "DISCONNECTED: $DISCONNECTED"
  echo "SYSTEM PURPOSE: $PURPOSE"
  echo "BASE INSTALL:  $INSTALL"

  # Hopefully I can clean this up....
  case $BIOSTYPE in
    UEFI)
      ADDOPTION=" --boot uefi"
      BOOTOPTIONS="${BOOTOPTIONS} ${ADDOPTION}"
    ;;
  esac

  case $RELEASE in
    EL6) OSDIR="RHEL-6.6-x86_64"; OSVARIANT="rhel6" ;;
    EL7) OSDIR="rhel-${RELEASETYPE}-${RELEASEVER}-x86_64"; OSVARIANT="rhel7";;
    RHS3) OSDIR="RHS-3";;
    *)  echo "ERROR: Unsupported Release in $CONFIG"; exit 9;;
  esac
  echo "Install Source: --location=\"http://${WEBSERVER}/OS/${OSDIR}\" "
  echo "NOTE: pause for 5 seconds to review parameters above"
  sleep 5

# CREATE THE BASEDIR AND DISK IMAGE FILES
if [ ! -d /var/lib/libvirt/images/${GUESTNAME} ]
then
  echo "mkdir /var/lib/libvirt/images/${GUESTNAME}"
  mkdir /var/lib/libvirt/images/${GUESTNAME}
fi
if [ ! -f /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-0.img  ]
then
  echo "qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-0.img ${HDDA}G "
  qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-0.img ${HDDA}G 
fi 
if [ $HDDB != 0 ]
then
  NUMDISK=2
  if [ ! -f /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-1.img  ]
  then
    echo "qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-1.img ${HDDB}G "
    qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-1.img ${HDDB}G 
  fi 
fi
if [ $HDDC != 0 ]
then
  NUMDISK=3
  if [ ! -f /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-2.img  ]
  then
    echo "qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-2.img ${HDDC}G "
    qemu-img create -f qcow2 -o preallocation=metadata /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-2.img ${HDDC}
  fi
fi
find /var/lib/libvirt/images/${GUESTNAME} -type d -exec chmod 770 {} \;
find /var/lib/libvirt/images/${GUESTNAME} -type f -exec chmod 660 {} \;
chown -R qemu:qemu /var/lib/libvirt/images/${GUESTNAME}
restorecon -RFvv /var/lib/libvirt/images/${GUESTNAME}

# Need to create a way to deal with more than one "build-time" disk
case $NUMDISK in
  3)
virt-install --noautoconsole --name ${GUESTNAME} --hvm --connect qemu:///system \
  --description "${GUESTNAME}" --virt-type=kvm \
  --network=bridge:${BRIDGE} --vcpus=${NUMCPUS} --ram=${MEM} \
  --disk /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-0.img,device=disk,bus=virtio,format=qcow2 \
  --disk /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-1.img,device=disk,bus=virtio,format=qcow2 \
  --disk /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-2.img,device=disk,bus=virtio,format=qcow2 \
  --os-type=linux --os-variant=${OSVARIANT} ${BOOTOPTIONS} \
  --location="http://${WEBSERVER}/OS/${OSDIR}" \
  -x "ks=http://${WEBSERVER}/${GUESTNAME}.ks"
  echo "Completed: `date`"
  ;;
  2)
    echo "Started: `date`"
virt-install --noautoconsole --name ${GUESTNAME} --hvm --connect qemu:///system \
  --description "${GUESTNAME}" --virt-type=kvm \
  --network=bridge:${BRIDGE} --vcpus=${NUMCPUS} --ram=${MEM} \
  --disk /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-0.img,device=disk,bus=virtio,format=qcow2 \
  --disk /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-1.img,device=disk,bus=virtio,format=qcow2 \
  --os-type=linux --os-variant=${OSVARIANT} ${BOOTOPTIONS} \
  --location="http://${WEBSERVER}/OS/${OSDIR}" \
  -x "ks=http://${WEBSERVER}/${GUESTNAME}.ks"
  echo "Completed: `date`"
  ;;
  *)
    echo "Started: `date`"
virt-install --noautoconsole --name ${GUESTNAME} --hvm --connect qemu:///system \
  --description "${GUESTNAME}" --virt-type=kvm \
  --network=bridge:${BRIDGE} --vcpus=${NUMCPUS} --ram=${MEM} \
  --disk /var/lib/libvirt/images/${GUESTNAME}/${GUESTNAME}-0.img,device=disk,bus=virtio,format=qcow2 \
  --os-type=linux --os-variant=${OSVARIANT} ${BOOTOPTIONS} \
  --location="http://${WEBSERVER}/OS/${OSDIR}" \
  -x "ks=http://${WEBSERVER}/${GUESTNAME}.ks"
  echo "Completed: `date`"
  ;;
esac
done

exit 0
# Snippet about newer style of boot params
echo "inst.gpt ip=192.168.122.121:192.168.122.1:255.255.255.0:rh7-idm-srv01.matrix.lab:eth0:static ks=http://${WEBSERVER}/${GUESTNAME}.ks"
