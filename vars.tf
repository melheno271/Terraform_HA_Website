variable "AWS_REGION" {
  default = "us-east-2"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = ".ssh/rid_rsa"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = ".ssh/rid_rsa.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-2 = "ami-0c2f3d2ee24929520"
  }
}

