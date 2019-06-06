## Prerequisites
Review the example "parameters" files to get an idea of what you will need to provide during the deployment.

Version | Example Parameters
:---:|:----
2.1.0 | [ALZ Params v2.1.0](Params/params-LZ0000-v2.1.0-us-east-1.cfn)
2.0.3 | [ALZ Params v2.0.3](Params/params-LZ0000-v2.0.3-us-east-1.cfn)

### Account email addresses
You need to provide a number of #unique# email address(es) based on the function they provide.  (hopefully the examples make it obvious what they are for).

```
email accounts I use:
<myusername>+<landing-zone-name>-master@company.com
<myusername>+<landing-zone-name>-shared-services@company.com
<myusername+<landing-zone-name>-log-archive@company.com
<myusername>+<landing-zone-name>-security@company.com

<myusername>+<landing-zone-name>-security-alert@company.com
<myusername>+<landing-zone-name>-all-change-events@company.com
<myusername>+<landing-zone-name>-pipeline-approval@company.com
```

### Networking
Shared Services VPCcidr - the ALZ will create a VPC for the Shared Services account to allow services to run which require a VPC.  
Number of AZs for Shared-Services 

### Example Parameters file (params-LZ000-v2.1.0-us-east-1.cfn)

```
AllChangeEventsEmail    myusername+lz0000-all-change-events@company.com
BuildLandingZone    Yes
CoreOUName    core
EnableAllRegions    Current region only
EnableEncryptedVolumesRule    Yes
EnableIamPasswordPolicyRule    Yes
EnableRdsEncryptionRule    Yes
EnableRestrictedCommonPortsRule    Yes
EnableRestrictedSshRule    Yes
EnableRootMfaRule    Yes
EnableS3PublicReadRule    Yes
EnableS3PublicWriteRule    Yes
EnableS3ServerSideEncryptionRule    Yes
LockStackSetsExecutionRole    No
LoggingAccountEmail    myusername+lz0000-log-archive@company.com
LogsRetentionInDays    90
NestedOUDelimiter    Colon (:)
NonCoreOUNames    applications
PipelineApprovalEmail    myusername+lz0000-pipeline-approval@company.com
PipelineApprovalStage    Yes
SecurityAccountEmail    myusername+lz0000-security@company.com
SecurityAlertEmail    myusername+lz0000-security-alert@company.com
SharedServicesAccountEmail    myusername+lz0000-shared-services@company.com
SubscribeAllChangeEventsEmailToTopic    No
VPCCidr    10.64.0.0/22
VPCOptions    Shared-Services-Network-3-AZs
```
