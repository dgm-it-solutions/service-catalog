variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name for which the certificate should be issued."
  type        = string
  default     = null
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate."
  type        = set(string)
  default     = null
}

variable "validation_method" {
  description = "Which method to use for validation. DNS or EMAIL are valid."
  type        = string
  default     = null
}


variable "key_algorithm" {
  description = "Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "options" {
  description = "Configuration block used to set certificate options."
  type = object({
    certificate_transparency_logging_preference = optional(string)
    export                                      = optional(string)
  })
  default = null
}

variable "validation_option" {
  description = "Configuration block used to specify information about the initial validation of each domain name."
  type = set(object({
    domain_name       = string
    validation_domain = string
  }))
  default = null
}
