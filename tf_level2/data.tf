data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "tf-remote-state-6166-1131-7351"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}
