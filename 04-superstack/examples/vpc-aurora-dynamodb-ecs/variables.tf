# General

variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

# Label

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`, `infra`)"
}

variable "app_name" {
  type        = string
  default     = ""
  description = "Name, e.g. 'app' or 'jenkins'"
}

# VPC

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnets" {
  type        = list(any)
  description = "Public Availability Zone CIDRs"
}

variable "private_subnets" {
  type        = list(any)
  description = "Private Availability Zone CIDRs"
}

variable "vpc_tags" {
  type        = map(string)
  description = "Tags to be attached to a VPC"
  default     = {}
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

# Aurora

variable "create_aurora" {
  type        = bool
  default     = false
  description = "Do we want to create an Aurora database?"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Name, e.g. 'rds-cluster1'"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "cluster_vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
  default     = ""
}

variable "cluster_subnets" {
  type        = list(string)
  description = "List of VPC subnet IDs"
  default     = []
}

variable "instance_type" {
  type        = string
  default     = "db.t2.small"
  description = "Instance type to use"
}

variable "cluster_identifier" {
  type        = string
  default     = ""
  description = "The RDS Cluster Identifier. Will use generated label ID if not supplied"
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "Specifies whether or not to create this cluster from a snapshot"
}

variable "database_name" {
  type        = string
  default     = ""
  description = "Database name (default is not to create a database)"
}

variable "db_port" {
  type        = number
  default     = "5432" # default postgresql port
  description = "Database port"
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
  type        = string
  default     = ""
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}

variable "backup_window" {
  type        = string
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = "Weekly time range during which system maintenance can occur, in UTC"
}

variable "cluster_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DB cluster parameters to apply"
}

variable "instance_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DB instance parameters to apply"
}

variable "cluster_family" {
  type        = string
  default     = "aurora5.6"
  description = "The family of the DB cluster parameter group"
}

variable "engine" {
  type        = string
  default     = "aurora"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "engine_mode" {
  type        = string
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "engine_version" {
  type        = string
  default     = ""
  description = "The version of the database engine to use. See `aws rds describe-db-engine-versions` "
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
}

variable "scaling_configuration" {
  type = list(object({
    auto_pause               = bool
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = number
    timeout_action           = string
  }))
  default     = []
  description = "List of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless`"
}

variable "timeouts_configuration" {
  type = list(object({
    create = string
    update = string
    delete = string
  }))
  default     = []
  description = "List of timeout values per action. Only valid actions are `create`, `update` and `delete`"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks allowed to access the cluster"
}

variable "publicly_accessible" {
  type        = bool
  description = "Set to true if you want your cluster to be publicly accessible (such as via QuickSight)"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode`"
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true`"
  default     = ""
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = true
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "copy_tags_to_snapshot" {
  type        = bool
  description = "Copy tags to backup snapshots"
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default     = false
}

variable "rds_monitoring_interval" {
  type        = number
  description = "Interval in seconds that metrics are collected, 0 to disable (values can only be 0, 1, 5, 10, 15, 30, 60)"
  default     = 0
}

variable "rds_monitoring_role_arn" {
  type        = string
  default     = ""
  description = "The ARN for the IAM role that can send monitoring metrics to CloudWatch Logs"
}

variable "replication_source_identifier" {
  type        = string
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica"
  default     = ""
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery"
  default     = []
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable Performance Insights"
}

variable "performance_insights_kms_key_id" {
  type        = string
  default     = ""
  description = "The ARN for the KMS key to encrypt Performance Insights data. When specifying `performance_insights_kms_key_id`, `performance_insights_enabled` needs to be set to true"
}

variable "aurora_autoscaling_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable cluster autoscaling"
}

variable "autoscaling_policy_type" {
  type        = string
  default     = "TargetTrackingScaling"
  description = "Autoscaling policy type. `TargetTrackingScaling` and `StepScaling` are supported"
}

variable "autoscaling_target_metrics" {
  type        = string
  default     = "RDSReaderAverageCPUUtilization"
  description = "The metrics type to use. If this value isn't provided the default is CPU utilization"
}

