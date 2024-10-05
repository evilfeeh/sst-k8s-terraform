variable "db_database" {
  default = "none"
  type    = string
}

variable "db_host" {
  default = "none"
  type    = string
}

variable "db_password" {
  default = "none"
  type    = string
}

variable "db_port" {
  default = 3306
  type    = number
}

variable "db_type" {
  default = "none"
  type    = string
}

variable "db_username" {
  default = "none"
  type    = string
}

variable "port" {
  default = 3000
  type    = number
}

variable "private_subnets" {
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
  type    = list(any)
}

variable "vpc_id" {
  default = "none"
  type    = string
}