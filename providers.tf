terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
        random = {
            source = "hashicorp/random"
        }
    }

    backend "remote" {
        organization = "sunilsunderrajdev"

        workspaces {
            name = "Github-AWS-TF_API"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}