variable "autoscaling_target_value" {
  type        = number
  default     = 75
  description = "The target value to scale with respect to target metrics"
}

variable "autoscaling_scale_in_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling down activity can start. Default is 300s"
}

variable "autoscaling_scale_out_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling up activity can start. Default is 300s"
}

variable "autoscaling_min_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of instances to be maintained by the autoscaler"
}

variable "autoscaling_max_capacity" {
  type        = number
  default     = 5
  description = "Maximum number of instances to be maintained by the autoscaler"
}

variable "instance_availability_zone" {
  type        = string
  default     = ""
  description = "Optional parameter to place cluster instances in a specific availability zone. If left empty, will place randomly"
}

variable "cluster_dns_name" {
  type        = string
  description = "Name of the cluster CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `master.var.name`"
  default     = ""
}

variable "reader_dns_name" {
  type        = string
  description = "Name of the reader endpoint CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `replicas.var.name`"
  default     = ""
}

variable "global_cluster_identifier" {
  type        = string
  description = "ID of the Aurora global cluster"
  default     = ""
}

variable "source_region" {
  type        = string
  description = "Source Region of primary cluster, needed when using encrypted storage and region replicas"
  default     = ""
}

variable "iam_roles" {
  type        = list(string)
  description = "Iam roles for the Aurora cluster"
  default     = []
}

variable "backtrack_window" {
  type        = number
  description = "The target backtrack window, in seconds. Only available for aurora engine currently. Must be between 0 and 259200 (72 hours)"
  default     = 0
}

variable "enable_http_endpoint" {
  type        = bool
  description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to serverless"
  default     = false
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Additional security group IDs to apply to the cluster, in addition to the provisioned default security group with ingress traffic from existing CIDR blocks and existing security groups"

  default = []
}

# DynamoDB

variable "create_dynamodb_table" {
  description = "Controls if DynamoDB table and associated resources are created"
  type        = bool
  default     = false
}

variable "table_name" {
  description = ""
  type        = string
  default     = ""
}

variable "hash_key" {
  description = ""
  type        = string
  default     = ""
}

variable "range_key" {
  description = ""
  type        = string
  default     = ""
}

variable "billing_mode" {
  description = ""
  type        = string
  default     = "PROVISIONED"
}

variable "read_capacity" {
  description = ""
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = ""
  type        = number
  default     = 5
}

variable "autoscaling_read" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "autoscaling_write" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "autoscaling_indexes" {
  description = ""
  type        = map(any)
  default     = {}
}

variable "dynamodb_table_attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default     = []
}

variable "global_secondary_indexes" {
  description = ""
  type        = list(any)
  default     = []
}

variable "table_tags" {
  description = ""
  type        = map(any)
  default     = {}
}

# ECS

variable "create_ecs" {
  type        = bool
  default     = false
  description = "Do we want to create an ECS cluster?"
}

variable "ecs_region" {
  type = string
}

#####################Security Group for ECS Service#####################

variable "sg_name" {
  default = ""
}
variable "sg_discription" {
  default = ""
}
variable "sg_tags" {
  default = {}
}
variable "sg_ingress_from_port" {
  default = ""
}
variable "sg_ingress_to_port" {
  default = ""
}
variable "sg_ingress_protocol" {
  default = ""
}
variable "sg_ingress_cidr_blocks" {
  default = []
}
variable "sg_egress_from_port" {
  default = ""
}
variable "sg_egress_to_port" {
  default = ""
}
variable "sg_egress_protocol" {
  default = ""
}
variable "sg_egress_cidr_blocks" {
  default = []
}
####################Roles################
variable "ecs_task_role_name" {
  description = ""
  default     = ""
}
variable "ecs_task_execution_role_name" {
  description = ""
  default     = ""
}
variable "ecs_task_role_policies" {
  description = ""
  default     = ""
}

