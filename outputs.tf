# Output for VPC
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

# Output for Public Subnets
output "public_subnet_ids" {
  value       = aws_subnet.public_subnet.*.id
  description = "The IDs of the public subnets"
}

# Output for NAT Gateways
output "nat_gateway_ids" {
  value       = aws_nat_gateway.nat_gateway.*.id
  description = "The IDs of the NAT gateways"
}

# Output for Private Subnets
output "private_subnet_ids" {
  value       = aws_subnet.private_subnet.*.id
  description = "The IDs of the private subnets"
}


# Output for Application Load Balancer
output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "The DNS name of the Application Load Balancer"
}


