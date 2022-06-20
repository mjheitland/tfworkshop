output "database_name" {
  value       = module.aurora_stack.database_name
  description = "Database name"
}

output "master_username" {
  value       = module.aurora_stack.master_username
  description = "Username for the master DB user"
}

output "cluster_identifier" {
  value       = module.aurora_stack.cluster_identifier
  description = "Cluster Identifier"
}

output "arn" {
  value       = module.aurora_stack.arn
  description = "Amazon Resource Name (ARN) of cluster"
}

output "endpoint" {
  value       = module.aurora_stack.endpoint
  description = "The DNS address of the RDS instance"
}

output "reader_endpoint" {
  value       = module.aurora_stack.reader_endpoint
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "master_host" {
  value       = module.aurora_stack.master_host
  description = "DB Master hostname"
}

output "replicas_host" {
  value       = module.aurora_stack.replicas_host
  description = "Replicas hostname"
}

output "dbi_resource_ids" {
  value       = module.aurora_stack.dbi_resource_ids
  description = "List of the region-unique, immutable identifiers for the DB instances in the cluster"
}

output "cluster_resource_id" {
  value       = module.aurora_stack.cluster_resource_id
  description = "The region-unique, immutable identifie of the cluster"
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_stack.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_stack.private_subnets
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc_stack.default_security_group_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc_stack.vpc_cidr_block
}
