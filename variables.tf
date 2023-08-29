variable "region" {
    default = "us-west-2"
  
}

variable "desired-capacity" {
    type = number
    default = 1
  
}

variable "max-size" {
    type = number
    default = 2
}

variable "min-size" {
    type = number
    default = 1
  
}