terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  access_key = "AKIARVC63O64NQJWJAUK"
  secret_key = "vb+kPmCCP8k5V0jTaKZxjwRp+Hd8V7scGQkSAS2eW"
}