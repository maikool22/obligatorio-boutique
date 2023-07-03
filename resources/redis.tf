# resource "aws_elasticache_cluster" "oblimanual-elasticache" {
#   cluster_id           = "oblimanual-elasticache"
#   engine               = "redis"
#   node_type            = "cache.t4g.micro"
#   num_cache_nodes      = 1
#   parameter_group_name = "default.redis3.2"
#   engine_version       = "3.2.10"
#   port                 = 6379
# }

resource "aws_ebs_volume" "oblimanual-redis-ebs" {
    availability_zone = "us-east-1a"
    size = 13
    tags = {
        Name = "oblimanual-redis-ebs"
    }  
}

resource "aws_volume_attachment" "oblimanual-pv-attach" {
    depends_on = [ aws_instance.bastion ]
    device_name = "/dev/xvdf"
    volume_id = aws_ebs_volume.oblimanual-redis-ebs.id
    instance_id = aws_instance.bastion.id      
}

