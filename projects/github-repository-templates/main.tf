module "aws-sam-api-gateway-lambda" {
  source = "../../modules/github/repository"

  is_template            = true
  repository_name        = "aws-sam-python-api-gateway-lambda-template"
  repository_description = "Template for AWS SAM Python API Gateway and Lambda project"
  repository_topics      = ["aws", "sam", "python", "lambda", "api-gateway", "template"]
}
