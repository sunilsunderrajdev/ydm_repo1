terraform {
    required_version = "1.6.5"

    cloud {
        organization = "sunilsunderrajdev"

        workspaces {
            name = "ydm1"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}