# inventory.md

## Physical Hosts

Host     | IP           | Hardware                                             | Purpose        | Services
:--------|:------------:|:-----------------------------------------------------|:---------------|:-----------------
gateway  | 10.10.10.1   | Sophos XG85                                          | Firewall       | NAT, VPN
switch   | 10.10.10.2   | Cisco SG300-28                                       | Layer 2 Switch | Switching yo
wifi     | 10.10.10.9   | Apple Airport                                        | Wireless LAN   | Comms with Aliens
zion     | 10.10.10.10  | NUC5i5RYB, Core(TM) i5-5250U CPU, 15G                | KVM Host       | Virtualization
neo      | 10.10.10.11  | HP ProLiant ML30 Gen9, Xeon(R) CPU E3-1220 v5 , 31G  | Hypervisor     | Virtualization
trinity  | 10.10.10.12  | HP ProLiant ML30 Gen9, Xeon(R) CPU E3-1220 v5 , 31G  | Hypervisor     | Virtualization
morpheus | 10.10.10.13  | HP ProLiant ML30 Gen9, Xeon(R) CPU E3-1220 v6 , 15G  | Hypervisor     | Virtualization
seraph   | 10.10.10.17  | NUC7i7BNB, Core(TM) i7-7567U CPU , 7.5G              | TBD            | TBD
apoc     | 10.10.10.18  | ASUS X99-PRO/USB 3.1, Xeon(R) CPU E5-2630 v3 , 64G   | KVM Host       | Virtualization

Command to retrieve Manufacturer, Model, Proc, and Memory:
```
echo "`dmidecode -s system-manufacturer` `dmidecode -s baseboard-product-name`,`lscpu | grep "^Model name:" | grep -o -P '(?<=Intel\(R\)).*(?=\@)'`, `free -h | grep "Mem:" | awk '{ print $2 }'`"
```

## Virtual Machines (long-lived)

Host     | IP           | Hardware                                             | Purpose        | Services  
:-------|:------------:|:-----------------------------------------------------|:---------------|:---------  
co7-nms-srv01   | 10.10.10.110 | Virtual Machine | LibreNMS Monitoring | Monitoring  
win2k16-ad-srv1 | 10.10.10.120 | Virtual Machine | Windows server | DNS, ADFS 
co7-ipa-srv01   | 10.10.10.121 | Virtual Machine | IdM server | DNS, LDAPS
co7-ipa-srv02   | 10.10.10.122 | Virtual Machine | IdM server | DNS, LDAPS
