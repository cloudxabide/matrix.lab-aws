# Share the Transit Gateway (TGW)

from the "master" account, retrieve all the existing accounts you own
```
aws organizations list-accounts --query 'Accounts[*].[Id, Email]' --output text
```
