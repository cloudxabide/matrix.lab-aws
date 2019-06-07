# Network Overview


## Subnet Layout
Name               | Ingress       |                          | Egress        |  |
:------------------|:-------------:|:------------------------:|:------------  |:------------------------:|
VPC                | VPC-ingress    |                           | VPC-egress   | |
VPCCidr            | 10.64.200.0/16   |                           | 10.1.0.0/16   | |
Sub-Pub-01         | 10.64.200.0/24   | Subnet-AppA-pub-10.64.0.0 | 10.1.0.0/24   | Subnet-AppB-pub-10.1.0.0 

## Internet Gateway
IGW-AppA
IGW-AppB

## Route Table
Name               | Environment 1 | Environment 2 |
:--|:--:|:--:|
VPC                | VPC-AppA      | VPC-AppB
RTB-AppA-Public

## Security Groups
SG-AppA-pub-SSH
SG-AppB-pub-SSH
SG-AppA-priv-SSH
SG-AppB-priv-SSH

## NAT Gateways (NGW)

# Transit Gateway  

# Transit Gateway Attachments
ATT-VPC-AppA  
ATT-VPC-AppB

# Transit Gateway Route Tables

# route53 resolver

I get the feeling I need to rethink/revisit this one.  There should be "utility" VPCs dedicated to this... which allow other VPCs to communicate.
r53-inbound-endpoint-AppA
r53-outbound-endpoint-AppA

