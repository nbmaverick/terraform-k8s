data "terraform_remote_state" "main" {
  backend = "s3"
  config = {
    bucket = "test-bucket3-terraform"
    key    = "path/to/my/key"
    region = "eu-west-1"
  }
}

output "full_list" {
  value = data.terraform_remote_state.main.outputs.*
}