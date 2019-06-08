# Resource Access Manager - Transit Gateway

## Overview
To allow multiple accounts to utilize a single resource owned by another account, you must share the resource via the... Aws Resource Access Manager.

## Prerequisites
Before you start this task, you will need a list of Account IDs which you wish to share to.
With the "master/payer" account credentials submitted, run the following:
```
aws organizations list-accounts --query 'Accounts[*].[Id, Email]' --output text
```
Initially I will be sharing the Transit Gateway to the "master" and "shared-services" account.


## Share the TGW Resource
Click Services and start typing "Resource" and select Resource Access Manager when it appears.

Click "Create a resource share"
Name: LZ0000-TGW-Share
Select resource type: (select Transit Gateways and click in the TGW that appears)
Principals - optional
  Enter the account IDs from the command above

Now .. the fun begins.  You will need to access each account and "accept" the resource share.

## Accept Resource Share and attach to TGW
(TBC)
Explain how to accept the resource share and attach to TGW
