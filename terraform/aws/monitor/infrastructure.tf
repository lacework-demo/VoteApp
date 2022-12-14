resource "aws_vpc" "main" {
   tags = {
      Name = "main"
   }
   cidr_block = var.vpc_cidr
   enable_dns_hostnames = "true"
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main-gw"
    }
}

resource "aws_subnet" "public" {
   vpc_id = aws_vpc.main.id
   cidr_block = var.vpc_public_subnet
   map_public_ip_on_launch = "true"
   depends_on = [aws_internet_gateway.gateway]
   tags = {
       Name = "Public Subnet"
   }
}

resource "aws_subnet" "private" {
   vpc_id = aws_vpc.main.id
   cidr_block = var.vpc_private_subnet
   map_public_ip_on_launch = false
   tags = {
       Name = "Private Subnet"
   }
}
