
resource "aws_cloudformation_stack" "this" {
  name          = "aws-sam-cli-managed-default"
  template_body = file("${path.module}/template.yaml")

  capabilities = ["CAPABILITY_AUTO_EXPAND"]

  tags = {
    # Tag required to make SAM CLI believe that the stack was created by it, otherwise
    # running sam deploy will fail with the error:
    # [...] Failing as the stack was likely not created by the AWS SAM CLI
    ManagedStackSource = "AwsSamCli"
  }
}
