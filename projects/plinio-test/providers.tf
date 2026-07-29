terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "github" {
  owner            = "ebanx"
  retryable_errors = [500, 502, 503, 504, 404]
}

provider "aws" {
  profile = "root-147997117328"
  alias   = "playground"
  region  = "us-east-1"
}
