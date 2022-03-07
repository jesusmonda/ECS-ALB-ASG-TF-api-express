terraform {
  backend "s3" {
    bucket         = "jesusmonda-dev" // encrypted
    dynamodb_table = "jesusmonda-dev" // encrypted
    key            = "tfstate"
    region         = "eu-west-1"
    profile        = "dev"
  }
}