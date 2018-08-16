# posts-function-infrastructure

Project created as a **Proof of Concept** for deploying an AWS infrastructure using Terraform.

## Diagram Flow
![Alt text](/image/workflow.png)

## Provider
The provider for this project's infrastructure is Amazon. An **aws** provider is declared for creating it. 
Properties: 
- profile: alias for the **aws_access_key_id** and **aws_secret_access_key** properties saved at the **~/.aws/credentials file**
- region: region for the provider.

## DynamoDB
For the **posts-function** project, the DynamoDB table will be used for storing posts retrieved of a fake API.
It's necessary to use an **aws_dynamodb_table** Terraform resource to create a DynamoDB table.  Properties: 
- name: it defines the DynamoDB table name
- read_capacity: number of read units for this table
- write_capacity: number of write units for this table
- hash_key: attribute used as a key for this table; it must also be defined as an `attribute`
- attribute: List of nested attributes; 

## S3
S3 is used to version source code to each release. 
An **aws_s3_bucket** Terraform resource must be provided for that.
Properties: 
- bucket: Bucket name

## Lambda Policies
### IAM
**IAM** stands by *Identity and Access Management*. It allows to define policies about which resources can be accessed using that given **IAM**. As an example, the **posts-function** Lambda needs permission to store data on DynamoDB. It's necessary to define an IAM to the lambda function and then associate it to policies which allow the lambda function to store the data at DynamoDB.

#### aws_iam_role
Terraform resource required for creating an IAM role. It can have 0 to N policies attached to it.
Properties: 
- name: name for the IAM 
- assume_role_policy: the policy that grants an entity permission to assume the role

##### aws_iam_policy_document
It creates a policy that defines which actions might be performed using such policy. In our application we allow to perform the following operations on DynamoDB:
- GetItem
- Query
- Scan
- PutItem

Properties: 
- statement: Nested configuration that defines: `actions`, `effect`, `resources`.
  - actions: list of actions that the statement allows to do (GetItem, Query,Scan, PutItem) 
  - effect: either `Allow` or `Deny` the abo=ve actions to be executed
  - resources: list or=f resource ARNS that this policy statement applies to

#### aws_iam_policy
It appends information about an `aws_iam_policy_document`. An `aws_iam_policy` allows to give a description and vinculate 
`aws_iam_policy_document` services. It can have from 0 to N policy documents attached to it.
Properties:
- name: The name of the IAM policy
- description: A description for the policy
- policy: the json policy document
In this case, this policy depends on the policy document's existence before being created.

#### aws_iam_role_policy_attachment
It attaches an IAM policy (`aws_iam_policy`) to an IAM role (`iam_for_lambda`)

Parameters:
- role: The role the policy will be applied to
- policy_arn: ARN of the policy

It depends on bothe IAM role and IAM policy's existence

## Lambda