variable "ecs_task_role_policies_des" {
  description = ""
  default     = ""
}
variable "ecs_task_execution_role_policies" {
  description = ""
  default     = ""
}
variable "ecs_task_execution_role_policies_des" {
  description = ""
  default     = ""
}
variable "ecs_task_role_json" {
  description = ""
  default     = ""
}
variable "ecs_task_role_execution_json" {
  description = ""
  default     = ""
}
variable "ecs_task_role_policies_json" {
  description = ""
  default     = ""
}
variable "ecs_task_execution_policies_json" {
  description = ""
  default     = ""
}
variable "ecs_task_role_tags" {
  description = ""
  default     = {}
}
variable "ecs_task_execution_role_tags" {
  description = ""
  default     = {}
}
##################### CLUSTER ##################
variable "ecs_cluster_name" {
  description = "Name of the cluster"
  default     = ""
}

variable "cluster_capacity_provider" {
  description = "List of short names of one or more capacity providers to associate with the cluster"
  default     = []
}

variable "cluster_setting_name" {
  description = "Name of the setting to manage"
  default     = "containerInsights"
}

variable "cluster_setting_value" {
  description = "Value to assign to the setting"
  default     = "enabled"
}

variable "cluster_tags" {
  description = "Key-value mapping of the resource tags"
  default     = {}
}
############### Task- Definition for UI ################

variable "td_family" {
  description = "A unique name for your task definition"
  default     = ""
}
variable "td_fileName" {
  description = "A unique name for your task definition"
  default     = ""
}

variable "td_container_definitions" {
  description = "container definitions"
  default     = ""
}

variable "td_task_role_arn" {
  description = "The ARN of IAM role that allows your amazon ecs container task to make calls to other services"
  default     = ""
}

variable "td_execution_role_name" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the docker daemon can assume"
  default     = ""
}
variable "td_execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the docker daemon can assume"
  default     = ""
}

variable "td_network_mode" {
  description = "Docker networking mode to use for the containers"
  default     = ""
}

variable "td_cpu" {
  description = "The number of cpu units used by the task"
  default     = 1
}

variable "td_memory" {
  description = "The amount of memory used by the task"
  default     = 512
}

variable "td_requires_compatibilities" {
  description = "A set of launch Types required by the task"
  default     = ["FARGATE"]
}

variable "td_tags" {
  description = "Key-value mapping of the resource tags"
  default     = {}
}

############### ECS service for UI ################
variable "ecs_service_name" {
  description = "Name of the service"
  default     = ""
}

variable "ecs_service_deployment_controller_type" {
  description = "Type of deployment controller"
  default     = "ECS"
}

variable "deployment_maximum_percent" {
  description = "The upper limit of the number of running tasks that can be running tasks that can be running in a service during a deployment"
  default     = ""
}

variable "ecs_service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 0
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  default     = true
}

variable "enable_ecs_launch_type" {
  description = "The launch type on which to run your service"
  default     = "FARGATE"
}
variable "propagate_tags" {
  description = "propagate tags values"
  default     = "TASK_DEFINITION"
}
variable "enable_ecs_container_name" {
  description = "Name of the container as mentioned in the task definition file"
  default     = ""
}

variable "enable_ecs_container_port" {
  description = "Port number of the container where the request should be sent"
  default     = 80
}

variable "ecs_service_subnets" {
  description = "The subnets associated with the task or service"
  default     = []
}

variable "ecs_service_security_groups" {
  description = "The security groups associated with the task or service"
  default     = []
}

variable "ecs_service_assign_public_ip" {
  description = "Assign a public IP address to the ENI"
  default     = false
}

variable "ecs_service_tags" {
  description = "Key-value mapping of the resource tags"
  default     = {}
}

variable "ecs_sg_name" {
  description = "Security group name for the ecs service"
  default     = ""
}

variable "ecs_sg_description" {
  description = "Description for the security group for ecs service"
  default     = ""
}

variable "ecs_ingress_protocol" {
  description = "Ingress protocol for ecs security group"
  default     = ""
}

variable "ecs_egress_from_port" {
  description = "Starting port number for ecs egress port"
  default     = 0
}

variable "ecs_egress_to_port" {
  description = "Ending port number for ecs egress port"
  default     = 0
}

