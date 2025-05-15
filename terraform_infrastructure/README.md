# terraform_infrastructure

## Naming Conventions

The naming conventions are so far defined as : 

    eeeppplll-dddd-nnn

Where "eee" = Environment :

|Environment|Description|
|----|----|
|dev|Development|
|tst|Test|
|pre|Pre-production|
|prd|Production|

"ppp" = Project or Application : 

|Project|Description|
|wpt|Waste Permits|
|wab|Water Abstraction|
|inf|Infrastructure|
|dtp|Digital Transformation| 

"lll" = Region Identifier, where applicable (S3 naming does not use these) :

|Region|AWS Region|Description|
|----|----|----|
|LDN|eu-west-2|London|

"dddd" = any descriptior, depending on circumstance. 

and "nnn", which is an instance / count number, where necessary

## Running Terraform

### Credentials

To run terraform locally, first obtain credentials for an IAM user with the correct permissions. Currently we have the "terraform" user setup with administrator access. To obtain the credentials :

1. Go into AWS, into IAM, then "Users"
2. Click into the "terraform" user (or another user with correct permissions)
3. Go to the "Security credentials" tab
4. "Access Keys" is what we need. If they are lost, we can regenerate here.

### Workspaces

Terraform uses "workspaces", which separated areas allowing us to have a separate state for each environment, whilst running from the same codebase.

To create workspaces :

```
terraform workspace new dev
terraform workspace new tst
terraform workspace new pre
terraform workspace new prd
```

To select a workspace to use, for example "dev" : 

```
terraform workspace select dev
```
