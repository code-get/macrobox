provider "heroku" {
  email   = "christopherlandry64@gmail.com"
}

terraform {
  backend "s3" {
    bucket = "macroweb"
    key    = "master/terraform.tfstate"
    region = "ca-central-1"
  }
}
