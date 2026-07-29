variable "repository_name" {
  description = "The name of the GitHub repository the action will be used in"
  type        = string
}

variable "default_branch_name" {
  description = "The default branch name of the GitHub repository"
  type        = string
  default     = "main"
}



