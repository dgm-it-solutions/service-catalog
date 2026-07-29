variable "github_organization_name" {
  description = "GitHub Organization to be managed"
  type        = string
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  type        = string
}

variable "github_app_pem_file" {
  description = "Path to the GitHub App PEM file"
  type        = string
}


variable "aws_role_arn" {
  description = "ARN of the AWS role to assume"
  type        = string
}

variable "aws_session_name" {
  description = "Name for the AWS IAM session"
  type        = string
}

variable "terraform_state_bucket" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
}
