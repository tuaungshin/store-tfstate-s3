terraform {
  backend "s3" {
    bucket = "test-tf"
    key    = "prod/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    use_lockfile = true
    profile = "learning2"
  }
}
