# Route 53 Resolver

## Overview
Route 53 Resolver was created to do the "heavy lifting" of the hybrid DNS connectivity.

## Implementation
I have opted to do this in my "Networking" account.
Browse to VPC | Security Groups
Create Security Group (NAME:  SG-ingress-DNS)

Browse Services | Route 53 Resolver | Inbound Endpoints
Create Inbound Endpoint
  - Endpoint name: EP-ingress-dns-inbound
  - VPC in the Region: (select the ingress VPC)
  - Security group for this endpoint: SG-ingress-DNS (from above)
Complete the 2 sections for IP address #1 and #2
(You will need to retrieve the IPs to enter in to IPA)

Create Outbound Endpoint
(repeat the process for Inbound)
  - Endpoint name:  EP-ingress-outbound

Create Rules
  - Name: R53-rule-matrix_lab
  - Rule Type: Forward
  - Domain name: matrix.lab
  - VPCs that use this rule: (select them all?)
  - Outbound endpoint: (select the resolver rule that we just created EP-ingress-dns-outbound)
  - Target IP address:  10.10.10.121 10.10.10.122 

Now.. this is VERY important - you will (likely) need to allow queries from your AWS subnets
```
kinit admin
ipa dnszone-mod --allow-transfer='192.168.0.0/24;10.10.10.0/24;127.0.0.1/32;10.0.0.0/8' matrix.lab.
```

## Testing
```
yum whatprovides */nslookup | egrep -v 'Repo|Filename|Matched' | sort
yum -y install bind-utils
```


## References
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver.html
```
How Route 53 Resolver Forwards DNS Queries from Your VPCs to Your Network
When you want to forward DNS queries from the EC2 instances in one or more VPCs in an AWS Region to your network, you perform the following steps.

You create a Route 53 Resolver outbound endpoint in a VPC, and you specify several values:

The VPC that you want DNS queries to pass through on the way to the resolvers on your network.

The IP addresses in your VPC that you want Resolver to forward DNS queries from. To hosts on your network, these are the IP addresses that the DNS queries originate from.

A VPC security group

For each IP address that you specify for the outbound endpoint, Resolver creates an Amazon VPC elastic network interface in the VPC that you specify. For more information, see Considerations When Creating Inbound and Outbound Endpoints.

You create one or more rules, which specify the domain names of the DNS queries that you want Resolver to forward to resolvers on your network. You also specify the IP addresses of the resolvers. For more information, see Using Rules to Control Which Queries Are Forwarded to Your Network.

You associate each rule with the VPCs for which you want to forward DNS queries to your network.
```
