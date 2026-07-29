# Required variables
variable "repository_name" {
  description = "The name of the repository."
  type        = string
}

variable "environment_name" {
  description = "The name of the environment"
  type        = string
}

variable "branch_pattern" {
  description = " The name pattern that branches must match in order to deploy to the environment"
  type        = string
}

variable "reviewers" {
  description = <<-EOT
    The reviewers for the environment.

    List of usernames and team slugs. 

    Both users and teams must have previous access to the repository.

  EOT
  type = object({
    users = optional(list(string))
    teams = optional(list(string))
  })
  default = {
    users = []
    teams = []

  }

}

variable "github_environment_variables" {
  type = list(object({
    variable_name = string
    value         = string
  }))
  default = [
    {
      variable_name = "AWS_REGION"
      value         = "us-east-1"
    },
  ]

}

# Optional variables
