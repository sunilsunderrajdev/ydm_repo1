terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "s3" {
    bucket          = "tf-remote-state.6166-1131-7351"
    key             = "tf.state"
    region          = "us-east-1"
    dynamodb_table  = "tf-remote-state"
  }
}

provider "aws" {
  region = "us-east-1"
}