variable "ecs_egress_protocol" {
  description = "Egress protocol"
  default     = ""
}

variable "ecs_egress_cidr_block" {
  description = "Egress CIDR block"
  default     = []
}

variable "ecs_service_container_port" {
  description = "Port for ecs to which to send the request"
  default     = 0
}

#########################Auto Scaling for UI########################################
variable "ecs_target_max_capacity" {
  default = ""
}
variable "ecs_target_min_capacity" {
  default = ""
}
variable "ecs_target_resource_id" {
  default = ""
}
variable "ecs_target_scalable_dimension" {
  default = ""
}
variable "ecs_target_service_namespace" {
  default = ""
}
variable "ecs_target_cpu_tracking_name" {
  default = ""
}
variable "ecs_target_cpu_tracking_policy_type" {
  default = ""
}
variable "ecs_target_cpu_tracking_resource_id" {
  default = ""
}
variable "ecs_target_cpu_tracking_scalable_dimension" {
  default = ""
}
variable "ecs_target_cpu_tracking_service_namespace" {
  default = ""

}
variable "ecs_cpu_scaling_predefined_metric_type" {
  default = ""
}
variable "ecs_cpu_scaling_target_value" {
  default = ""
}
variable "ecs_cpu_scaling_scale_in_cooldown" {
  default = ""
}
variable "ecs_cpu_scaling_scale_out_cooldown" {
  default = ""
}
variable "ecs_target_memory_tracking_name" {
  default = ""
}
variable "ecs_target_memory_tracking_policy_type" {
  default = ""
}
variable "ecs_target_memory_tracking_resource_id" {
  default = ""
}
variable "ecs_target_memory_tracking_scalable_dimension" {
  default = ""
}
variable "ecs_target_memory_tracking_service_namespace" {
  default = ""
}
variable "ecs_memory_scaling_predefined_metric_type" {
  default = ""
}
variable "ecs_memory_scaling_target_value" {
  default = ""
}
variable "ecs_memory_scaling_scale_in_cooldown" {
  default = ""
}
variable "ecs_memory_scaling_scale_out_cooldown" {
  default = ""
}

################ ALB ##########

variable "alb_load_balancer_type" {
  description = "Type of the load balancer to make"
  default     = "application"
}

variable "alb_name" {
  default = ""
}

variable "alb_internal" {
  default = ""
}

variable "alb_security_groups" {
  default = []
}

variable "alb_idle_timeout" {
  default = 60
}

variable "alb_enable_deletion_protection" {
  default = ""
}
variable "alb_enable_cross_zone_load_balancing" {
  default = ""
}

variable "alb_enable_http2" {
  default = ""
}

variable "alb_ip_address_type" {
  default = ""
}
variable "alb_vpc_id" {
  default = ""
}

variable "alb_subnet_ids" {
  default = []
}
variable "alb_security_group" {
  default = []
}
variable "alb_tags" {
  default = {}
}
###########  UI Target Group for ALB ##############

variable "ui_tg_enable" {
  description = "Target group for either ALB or NLB"
  default     = ""
}

variable "ui_tg_name" {
  description = "Name of the load balancer"
  default     = ""
}

variable "ui_tg_port" {
  description = "The port on which the target receives the traffic"
  default     = ""
}

variable "ui_tg_protocol" {
  description = "The protocol to use for routing traffic to targets"
  default     = ""
}

variable "ui_tg_vpc_id" {
  description = "VPC id in which to create the target group"
  default     = ""
}

variable "ui_tg_health_check_enabled" {
  default = true
}

variable "ui_tg_health_check_interval" {
  default = 30
}

variable "ui_tg_health_check_path" {
  default = ""
}

variable "ui_tg_health_check_port" {
  default = "traffic-port"
}

variable "ui_tg_health_check_protocol" {
  default = "HTTP"
}

variable "ui_tg_health_check_timeout" {
  default = ""
}

variable "ui_tg_healthy_threshold" {
  default = 3
}

variable "ui_tg_unhealthy_threshold" {
  default = 3
}

variable "ui_tg_matcher" {
  default = ""
}

