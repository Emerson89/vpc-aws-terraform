output "private_ids" {
  description = "Output subnet private"
  value       = aws_subnet.private[*].id
}

output "private_cidrs" {
  description = "Output subnet private"
  value       = aws_subnet.private[*].cidr_block
}

output "public_ids" {
  description = "Output subnet public"
  value       = aws_subnet.public[*].id
}

output "public_cidrs" {
  description = "Output subnet public"
  value       = aws_subnet.public[*].cidr_block
}

output "additional_ids" {
  description = "Output subnet additional"
  value       = aws_subnet.additional[*].id
}

output "additional_cidrs" {
  description = "Output subnet additional"
  value       = aws_subnet.additional[*].cidr_block
}

output "vpc_id" {
  description = "Output vpc id"
  value       = try(aws_vpc.this[0].id, "")
}

output "vpc_name" {
  description = "Output vpc name"
  value       = try(aws_vpc.this[0].tags.Name, "")
}

output "vpc_cidr" {
  description = "Output vpc cidr"
  value       = try(aws_vpc.this[0].cidr_block, "")
}

output "igw" {
  description = "Output vpc cidr"
  value       = try(aws_internet_gateway.this[0].id, "")
}

output "nat" {
  description = "Output vpc cidr"
  value       = try(aws_nat_gateway.this[0].id, "")
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = try(aws_vpc.this[0].ipv6_cidr_block, null)
}

output "private_ipv6_ids" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.private[*].ipv6_cidr_block_association_id)
}

output "public_ipv6_ids" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = compact(aws_subnet.public[*].ipv6_cidr_block_association_id)
}
