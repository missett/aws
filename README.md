# Terraform AWS Code

Each module configures some different functionality, so each module needs a different IAM user with different permissiosn.

These permissions are specified within the module itself.

Each module can be planned/applied by putting a .env file in the directory with a AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env var and then running `env $(cat .env | xargs) terraform apply`.

## Modules
*iam*

Special module that creates and manages all IAM users and the TF state backend s3 bucket. If the account needs to be recreated from the ground up, the 'backend' block should be commented out from this file and then the TF code should be applied to generate a local tfstate file. Then, un-comment the s3 backend and re-apply so the tfstate is moved into the new s3 bucket. Then just delete your local s3 files.

_Permissions_- IAMFullAccess, AmazonS3FullAccess, AWSBudgetsActionsWithAWSResourceControlAccess
