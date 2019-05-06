# matrix.lab
My Home Lab used for testing Hybrid Cloud

## Overview
In my home lab, there will be a few key components:
 * Sophos XG firewall (VPN endpoint)
 * a few KVM hosts
 * oVirt cluster

## Inventory

Host | IP | Purpose | Services
|:--|:--:|:----|:-----
gateway | 10.10.10.1 | Sophos XG | Firewall | NAT
switch | 10.10.10.2 | Cisco SG300-28 | Layer 2 Switch | Switching yo
zion | 10.10.10.10 | | KVM Host | Virtualization
apoc | 10.10.10.18 | | KVM Host | Virtualization
| -- | -- | -- | -- |
co7-ipa-srv01 | 10.10.10.121 | Virtual Machine | IdM server | DNS, LDAPS
co7-ipa-srv02 | 10.10.10.122 | Virtual Machine | IdM server | DNS, LDAPS



## Topics
### AWS VPN site-to-site with single VPC 

### AWS VPN site-to-site with multiple VPC using Transit Gateway

