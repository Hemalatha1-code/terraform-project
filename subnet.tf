# Public Subnet 1 (AZ 1 - us-west-1a)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true

  tags = { Name = "Public-1" }
}

# Public Subnet 2 (AZ 2 - us-west-1c)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true

  tags = { Name = "Public-2" }
}

# Private Subnet 1 (AZ 1 - us-west-1a)
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1a"

  tags = { Name = "Private-Subnet-1" }
}

# Private Subnet 2 (AZ 2 - us-west-1c)
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-1c"

  tags = { Name = "Private-Subnet-2" }
}