provider "github" {
  owner = var.github_organization_name
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file(var.github_app_pem_file)
  }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = var.aws_role_arn
    session_name = var.aws_session_name
  }
}
