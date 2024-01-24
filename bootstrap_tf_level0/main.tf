resource "aws_s3_bucket" "tf_remote_state" {
    bucket = "tf-remote-state-6166-1131-7351"
}

resource "aws_dynamodb_table" "tf_remote_state" {
    name            = "tf-remote-state"
    billing_mode    = "PROVISIONED"
    read_capacity   = 1
    write_capacity  = 1
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
