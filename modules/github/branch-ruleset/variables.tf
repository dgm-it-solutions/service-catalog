# Required variables

variable "repository_name" {
  description = "The name of the repository to which the ruleset will be applied."
  type        = string

}

variable "ruleset_name" {
  description = "The name of the ruleset."
  type        = string
}

variable "target_branches" {
  description = <<-EOT
  Ruleset target branch configuration. Defaults to the default branch of the repository.
  Ref: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset#ref_name-1
  EOT
  type = object({
    include = list(string)
    exclude = list(string)
  })
  default = {
    include = ["~DEFAULT_BRANCH"]
    exclude = []
  }

}

variable "enforcement" {
  description = "The enforcement level for the ruleset. Must be one of 'active', 'disabled' or 'evaluate'."
  type        = string
  validation {
    condition     = contains(["active", "disabled", "evaluate"], var.enforcement)
    error_message = "The enforcement Must be one of 'active', 'disabled' or 'evaluate'"
  }
}


variable "status_checks" {
  description = <<-EOT
  Status checks configuration.
  https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset#required_check-1

  Integration ID for GitHub Actions is: `15368`
  EOT
  type = object({
    strict_required_status_checks_policy = optional(bool)
    do_not_enforce_on_create             = optional(bool)

    required_checks = list(
      object(
        {
          context        = string
          integration_id = optional(string)
        }
      )
    )

  })
  default = null
}

variable "bypass_actors_config" {
  description = <<-EOT
  Bypass Actors configuration, read the docs for more details.
  https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset#bypass_actors
  
  For actor_type = Team, the actor_id must be a team ID, which can be obtained by:
  Going to https://github.com/orgs/<org-name>/teams/<team-name> in your browser and alt-click the avatar image to copy its address.
  The avatar will be stored at https://avatars3.githubusercontent.com/t/1234567?s=280&v=4 -- where 1234567 is that team ID.
  EOT
  type = object({
    actor_type  = string
    actor_id    = number
    bypass_mode = string
  })

  default = null

}
