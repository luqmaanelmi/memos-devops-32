resource "aws_vpc" "vpc" {

cidr_block = var.cidr_block
enable_dns_hostnames = true
enable_dns_support   = true

tags = {
  Name = var.vpc_name
}

  
}


resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidr_1
    availability_zone = var.availability_zone_1
    map_public_ip_on_launch = true
    tags = {
      Name ="${var.vpc_name}-public-1"
    }
   

  
}

resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidr_2
    availability_zone = var.availability_zone_2
    map_public_ip_on_launch = true
    tags = {
      Name ="${var.vpc_name}-public-2"
    }
   

  
}



resource "aws_subnet" "private_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidr_1
    availability_zone = var.availability_zone_1
    map_public_ip_on_launch = false
    tags = {
      Name ="${var.vpc_name}-private-1"
    }
   

  
}



resource "aws_subnet" "private_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidr_2
    availability_zone = var.availability_zone_2
    map_public_ip_on_launch = false
    tags = {
      Name ="${var.vpc_name}-private-2"
    }
   

  
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name= "${var.vpc_name}-igw"

    }

  
}


resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  connectivity_type = "public"

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}


resource "aws_security_group" "alb_sg" {
  name        = "${var.vpc_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-alb-sg"
  }
}

resource "aws_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.vpc_name}-ecs-sg"
  description = "Security group for ECS"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-ecs-sg"
  }
}

resource "aws_security_group_rule" "ecs_ingress" {
  type                     = "ingress"
  from_port                = 5230
  to_port                  = 5230
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ecs_sg.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_sg.id
}