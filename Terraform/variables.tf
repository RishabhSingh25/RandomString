variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key name"
  default = "null"
}

variable "volume_size" {
  default = 7
}