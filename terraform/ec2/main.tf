provider "aws" {
  region = local.region
}

locals {
  name   = "example-ec2-complete"
  region = "eu-west-1"

  user_data = <<-EOT
  #!/bin/bash
  echo "Hello Terraform!"
  EOT

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

