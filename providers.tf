terraform {
    required_version = "1.6.4"

    backend "local" {
        path = "terraform.tfstate"
    }
}

provider "aws" {
    region = "us-east-1"
}