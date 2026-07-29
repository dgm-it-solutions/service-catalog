terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    region       = "sa-east-1"
    bucket       = var.terraform_state_bucket
    key          = "${var.github_organization_name}/service-catalog/projects/sample/terraform.tfstate"
    use_lockfile = true
  }
}

