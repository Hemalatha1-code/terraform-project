# 2. Main VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id # Attaches directly to the VPC created above

  tags = {
    Name = "main-igw"
  }
}