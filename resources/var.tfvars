vpc_aws_az = "us-east-1a"
vpc_cidr = "10.0.0.0/16"
ami_id = "ami-04a0ae173da5807d3" # Id de Amazon Linux
instance_type = "t3.large"
# Para aplicar estos valores debemos hacer terraform apply -var-file=var.tfvars