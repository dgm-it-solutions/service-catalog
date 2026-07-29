# Required variables
variable "repository_name" {
  description = "The name of the repository."
  type        = string
}

variable "repository_description" {
  description = "The description of the repository."
  type        = string
}

variable "repository_topics" {
  description = "The topics of the repository."
  type        = list(string)
  default     = []

}


# Optional variables
variable "homepage_url" {
  description = "(Optional) URL of a page describing the project."
  type        = string
  default     = null
}

variable "visibility" {
  description = "The visibility of the repository. Can be 'public', 'private', or 'internal'."
  type        = string
  default     = "private"
}

variable "gitignore_template" {
  description = "(Optional) Use the [name of the template](https://github.com/github/gitignore) without the extension. For example, 'Haskell'."
  type        = string
  default     = null
}

variable "issues_enabled" {
  description = "Whether issues are enabled for this repository."
  type        = bool
  default     = true
}

variable "projects_enabled" {
  description = "Whether projects are enabled for this repository."
  type        = bool
  default     = false
}

variable "wiki_enabled" {
  description = "Whether the wiki is enabled for this repository."
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Whether to allow merge commits."
  type        = bool
  default     = false
}

variable "allow_squash_merge" {
  description = "Whether to allow squash merges."
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Whether to allow rebase merges."
  type        = bool
  default     = false
}

variable "default_branch" {
  description = "The default branch of the repository."
  type        = string
  default     = "main"
}

variable "is_template" {
  description = "Whether the repository is a template."
  type        = bool
  default     = false

}

variable "template" {
  description = "The source template for the repository."
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  default = {
    owner                = ""
    repository           = ""
    include_all_branches = false

  }
}
