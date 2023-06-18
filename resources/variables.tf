variable "ami-id" {
  description = "Id de la Ami"
  type        = string
  default     = "ami-04a0ae173da5807d3" # Id de Amazon Linux
}
variable "vpc_cidr" {
  description = "CIDR para VPC"
  default     = "10.0.0.0/16"
}
/* esta variable nos servira para las subnets pero al tener mas de una, tengo que pensar como usarla
variable "subnet_cidr" {
  description = "Subnet de CIDR"
  default     = ""
}
*/
variable "vpc_aws_az" {
  description = "Zona de disponibilidad para VPC"
  default     = "us-east-1a"
}
