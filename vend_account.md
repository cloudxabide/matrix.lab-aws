# Vend Account from AVM (Account Vending Machine)

## Vend Account
Go to Service Catalog | Products List (top-left pane)  
Click on the vert ellipses for "AWS-Landing-Zone-Account-Vending-Machine" and "Launch Product"  
Vend the account.  (For demo purposes, Select an AZ configuration with public AZs)  
In your CloudFormation console, you will see the new account being vended.  Under "Outputs" gather the Account Number.  

### Spin up EC2 instance in a public subnet
Once your EC2 instance is up and running, connect to it and then attempt to connect to resources in another account (VPC) - it should/will fail.

## Share Transit Gateway
Switch to your Networking Account  
Browse to the "Resource Access Manager" console.  
 - NOTE: At this point, you should already have a share for the Transit Gateway (if you do not, follow the process in [README.md](./README.md))  
Click on the TGW Share and then "Modify" (upper right-hand corner)  
Under "Principals", add the AWS Account Number for your newly vended account and click "Save Changes".

```
[root@ip-10-108-1-253 ~]# nslookup co7-ipa-srv01.matrix.lab
Server:        10.108.0.2
Address:    10.108.0.2#53
[root@ip-10-108-1-253 ~]# ping -c 2 10.64.200.198
PING 10.64.200.198 (10.64.200.198) 56(84) bytes of data.

--- 10.64.200.198 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 6ms
```

## Accept Transit Gateway Share

Login to the AWS console for your "App account"
Browse to "Resource Access Manaager"
 - NOTE:  this is a bit clunky at-first - since this account has not accessed "RAM" before, it brings up the splash-screen (AKA "Getting Started" page).
Click the 3 hamburgers on towards the left border 
  Shared with me | Resource shares (1 invitation)
Click on the TGW share name, then click "Accept resource share"

### Create TGW Attachment
Browse to VPC and look for "Transit Gateway Attachments" at the bottom left-hand pane.
Click on "Create Transit Gateway Attachment"
Select the TGW under "Transit Gateway ID*" (type will be preselected)
Provide an Attachment name tag ("ATT-TGW-App03")
Select the available VPC and subnets  

### Create Route Table
You will need to wait for the TGW Attachment to complete before proceeding
Find "Transit Gateway Route Tables" in the left-hand pane, lower section
CLick "Create Transit Gateway Route Table"






