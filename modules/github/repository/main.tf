resource "github_repository" "this" {
  name         = var.repository_name
  description  = var.repository_description
  homepage_url = var.homepage_url
  visibility   = var.visibility

  is_template = var.is_template

  dynamic "template" {
    for_each = var.is_template ? [] : [1]
    content {
      owner                = var.template.owner
      repository           = var.template.repository
      include_all_branches = var.template.include_all_branches
    }
  }


  has_issues                  = var.issues_enabled
  has_projects                = var.projects_enabled
  has_wiki                    = var.wiki_enabled
  allow_merge_commit          = var.allow_merge_commit
  allow_squash_merge          = var.allow_squash_merge
  allow_rebase_merge          = var.allow_rebase_merge
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"
  merge_commit_title          = "PR_TITLE"
  merge_commit_message        = "PR_BODY"
  allow_auto_merge            = true
  allow_update_branch         = true
  delete_branch_on_merge      = true
  web_commit_signoff_required = false
  gitignore_template          = var.gitignore_template

  topics = concat(var.repository_topics, ["service-catalog", ])



}
