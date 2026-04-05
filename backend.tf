terraform {
  backend "s3" {
    bucket = "my-dev-s3"
    key    = "prod/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    use_lockfile = true
    #profile = "learning2"
  }
}
