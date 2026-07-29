resource "github_repository_ruleset" "this" {
  name        = var.ruleset_name
  repository  = var.repository_name
  target      = "branch"
  enforcement = var.enforcement

  dynamic "bypass_actors" {
    for_each = var.bypass_actors_config != null ? ["dummy_value"] : []
    content {
      actor_id    = var.bypass_actors_config.actor_id
      actor_type  = var.bypass_actors_config.actor_type
      bypass_mode = var.bypass_actors_config.bypass_mode
    }
  }

  conditions {
    ref_name {
      include = var.target_branches.include
      exclude = var.target_branches.exclude
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true # Prevent users with push access from force pushing to branches.

    pull_request {
      required_approving_review_count = 1
      dismiss_stale_reviews_on_push   = true
      require_code_owner_review       = true
      require_last_push_approval      = true
    }


    # https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks#multi-level-nested-block-structures
    dynamic "required_status_checks" {
      # Dummy for each to force the 'required_status_checks' block to be created only if status_checks is specified
      for_each = var.status_checks != null ? ["dummy_value"] : []
      content {
        strict_required_status_checks_policy = var.status_checks.strict_required_status_checks_policy
        do_not_enforce_on_create             = var.status_checks.do_not_enforce_on_create

        # Iterates over the list of required checks and creates a 'required_check' block for each one
        dynamic "required_check" {
          for_each = var.status_checks.required_checks
          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }

      }

    }
  }
}

