# Automated Landing Zone

I have a separate repo with more *detailed* instructions on how to deploy ALZ.  This is the quick-and-dirty version.

### Set Environment VARS
```
LANDINGZONENAME="LZ0606"
LANDINGZONENAMELC=`echo $LANDINGZONENAME | tr '[:upper:]' '[:lower:]'`
VERSION="v2.1.0"
REGION="us-east-1"
CAPABILITIES="CAPABILITY_NAMED_IAM"
INPUT="params-${LANDINGZONENAME}-${VERSION}-${REGION}.cfn"
OUTPUT="params-${LANDINGZONENAME}-${VERSION}-${REGION}.json"
```

### Create Parameters file
I utilize a "defaults" Parameters file which I store as "params-LZ0000-v2.1.0-us-east-1.cfn" which utilizes "(username)+lz0000-(purpose)@company.com" as the service account email addresses.  Which allows me to create a customized *.json file from the *.cfn input.  (NOTE: You can gather the Parameters by deploying the ALZ solution via CloudFormation and selecting the "Parameters" tab from the base CFN stack deployment.  Alternatively, you can inititiate the template deployment from the CloudFormation Console and the last step before you actually deploy has a Parameters section you can cut-and-paste from)

```
cd Params/
cat params-LZ0000-${VERSION}-us-east-1.cfn | sed "s/lz0000/${LANDINGZONENAMELC}/g" > $INPUT
grep -v ^# $INPUT | while read ParameterKey ParameterValue; do echo -e "  {\n    \"ParameterKey\": \"${ParameterKey}\",\n    \"ParameterValue\": \"${ParameterValue}\"\n  },"; done > ${OUTPUT}
#- once you have the params.json created, add open/close square-brackets at the beginning and end
case `sed --version | head -1` in
  *GNU*)
    # Add the '[' to the beginning of the file
    sed -i -e '1i[' ${OUTPUT}
    # Remove the trailing ',' from the last entry
    sed  -i '$ s/},/}/' ${OUTPUT}
  ;;
  *)
sed -i'' '1i\
[\
' ${OUTPUT}
  ;;
esac
# Add the trailing square-bracket
echo "]" >> ${OUTPUT}
```

## Initiate the CloudFormation Deployment
```
aws cloudformation create-stack --stack-name "${LANDINGZONENAME}" \
  --template-url https://s3.amazonaws.com/solutions-reference/aws-landing-zone/latest/aws-landing-zone-initiation.template \
  --parameters file:"//`pwd`/${OUTPUT}" \
  --region ${REGION} --capabilities ${CAPABILITIES} ${OPTIONS}

### WITHOUT VARS Substitution
aws cloudformation create-stack --stack-name "LZ0606"   --template-url https://s3.amazonaws.com/solutions-reference/aws-landing-zone/latest/aws-landing-zone-initiation.template   --parameters file:"//`pwd`/params-LZ0606-us-east-1.json"   --region us-east-1 --capabilities CAPABILITY_NAMED_IAM 
```

### NOTES:
The time for the ALZ solution to deploy will vary.  Today, for example, my AVM CodePipeline executed as follows:  
Start time: Jun 6, 2019 3:49 PM  
End time: Jun 6, 2019 4:21 PM  


## Add the Networking (core) account
I created a separate doc to [Update ALZ to Add Networking account](update_alz_add_networking.md)

## Enable Service Catalog - Account Vending Machine
The Account Vending Machine (AVM) is the paydirt of the ALZ solution.  It provides a mechanism to "vend" accounts under an AWS Organizations OU (applications) which is baselined and has a limited number of "pre-canned" network configurations.  It should provide the basis for *most* folks to get their work done.

### Add role to Portfolio.
Side NOTE:  I thought most customers will likely create another (core) account to vend accounts with so they don't have to use a master account.  I don't know if a "non-master" account can vend though.  So, perhaps they would have to create an IAM user specific for managing the Account Vending.  Hmm...
