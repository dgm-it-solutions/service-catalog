# SAM S3 Bucket

This module creates the CloudFormation stack that the AWS SAM CLI looks for when bootstrapping itself. The template creates the S3 Bucket used to store lambda artifacts.

We want to create this bucket manually in order to be able to configure custom tags and a lifecycle policy for it.
