
resource "aws_volume_attachment" "oblimanual-pv-attach" {    
    device_name = "/dev/xvdf"
    volume_id = aws_ebs_volume.oblimanual-redis-ebs.id
    instance_id = aws_instance.bastion.id      
}

resource "aws_ebs_volume" "oblimanual-redis-ebs" {
    availability_zone = "us-east-1a"
    size = 13
    tags = {
        Name = "oblimanual-redis-ebs"
    }  
}


