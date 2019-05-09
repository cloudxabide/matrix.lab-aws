# Network Overview


## Subnet Layout
Name               | Environment 1 | Environment 2 |
:--|:--:|:--:|
VPC                | VPC-A         | VPC-B
VPCCidr            | 10.0.0.0/16   | 10.1.0.0./16
PublicSubnet0CIDR  | 10.0.0.0/24   | 10.1.0.0/24 
PublicSubnet1CIDR  | 10.0.1.0/24   | 10.1.1.0/24 
PrivateSubnet0CIDR | 10.0.0.0/24   | 10.1.0.0/24 
PrivateSubnet1CIDR | 10.0.1.0/24   | 10.1.1.0/24 

## Route Table
Name               | Environment 1 | Environment 2 |
:--|:--:|:--:|
Public             | VPC-A         | VPC-B

# Transit Gateway Route Tables


