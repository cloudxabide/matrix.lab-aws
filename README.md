# matrix.lab
My Home Lab used for testing Hybrid Cloud

## Overview
In my home lab, there will be a few key components:
 * Sophos XG firewall (VPN endpoint)
 * a few KVM hosts
 * oVirt cluster

## Inventory

Host | IP | Hardware | Purpose | Services
|:--|:--:|:----|:-----|:----|:----
gateway  | 10.10.10.1   | Sophos XG | Firewall | NAT
switch   | 10.10.10.2   | Cisco SG300-28 | Layer 2 Switch | Switching yo
wifi     | 10.10.10.9   | Apple Airport | Wireless LAN | Comms with Aliens
zion     | 10.10.10.10  | NUC5i5RYB, Core(TM) i5-5250U CPU, 15G | KVM Host | Virtualization
neo      | 10.10.10.11  | HP ProLiant ML30 Gen9, Xeon(R) CPU E3-1220 v5 , 31G | Hypervisor | Virtualization
trinity  | 10.10.10.12  | HHP ProLiant ML30 Gen9, Xeon(R) CPU E3-1220 v5 , 31G | Hypervisor | Virtualization
morpheus | 10.10.10.13  | HP ProLiant ML30 Gen9, Xeon(R) CPU E3-1220 v6 , 15G | Hypervisor | Virtualization
apoc     | 10.10.10.18  | ASUS X99-PRO/USB 3.1, Xeon(R) CPU E5-2630 v3 , 64G | KVM Host | Virtualization
| -- | -- | -- | -- | -- |
co7-ipa-srv01 | 10.10.10.121 | Virtual Machine | IdM server | DNS, LDAPS
co7-ipa-srv02 | 10.10.10.122 | Virtual Machine | IdM server | DNS, LDAPS



## Topics
### AWS VPN site-to-site with single VPC 

### AWS VPN site-to-site with multiple VPC using Transit Gateway