variable "ui_tg_target_type" {
  default = ""
}
variable "ui_tg_stickiness_type" {
  default = ""
}
variable "ui_tg_cookie_enabled" {
  default = false
}
variable "ui_tg_tags" {
  default = {}
}
###########  Ser Target Group for ALB ##############

variable "ser_tg_enable" {
  description = "Target group for either ALB or NLB"
  default     = ""
}

variable "ser_tg_name" {
  description = "Name of the load balancer"
  default     = ""
}

variable "ser_tg_port" {
  description = "The port on which the target receives the traffic"
  default     = ""
}

variable "ser_tg_protocol" {
  description = "The protocol to use for routing traffic to targets"
  default     = ""
}

variable "ser_tg_vpc_id" {
  description = "VPC id in which to create the target group"
  default     = ""
}

variable "ser_tg_health_check_enabled" {
  default = true
}

variable "ser_tg_health_check_interval" {
  default = 30
}

variable "ser_tg_health_check_path" {
  default = ""
}

variable "ser_tg_health_check_port" {
  default = "traffic-port"
}

variable "ser_tg_health_check_protocol" {
  default = "HTTP"
}

variable "ser_tg_health_check_timeout" {
  default = ""
}

variable "ser_tg_healthy_threshold" {
  default = 3
}

variable "ser_tg_unhealthy_threshold" {
  default = 3
}

variable "ser_tg_matcher" {
  default = ""
}

variable "ser_tg_target_type" {
  default = ""
}
variable "ser_tg_stickiness_type" {
  default = ""
}
variable "ser_tg_cookie_enabled" {
  default = false
}
################ Service Load Balancer Listener ###################

variable "lb_listener_action_type" {
  description = "Type of routing action"
  default     = ""
}

variable "lb_listener_port" {
  description = "The port on which the load balancer is listening"
  default     = ""
}

variable "lb_listener_protocol" {
  description = "The protocol for connections from clients to the load balancers"
  default     = "HTTP"
}

variable "lb_listener_ssl_policy" {
  description = "Name of the SSL policy for the listener"
  default     = ""
}

variable "lb_listener_certificate_arn" {
  description = "The ARN of the default SSL server certificate"
  default     = ""
}

variable "lb_listener_redirect_host" {
  description = "The hostname"
  default     = ""
}

variable "lb_listener_redirect_path" {
  description = "The absolute path, starting with the leading '/'"
  default     = ""
}

variable "lb_listener_redirect_port" {
  description = "The port value to redirect to"
  default     = ""
}

variable "lb_listener_redirect_protocol" {
  description = "The protocol to route to"
  default     = ""
}

variable "lb_listener_redirect_query" {
  description = "Query parameters. Do not include the leading '?'"
  default     = ""
}

variable "lb_listener_redirect_status_code" {
  description = "The HTTP redirect code"
  default     = ""
}

variable "lb_listener_fixed_response_content_type" {
  description = "The content type"
  default     = ""
}

variable "lb_listener_fixed_response_message_body" {
  description = "The message body"
  default     = ""
}

variable "lb_listener_fixed_response_status_code" {
  description = "The HTTP response code"
  default     = ""
}


################ NLB Ingress ##########
variable "nlb_vpc_id" {
  default = ""
}
variable "nlb_name" {
  default = ""
}

variable "nlb_internal" {
  default = true
}

variable "nlb_load_balancer_type" {
  default = "network"
}

variable "nlb_security_group" {
  default = ""
}
variable "nlb_idle_timeout" {
  default = ""
}
variable "nlb_enable_deletion_protection" {
  default = ""
}
variable "nlb_enable_cross_zone_load_balancing" {
  default = ""
}
variable "nlb_enable_http2" {
  default = ""
}
variable "nlb_ip_address_type" {
  default = ""
}
variable "nlb_subnet_ids" {
  default = ""
}
variable "nlb_tags" {
  default = {}
}
###########  Target Group for NLB ##############

variable "net_tg_enable" {
  description = "Target group for either ALB or NLB"
  default     = ""
}

