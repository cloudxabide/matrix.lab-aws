# Update ALZ - Add Networking (core) account


## How to: Manage (update) a deployed Landing Zone Configuration
Check out the Configuration (ZIP file)
```
export AWS_DEFAULT_PROFILE="jaradtke+landing-zone-master"
## Or cut-and-paste from Isengard AWS Console icon
export AWS_ACCESS_KEY_ID="INSERTyourACCESSKEYID"
export AWS_SECRET_ACCESS_KEY="INSERTyourACCESSKEY"
export AWS_SESSION_TOKEN="A_SESSION_TOKEN_GOES_HERE"
LZCONFIGDIR=$(aws s3 ls | awk '{ print $3 }' | grep "aws-landing-zone-configuration-")

mkdir -p LandingZones/$LANDINGZONENAME; cd $_
aws s3 ls # make sure you see what you are expecting to see.
# If this next step fails, be sure that you update the KMS Kep Policy (in IAM | Encryption keys | Customer managed keys | AWSLandingZoneKey)
aws s3 cp s3://${LZCONFIGDIR}/aws-landing-zone-configuration.zip ./
unzip aws-landing-zone-configuration.zip -d aws-landing-zone-configuration
mv aws-landing-zone-configuration.zip aws-landing-zone-configuration-`date +%F`.zip
cd aws-landing-zone-configuration
# Make updates 
#  - uncomment the "regions:" values you wish to deploy to
#  - add the networking (core) account (Instructions [below](update_alz_add_networking.md#Add a Networking account)

zip -r ../aws-landing-zone-configuration.zip *
aws s3 cp ../aws-landing-zone-configuration.zip s3://${LZCONFIGDIR}/aws-landing-zone-configuration.zip
```
Once you have copied the file to the S3 bucket, CodePipeline will detect the change and re-run (and request approval, again).


## Add a Networking account
Retrieve the aws-landing-zone-configuration.zip and unpack it.
Modify the manifest file, replace the following:
```
    core_accounts:
      # Security account
      - name: security
```
With the following:
NOTE: UPdate the email address
```
>    core_accounts:
      # Networking account
      - name: networking
        email: myusername+landingzonename-networking@company.com
        ssm_parameters:
          - name: /org/member/networking/account_id
            value: $[AccountId]
        #core_resources:
          #- name: SharedBucket
            #template_file: templates/core_accounts/aws-landing-zone-networking.template
            #parameter_file: parameters/core_accounts/aws-landing-zone-networking.json
            #deploy_method: stack_set
>     # Security account
>     - name: security
```
