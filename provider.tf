variable "aws_access_key_id" {
  default = "No-Hay-Credenciales"
}
variable "aws_secret_access_key" {
  default = "No-Hay-Credenciales"
}
variable "aws_session_token" {
  default = "No-Hay-Credenciales"
}

variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  token = var.aws_session_token
}
