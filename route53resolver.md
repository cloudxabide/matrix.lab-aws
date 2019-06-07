# Route 53 Resolver

## Overview
Route 53 Resolver was created to do the "heavy lifting" of the hybrid DNS connectivity.

## Implementation
I have opted to do this in my "Networking" account.
Browse to VPC | Security Groups
Create Security Group (NAME:  SG-ingress-DNS)

Browse Services | Route 53

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