variable "net_tg_name" {
  description = "Name of the load balancer"
  default     = ""
}

variable "net_tg_port" {
  description = "The port on which the target receives the traffic"
  default     = ""
}

variable "net_tg_protocol" {
  description = "The protocol to use for routing traffic to targets"
  default     = ""
}

variable "net_tg_vpc_id" {
  description = "VPC id in which to create the target group"
  default     = ""
}

variable "net_tg_health_check_enabled" {
  default = true
}

variable "net_tg_health_check_interval" {
  default = 30
}

variable "net_tg_health_check_path" {
  default = ""
}

variable "net_tg_health_check_port" {
  default = "traffic-port"
}

variable "net_tg_health_check_protocol" {
  default = "HTTP"
}

variable "net_tg_health_check_timeout" {
  default = ""
}

variable "net_tg_healthy_threshold" {
  default = 3
}

variable "net_tg_unhealthy_threshold" {
  default = 3
}

variable "net_tg_matcher" {
  default = ""
}

variable "net_tg_target_type" {
  default = ""
}
variable "net_tg_tags" {
  default = {}
}
################ Network Load Balancer Listener ###################

variable "net_lb_listener_action_type" {
  description = "Type of routing action"
  default     = ""
}

variable "net_lb_listener_port" {
  description = "The port on which the load balancer is listening"
  default     = ""
}

variable "net_lb_listener_protocol" {
  description = "The protocol for connections from clients to the load balancers"
  default     = "HTTP"
}

variable "net_lb_listener_ssl_policy" {
  description = "Name of the SSL policy for the listener"
  default     = ""
}

variable "net_lb_listener_certificate_arn" {
  description = "The ARN of the default SSL server certificate"
  default     = ""
}

variable "net_lb_listener_redirect_host" {
  description = "The hostname"
  default     = ""
}

variable "net_lb_listener_redirect_path" {
  description = "The absolute path, starting with the leading '/'"
  default     = ""
}

variable "net_lb_listener_redirect_port" {
  description = "The port value to redirect to"
  default     = ""
}

variable "net_lb_listener_redirect_protocol" {
  description = "The protocol to route to"
  default     = ""
}

variable "net_lb_listener_redirect_query" {
  description = "Query parameters. Do not include the leading '?'"
  default     = ""
}

variable "net_lb_listener_redirect_status_code" {
  description = "The HTTP redirect code"
  default     = ""
}

variable "net_lb_listener_fixed_response_content_type" {
  description = "The content type"
  default     = ""
}

variable "net_lb_listener_fixed_response_message_body" {
  description = "The message body"
  default     = ""
}

variable "net_lb_listener_fixed_response_status_code" {
  description = "The HTTP response code"
  default     = ""
}
############### VPC Endpoint Service ###############
variable "vpce_acceptance_required" {
  description = "Whether or not VPC endpoint connection requests to the service must be accepted by the service owner"
  default     = true
}

variable "vpce_tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "vpc_endpoint_type" {
  description = "The VPC endpoint type"
  default     = ""
}

variable "vpc_endpoint_service_name" {
  description = "The VPC endpoint type"
  default     = ""
}
variable "auto_accept" {
  description = "Auto accept the request from the endpoint to the endpoint service"
  default     = true
}
##################################Endpoint##################
variable "endpoint_vpc_id" {
  default = ""
}

variable "endpoint_subnet_ids" {
  default = []
}
variable "endpoint_security_group" {
  default = []
}
variable "endpoint_dns_enabled" {
  default = true
}
variable "endpoint_type" {
  description = "endpoint_type"
  default     = "Interface"
}
variable "endpoint_project" {
  description = "Project Name"
  default     = ""
}
variable "endpoint_tag_specifications" {
  description = "ebs volume tag name"
  default     = "Internal"
}
variable "endpoint_application_type" {
  description = "application type"
  default     = ""
}
variable "endpoint_environment" {
  description = "project environment"
  default     = ""
}
variable "endpoint_name" {
  description = "project environment"
  default     = ""
}
variable "endpoint_tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
##################################Route 53##########################
variable "route53_domain_name" {
  description = "The domain name of the Route53 hosted zone"
  default     = ""
}

