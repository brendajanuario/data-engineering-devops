provider "aws" {
  region = "us-east-1"
}

variable "account_number" {
  default = "485242421974"
}

terraform {
  backend "s3" {
    bucket = "terraform-ias-cognitivo"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}