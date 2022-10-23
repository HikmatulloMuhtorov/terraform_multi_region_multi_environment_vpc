provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  alias = "alt_region"
  region = "us-west-2"
}