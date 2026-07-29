module "plinio_test" {
  source = "../../modules/github/repository"

  repository_name        = "plinio-test"
  repository_description = "Test repository"
  repository_topics      = ["test", "plinio"]
  template = {
    include_all_branches = false
    repository           = "aws-sam-python-api-gateway-lambda-template"
  }
}


module "github-actions-oidc-role-playground" {
  providers = { aws = aws.playground }
  source    = "../../modules/aws/github-oidc-role"

  repository_name = module.plinio_test.repository_name
}


module "ruleset" {
  source = "../../modules/github/branch-ruleset"

  repository_name = module.plinio_test.repository_name
  ruleset_name    = "ruleset-test"
  enforcement     = "active"

  bypass_actors_config = {
    actor_id    = 1
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }

  status_checks = {
    required_checks = [
      {
        context        = "unit-tests"
        integration_id = "15368"
      }
    ]
    strict_required_status_checks_policy = true
    do_not_enforce_on_create             = false
  }

}

module "environment-production" {
  source = "../../modules/github/environment"

  repository_name  = module.plinio_test.repository_name
  environment_name = "production"
  branch_pattern   = "main"
  # reviewers = {
  #   users = ["plinioh"]
  #   teams = []
  # }
  github_environment_variables = [
    {
      variable_name = "AWS_REGION"
      value         = "us-east-1"

    },
    {
      variable_name = "AWS_ROLE_NAME"
      value         = ""
    }
  ]
}

module "environment-playground" {
  source = "../../modules/github/environment"

  repository_name  = module.plinio_test.repository_name
  environment_name = "playground"
  branch_pattern   = "main"
  reviewers = {
    users = ["plinioh"]
    teams = []
  }
  github_environment_variables = [
    {
      variable_name = "AWS_REGION"
      value         = "us-east-1"

    },
    {
      variable_name = "AWS_ROLE_NAME"
      value         = module.github-actions-oidc-role-playground.role_arn
    }
  ]
}