variable "route53_record_type" {
  description = "The Route53 hosted zone record type"
  default     = "A"
}

variable "route53_evaluate_target_health" {
  default = true
}
variable "route53_vpc_id" {
  default = ""
}
variable "route53_tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
variable "cloudwatch_mws_lg" {
  default = ""
}

### Remote state file
variable "remotestate_bucket_name" {
  description = "remote bucket state"
  default     = "tf-state"
}

variable "state_file" {
  description = "State file"
  default     = "vpc"
}

variable "terraform_region" {
  description = " Default region where state file exists"
  default     = "eu-west-1"
}


variable "state_file_sg" {
  description = "State file"
  default     = "sg"
}

############################################################
###   input
####################################################################

variable "non_routable_vpc" {
  default = ""
}
variable "non_routable_vpc_security_group" {
  default = []
}
variable "non_routable_vpc_subnet_ids" {
  default = []
}
variable "routable_vpc" {
  default = ""
}
variable "routable_vpc_security_group" {
  default = []
}
variable "routable_vpc_subnet_ids" {
  default = []
}
variable "cloudwatch_lg" {
  default = ""
}

#
# Alarms
#

variable "alarm_topic" {
  type        = string
  description = "An SNS Topic ARN for ECS Service and Target Group alarms"
  default     = ""
}

variable "ecs_alarms_enabled" {
  type        = bool
  description = "A boolean to enable/disable CloudWatch Alarms for ECS Service metrics"
  default     = false
}

variable "ecs_alarms_cpu_utilization_high_threshold" {
  type        = number
  description = "The maximum percentage of CPU utilization average"
  default     = 80
}

variable "ecs_alarms_cpu_utilization_high_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm"
  default     = 1
}

variable "ecs_alarms_cpu_utilization_high_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 300
}

variable "ecs_alarms_cpu_utilization_low_threshold" {
  type        = number
  description = "The minimum percentage of CPU utilization average"
  default     = 20
}

variable "ecs_alarms_cpu_utilization_low_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm"
  default     = 1
}

variable "ecs_alarms_cpu_utilization_low_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 300
}

variable "ecs_alarms_memory_utilization_high_threshold" {
  type        = number
  description = "The maximum percentage of Memory utilization average"
  default     = 80
}

variable "ecs_alarms_memory_utilization_high_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm"
  default     = 1
}

variable "ecs_alarms_memory_utilization_high_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 300
}

variable "ecs_alarms_memory_utilization_low_threshold" {
  type        = number
  description = "The minimum percentage of Memory utilization average"
  default     = 20
}

variable "ecs_alarms_memory_utilization_low_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm"
  default     = 1
}

variable "ecs_alarms_memory_utilization_low_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 300
}

# ECS Autoscaling

#
# Autoscaling
#

variable "ecs_autoscaling_enabled" {
  type        = bool
  description = "A boolean to enable/disable Autoscaling policy for ECS Service"
  default     = false
}

variable "autoscaling_dimension" {
  type        = string
  description = "Dimension to autoscale on (valid options: cpu, memory)"
  default     = "memory"
}

variable "ecs_autoscaling_min_capacity" {
  type        = number
  description = "Minimum number of running instances of a Service"
  default     = 1
}

variable "ecs_autoscaling_max_capacity" {
  type        = number
  description = "Maximum number of running instances of a Service"
  default     = 2
}

variable "autoscaling_scale_up_adjustment" {
  type        = number
  description = "Scaling adjustment to make during scale up event"
  default     = 1
}

variable "autoscaling_scale_up_cooldown" {
  type        = number
  description = "Period (in seconds) to wait between scale up events"
  default     = 60
}

variable "autoscaling_scale_down_adjustment" {
  type        = number
  description = "Scaling adjustment to make during scale down event"
  default     = -1
}

variable "autoscaling_scale_down_cooldown" {
  type        = number
  description = "Period (in seconds) to wait between scale down events"
  default     = 300
}
