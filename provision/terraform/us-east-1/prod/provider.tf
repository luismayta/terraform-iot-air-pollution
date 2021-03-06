#
# Terraform required version
#
provider "aws" {
  region  = var.aws_region
  version = ">=1.26.0"
  alias   = "main"
}

# AWS Region for Cloudfront (ACM certs only supports us-east-1)
provider "aws" {
  version = ">=1.26.0"
  region  = var.aws_region
  alias   = "cloudfront"
}

provider "template" {
  version = ">=1.0.0"
}

provider "null" {
  version = ">=0.1.0"
}

provider "tls" {
  version = ">=2.1.1"
}

provider "local" {
  version = ">=1.3.0"
}
