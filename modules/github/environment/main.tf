resource "github_repository_environment" "this" {
  environment = var.environment_name
  repository  = var.repository_name

  reviewers {
    users = local.users_ids
    teams = local.team_ids
  }
  prevent_self_review = false

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  repository     = var.repository_name
  environment    = var.environment_name
  branch_pattern = var.branch_pattern
}

# A for_each is required as the data resource 'github_users' does not return ids, only nodeId
data "github_user" "this" {
  for_each = toset(var.reviewers.users)
  username = each.value
}

# A for_each is required as there is not data resource 'github_teams'
data "github_team" "this" {
  for_each     = toset(var.reviewers.teams)
  slug         = each.value
  summary_only = true
}

locals {
  users_ids = [for user in data.github_user.this : user.id]
  team_ids  = [for team in data.github_team.this : team.id]
}


resource "github_actions_environment_variable" "variables" {
  # object to map
  for_each = { for key, value in var.github_environment_variables : key => value }

  repository  = var.repository_name
  environment = var.environment_name

  variable_name = each.value.variable_name
  value         = each.value.value
}
