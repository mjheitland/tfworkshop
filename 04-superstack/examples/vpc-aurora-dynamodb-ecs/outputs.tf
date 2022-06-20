output "database_name" {
  value       = module.aurora_superstack_example.database_name
  description = "Database name"
}

output "master_username" {
  value       = module.aurora_superstack_example.master_username
  description = "Username for the master DB user"
}

output "cluster_identifier" {
  value       = module.aurora_superstack_example.cluster_identifier
  description = "Cluster Identifier"
}

output "arn" {
  value       = module.aurora_superstack_example.arn
  description = "Amazon Resource Name (ARN) of cluster"
}

output "endpoint" {
  value       = module.aurora_superstack_example.endpoint
  description = "The DNS address of the RDS instance"
}

output "reader_endpoint" {
  value       = module.aurora_superstack_example.reader_endpoint
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "master_host" {
  value       = module.aurora_superstack_example.master_host
  description = "DB Master hostname"
}

output "replicas_host" {
  value       = module.aurora_superstack_example.replicas_host
  description = "Replicas hostname"
}

output "dbi_resource_ids" {
  value       = module.aurora_superstack_example.dbi_resource_ids
  description = "List of the region-unique, immutable identifiers for the DB instances in the cluster"
}

output "cluster_resource_id" {
  value       = module.aurora_superstack_example.cluster_resource_id
  description = "The region-unique, immutable identifie of the cluster"
}

output "vpc_cidr" {
  value = module.aurora_superstack_example.vpc_cidr
}
