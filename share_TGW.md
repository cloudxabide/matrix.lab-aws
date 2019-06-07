# Share the Transit Gateway (TGW)

from the "master" account, retrieve all the existing accounts you own
```
aws organizations list-accounts --query 'Accounts[*].[Id, Email]' --output text
```

Decide which accounts need connectivity via the Transit Gateway (on-prem, inter-VPC/account, etc..)

You will then need to "accept" the invitation to the TransitGatewayResourceShare from those other accounts.
Switch to that other account (I "switch role" in my environment).
In the console, browse to the Resource Access Manager and select "Shared with me" in the left pane.
Click on "TransitGatewayResourceShare" and then click "Accept resource share"
Then Browse to the "VPC" console
Towards the bottom of the left-hand pane is the Transit Gateway Attachments

Then browse to Route Tables and select the "default" (which will have no name)
add the "base CIDR" for that region to the Route Table and point it to the Transit Gateway
