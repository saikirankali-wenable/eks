resource "aws_security_group" "worker" {
    vpc_id = aws_vpc.worker_vpc.id
    tags = {
      name = "worker_security_group"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "ssh"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}