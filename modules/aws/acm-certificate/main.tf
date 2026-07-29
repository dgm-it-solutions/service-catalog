resource "aws_acm_certificate" "this" {
  region                    = var.region
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method
  key_algorithm             = var.key_algorithm
  tags                      = var.tags

  dynamic "options" {
    for_each = var.options == null ? [] : [var.options]
    content {
      certificate_transparency_logging_preference = options.value.certificate_transparency_logging_preference
      export                                      = options.value.export
    }
  }

  dynamic "validation_option" {
    for_each = var.validation_option == null ? [] : var.validation_option
    content {
      domain_name       = validation_option.value.domain_name
      validation_domain = validation_option.value.validation_domain
    }
  }
}
