terraform {
  backend "s3" {
    bucket         = "movies-tf-state-bucket"
    key            = "infra/rhel9.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    use_lockfile   = true
  }
}