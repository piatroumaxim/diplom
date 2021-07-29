terraform {
  backend "s3" {
    bucket         = "dos02-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}