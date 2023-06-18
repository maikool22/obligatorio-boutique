variable "ami_id" {
  description = "Id de la Ami"
  type        = string
  default     = "" 
}
variable "vpc_cidr" {
  description = "CIDR para VPC"
  default     = ""
}
/* esta variable nos servira para las subnets pero al tener mas de una, tengo que pensar como usarla
variable "subnet_cidr" {
  description = "Subnet de CIDR"
  default     = ""
}
*/
variable "vpc_aws_az" {
  description = "Zona de disponibilidad para VPC"
  default     = ""
}
output "public_ip" {
  value = aws_instance.oblimanual-inst1.public_ip
}