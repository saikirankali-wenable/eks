resource "aws_vpc" "worker_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    

    tags = {
        Name ="k8s_vpc"
    }

}
resource "aws_subnet" "worker" {
    vpc_id = aws_vpc.worker_vpc.id
    availability_zone = data.aws_availability_zones.my_zone.names[count.index]
    count = 3
    cidr_block = "10.0.${count.index}/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "eks-subnet"
    }

  
}

resource "aws_internet_gateway" "worker_IGW" {
    vpc_id = aws_vpc.worker_vpc.id
    tags = {
        Name = "worker-IGW"

    }
  
}
resource "aws_route_table" "worker_route_table" {
    vpc_id = aws_vpc.worker_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.worker_IGW.id
    }
  
}


resource "aws_route_table_association" "worker_assosciation" {
    count = 3
    subnet_id = aws_subnet.worker[count.index].id
    route_table_id = aws_route_table.worker_route_table.id
  
}