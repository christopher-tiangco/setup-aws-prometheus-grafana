### Overview
This repository contains the terraform configuration for automating Amazon Prometheus and Amazon Grafana setup.

### How to use / Steps
- Go to AWS Console and switch to "US East 1 (N. Virginia)" region
- Go to AWS > "IAM Identity Center"
- Click "Enable" button at the right hand side (only if it's NOT enabled yet)
- While on the "IAM Identity Center" dashboard, click "Users" > Add user 
	- Enter the email address of the user that will be used to access Grafana (NOTE: This is the SSO user and NOT the same as AWS IAM user)
	- Fill in the rest of the required fields
	- Keep clicking Next until the setup is done
- Open the invitation email received from AWS and setup the password
- Go to AWS > IAM and create (or choose an existing user) that will be used by Terraform to run the setup
- Make sure the following IAM Permission policies are attached to this IAM user
  - AmazonPrometheusFullAccess
  - AWSGrafanaAccountAdministrator
  - AWSGrafanaWorkspacePermissionManagement
- Attach the following "inline policy" to this IAM user
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"iam:CreateRole",
				"iam:ListRolePolicies",
				"iam:ListAttachedRolePolicies",
				"iam:ListInstanceProfilesForRole",
				"iam:DeleteRole",
				"sso:DescribeRegisteredRegions",
				"sso:CreateManagedApplicationInstance",
                                "sso:DeleteManagedApplicationInstance",
                                "iam:AttachRolePolicy"
			],
			"Resource": "*"
		}
	]
}
```
- Clone this repository
- Add the file `inputs.tfvars` with the following
```
AWS_REGION = "us-east-1"
AWS_ACCESS_KEY = ""
AWS_SECRET_KEY = ""
ADMIN_GRAFANA_USER_ID = ""
```
- NOTES:
  - Set `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` with the AWS Access key / Secret Key of the IAM user above
  - Set `ADMIN_GRAFANA_USER_ID` with the `User ID` of the user created on the "IAM Identity Center"
- Run the terraform configuration: `terraform apply --var-file="inputs.tfvars"`
