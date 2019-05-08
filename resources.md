# resources.md
Supporting Links and Docs for what I am deploying.

## Networking foo

### Transit Gateway
https://docs.aws.amazon.com/vpc/latest/tgw/tgw-getting-started.html

### VPN foo
This links are currated specific to my own environment and purpose.  (i.e. home lab + Sophos XG to several different AWS setup (i.e. single VPC, multi-VPC using Transit Gateway)

AWS Site-to-Site VPN  
https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html

Your Customer Gateway  
https://docs.aws.amazon.com/vpc/latest/adminguide/Introduction.html
 
Configuring Windows Server 2012 R2 as a Customer Gateway  
https://docs.aws.amazon.com/vpc/latest/adminguide/customer-gateway-windows-2012.html

### Sophos XG Firewall with AWS VPN
https://community.sophos.com/kb/en-us/133057

## Hybrid Cloud DNS

### Centralized DNS management of hybrid cloud with Amazon Route 53 and AWS Transit Gateway
https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-dns-management-of-hybrid-cloud-with-amazon-route-53-and-aws-transit-gateway/

### How to centralize DNS management in a multi-account environment
Older doc - route 53 resolver is probably a better approach.
https://aws.amazon.com/blogs/security/how-to-centralize-dns-management-in-a-multi-account-environment/
