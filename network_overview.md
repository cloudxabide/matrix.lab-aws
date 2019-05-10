# Network Overview


## Subnet Layout
Name               | Environment 1 | Environment 2 |
:--|:--:|:--:|
VPC                | VPC-AppA     | VPC-AppB
VPCCidr            | 10.0.0.0/16  | 10.1.0.0/16
PublicSubnet0CIDR  | 10.0.0.0/24  Subnet-AppA-pub-10.0.0.0 | Subnet-AppB-pub-10.1.0.0 | 10.1.0.0/24 
PublicSubnet1CIDR  | 10.0.1.0/24  | 10.1.1.0/24 
PrivateSubnet0CIDR | 10.0.2.0/24  | 10.1.2.0/24 
PrivateSubnet1CIDR | 10.0.3.0/24  | 10.1.3.0/24 

## Internet Gateway
IGW-AppA
IGW-AppB

## Route Table
Name               | Environment 1 | Environment 2 |
:--|:--:|:--:|
VPC                | VPC-AppA      | VPC-AppB


# Transit Gateway Route Tables


