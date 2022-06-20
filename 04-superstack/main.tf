locals {
  use_existing_vpc = var.existing_vpc_id != "" ? true : false
  create_vpc       = var.vpc_cidr != "" ? true : false
}

module "label_stack" {
  source = "./modules/label"

  name       = var.app_name
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.label_attributes
}

module "vpc_stack" {
  source = "./modules/terraform-aws-vpc"

  create_vpc           = local.create_vpc
  azs                  = var.availability_zones
  cidr                 = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  name                 = "${var.app_name}${module.label_stack.delimiter}vpc"
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  tags                 = var.vpc_tags
  vpc_tags             = var.vpc_tags
}

module "aurora_stack" {
  source = "./modules/terraform-aws-aurora"

  enabled = var.create_aurora

  admin_password                      = var.admin_password
  admin_user                          = var.admin_user
  allowed_cidr_blocks                 = var.allowed_cidr_blocks
  apply_immediately                   = var.apply_immediately
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  autoscaling_enabled                 = var.aurora_autoscaling_enabled
  autoscaling_max_capacity            = var.autoscaling_max_capacity
  autoscaling_min_capacity            = var.autoscaling_min_capacity
  autoscaling_policy_type             = var.autoscaling_policy_type
  autoscaling_scale_in_cooldown       = var.autoscaling_scale_in_cooldown
  autoscaling_scale_out_cooldown      = var.autoscaling_scale_out_cooldown
  autoscaling_target_metrics          = var.autoscaling_target_metrics
  autoscaling_target_value            = var.autoscaling_target_value
  backtrack_window                    = var.backtrack_window
  backup_window                       = var.backup_window
  cluster_dns_name                    = var.cluster_dns_name
  cluster_family                      = var.cluster_family
  cluster_identifier                  = var.cluster_identifier
  cluster_parameters                  = var.cluster_parameters
  cluster_size                        = var.cluster_size
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  database_name                       = var.database_name
  db_port                             = var.db_port
  deletion_protection                 = var.deletion_protection
  delimiter                           = var.delimiter
  enable_http_endpoint                = var.enable_http_endpoint
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  environment                         = module.label_stack.environment
  final_snapshot_identifier_prefix    = var.final_snapshot_identifier_prefix
  global_cluster_identifier           = var.global_cluster_identifier
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  iam_roles                           = var.iam_roles
  instance_availability_zone          = var.instance_availability_zone
  instance_parameters                 = var.instance_parameters
  instance_type                       = var.instance_type
  kms_key_arn                         = var.kms_key_arn
  maintenance_window                  = var.maintenance_window
  name                                = var.cluster_name
  namespace                           = var.namespace
  performance_insights_enabled        = var.performance_insights_enabled
  performance_insights_kms_key_id     = var.performance_insights_kms_key_id
  publicly_accessible                 = var.publicly_accessible
  rds_monitoring_interval             = var.rds_monitoring_interval
  rds_monitoring_role_arn             = var.rds_monitoring_role_arn
  reader_dns_name                     = var.reader_dns_name
  replication_source_identifier       = var.replication_source_identifier
  retention_period                    = var.retention_period
  scaling_configuration               = var.scaling_configuration
  security_groups                     = var.security_groups
  skip_final_snapshot                 = var.skip_final_snapshot
  snapshot_identifier                 = var.snapshot_identifier
  source_region                       = var.source_region
  stage                               = var.stage
  storage_encrypted                   = var.storage_encrypted
  subnets                             = var.cluster_subnets
  tags                                = module.label_stack.tags
  timeouts_configuration              = var.timeouts_configuration
  vpc_id                              = var.cluster_vpc_id == "" ? module.vpc_stack.id : var.cluster_vpc_id
  vpc_security_group_ids              = var.vpc_security_group_ids
  zone_id                             = var.zone_id
}

module "dynamodb_stack" {
  source                = "./modules/terraform-aws-dynamodb"
  create_dynamodb_table = var.create_dynamodb_table

  attributes               = var.dynamodb_table_attributes
  autoscaling_indexes      = var.autoscaling_indexes
  autoscaling_read         = var.autoscaling_read
  autoscaling_write        = var.autoscaling_write
  billing_mode             = var.billing_mode
  global_secondary_indexes = var.global_secondary_indexes
  hash_key                 = var.hash_key
  name                     = var.table_name
  range_key                = var.range_key
  read_capacity            = var.read_capacity
  tags                     = var.table_tags
  write_capacity           = var.write_capacity
}


### Create my dynamoDB resources for pre-existing VPCs

data "aws_route_table" "existing_route_tables" {
  count     = local.use_existing_vpc ? length(var.existing_subnet_ids) : 0
  subnet_id = element(var.existing_subnet_ids, count.index)
}

data "aws_vpc_endpoint_service" "dynamodb" {
  count   = local.use_existing_vpc ? 1 : 0
  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = local.use_existing_vpc ? 1 : 0

  vpc_id       = var.existing_vpc_id
  service_name = data.aws_vpc_endpoint_service.dynamodb[0].service_name
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  count           = local.use_existing_vpc ? length(data.aws_route_table.existing_route_tables) : 0
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = data.aws_route_table.existing_route_tables[count.index].route_table_id
}

# ECS

module "ecs_stack" {
  source = "./modules/fargatemodules/ecs-base-cluster"

  count = var.create_ecs ? 1 : 0

  alarm_topic                                           = var.alarm_topic
  alb_enable_cross_zone_load_balancing                  = var.alb_enable_cross_zone_load_balancing
  alb_enable_deletion_protection                        = var.alb_enable_deletion_protection
  alb_enable_http2                                      = var.alb_enable_http2
  alb_idle_timeout                                      = var.alb_idle_timeout
  alb_internal                                          = var.alb_internal
  alb_ip_address_type                                   = var.alb_ip_address_type
  alb_load_balancer_type                                = var.alb_load_balancer_type
  alb_name                                              = var.alb_name
  alb_security_group                                    = var.alb_security_group
  alb_security_groups                                   = var.alb_security_groups
  alb_subnet_ids                                        = var.alb_subnet_ids
  alb_tags                                              = var.alb_tags
  alb_vpc_id                                            = var.alb_vpc_id
  auto_accept                                           = var.auto_accept
  autoscaling_dimension                                 = var.autoscaling_dimension
  autoscaling_scale_down_adjustment                     = var.autoscaling_scale_down_adjustment
  autoscaling_scale_down_cooldown                       = var.autoscaling_scale_down_cooldown
  autoscaling_scale_up_adjustment                       = var.autoscaling_scale_up_adjustment
  autoscaling_scale_up_cooldown                         = var.autoscaling_scale_up_cooldown
  cloudwatch_lg                                         = var.cloudwatch_lg
  cloudwatch_mws_lg                                     = var.cloudwatch_mws_lg
  cluster_capacity_provider                             = var.cluster_capacity_provider
  cluster_setting_name                                  = var.cluster_setting_name
  cluster_setting_value                                 = var.cluster_setting_value
  cluster_tags                                          = var.cluster_tags
  deployment_maximum_percent                            = var.deployment_maximum_percent
  ecs_alarms_cpu_utilization_high_evaluation_periods    = var.ecs_alarms_cpu_utilization_high_evaluation_periods
  ecs_alarms_cpu_utilization_high_period                = var.ecs_alarms_cpu_utilization_high_period
  ecs_alarms_cpu_utilization_high_threshold             = var.ecs_alarms_cpu_utilization_high_threshold
  ecs_alarms_cpu_utilization_low_evaluation_periods     = var.ecs_alarms_cpu_utilization_low_evaluation_periods
  ecs_alarms_cpu_utilization_low_period                 = var.ecs_alarms_cpu_utilization_low_period
  ecs_alarms_cpu_utilization_low_threshold              = var.ecs_alarms_cpu_utilization_low_threshold
  ecs_alarms_enabled                                    = var.ecs_alarms_enabled
  ecs_alarms_memory_utilization_high_evaluation_periods = var.ecs_alarms_memory_utilization_high_evaluation_periods
  ecs_alarms_memory_utilization_high_period             = var.ecs_alarms_memory_utilization_high_period
  ecs_alarms_memory_utilization_high_threshold          = var.ecs_alarms_memory_utilization_high_threshold
  ecs_alarms_memory_utilization_low_evaluation_periods  = var.ecs_alarms_memory_utilization_low_evaluation_periods
  ecs_alarms_memory_utilization_low_period              = var.ecs_alarms_memory_utilization_low_period
  ecs_alarms_memory_utilization_low_threshold           = var.ecs_alarms_memory_utilization_low_threshold
  autoscaling_enabled                                   = var.ecs_autoscaling_enabled
  autoscaling_max_capacity                              = var.ecs_autoscaling_max_capacity
  autoscaling_min_capacity                              = var.ecs_autoscaling_min_capacity
  ecs_cluster_name                                      = var.ecs_cluster_name
  ecs_cpu_scaling_predefined_metric_type                = var.ecs_cpu_scaling_predefined_metric_type
  ecs_cpu_scaling_scale_in_cooldown                     = var.ecs_cpu_scaling_scale_in_cooldown
  ecs_cpu_scaling_scale_out_cooldown                    = var.ecs_cpu_scaling_scale_out_cooldown
  ecs_cpu_scaling_target_value                          = var.ecs_cpu_scaling_target_value
  ecs_egress_cidr_block                                 = var.ecs_egress_cidr_block
  ecs_egress_from_port                                  = var.ecs_egress_from_port
  ecs_egress_protocol                                   = var.ecs_egress_protocol
  ecs_egress_to_port                                    = var.ecs_egress_to_port
  ecs_ingress_protocol                                  = var.ecs_ingress_protocol
  ecs_memory_scaling_predefined_metric_type             = var.ecs_memory_scaling_predefined_metric_type
  ecs_memory_scaling_scale_in_cooldown                  = var.ecs_memory_scaling_scale_in_cooldown
  ecs_memory_scaling_scale_out_cooldown                 = var.ecs_memory_scaling_scale_out_cooldown
  ecs_memory_scaling_target_value                       = var.ecs_memory_scaling_target_value
  region                                                = var.ecs_region
  ecs_service_assign_public_ip                          = var.ecs_service_assign_public_ip
  ecs_service_container_port                            = var.ecs_service_container_port
  ecs_service_deployment_controller_type                = var.ecs_service_deployment_controller_type
  ecs_service_desired_count                             = var.ecs_service_desired_count
  ecs_service_name                                      = var.ecs_service_name
  ecs_service_security_groups                           = var.ecs_service_security_groups
  ecs_service_subnets                                   = var.ecs_service_subnets
  ecs_service_tags                                      = var.ecs_service_tags
  ecs_sg_description                                    = var.ecs_sg_description
  ecs_sg_name                                           = var.ecs_sg_name
  ecs_target_cpu_tracking_name                          = var.ecs_target_cpu_tracking_name
  ecs_target_cpu_tracking_policy_type                   = var.ecs_target_cpu_tracking_policy_type
  ecs_target_cpu_tracking_resource_id                   = var.ecs_target_cpu_tracking_resource_id
  ecs_target_cpu_tracking_scalable_dimension            = var.ecs_target_cpu_tracking_scalable_dimension
  ecs_target_cpu_tracking_service_namespace             = var.ecs_target_cpu_tracking_service_namespace
  ecs_target_max_capacity                               = var.ecs_target_max_capacity
  ecs_target_memory_tracking_name                       = var.ecs_target_memory_tracking_name
  ecs_target_memory_tracking_policy_type                = var.ecs_target_memory_tracking_policy_type
  ecs_target_memory_tracking_resource_id                = var.ecs_target_memory_tracking_resource_id
  ecs_target_memory_tracking_scalable_dimension         = var.ecs_target_memory_tracking_scalable_dimension
  ecs_target_memory_tracking_service_namespace          = var.ecs_target_memory_tracking_service_namespace
  ecs_target_min_capacity                               = var.ecs_target_min_capacity
  ecs_target_resource_id                                = var.ecs_target_resource_id
  ecs_target_scalable_dimension                         = var.ecs_target_scalable_dimension
  ecs_target_service_namespace                          = var.ecs_target_service_namespace
  ecs_task_execution_policies_json                      = var.ecs_task_execution_policies_json
  ecs_task_execution_role_name                          = var.ecs_task_execution_role_name
  ecs_task_execution_role_policies                      = var.ecs_task_execution_role_policies
  ecs_task_execution_role_policies_des                  = var.ecs_task_execution_role_policies_des
  ecs_task_execution_role_tags                          = var.ecs_task_execution_role_tags
  ecs_task_role_execution_json                          = var.ecs_task_role_execution_json
  ecs_task_role_json                                    = var.ecs_task_role_json
  ecs_task_role_name                                    = var.ecs_task_role_name
  ecs_task_role_policies                                = var.ecs_task_role_policies
  ecs_task_role_policies_des                            = var.ecs_task_role_policies_des
  ecs_task_role_policies_json                           = var.ecs_task_role_policies_json
  ecs_task_role_tags                                    = var.ecs_task_role_tags
  enable_ecs_container_name                             = var.enable_ecs_container_name
  enable_ecs_container_port                             = var.enable_ecs_container_port
  enable_ecs_launch_type                                = var.enable_ecs_launch_type
  enable_ecs_managed_tags                               = var.enable_ecs_managed_tags
  endpoint_application_type                             = var.endpoint_application_type
  endpoint_dns_enabled                                  = var.endpoint_dns_enabled
  endpoint_environment                                  = var.endpoint_environment
  endpoint_name                                         = var.endpoint_name
  endpoint_project                                      = var.endpoint_project
  endpoint_security_group                               = var.endpoint_security_group
  endpoint_subnet_ids                                   = var.endpoint_subnet_ids
  endpoint_tag_specifications                           = var.endpoint_tag_specifications
  endpoint_tags                                         = var.endpoint_tags
  endpoint_type                                         = var.endpoint_type
  endpoint_vpc_id                                       = var.endpoint_vpc_id
  lb_listener_action_type                               = var.lb_listener_action_type
  lb_listener_certificate_arn                           = var.lb_listener_certificate_arn
  lb_listener_fixed_response_content_type               = var.lb_listener_fixed_response_content_type
  lb_listener_fixed_response_message_body               = var.lb_listener_fixed_response_message_body
  lb_listener_fixed_response_status_code                = var.lb_listener_fixed_response_status_code
  lb_listener_port                                      = var.lb_listener_port
  lb_listener_protocol                                  = var.lb_listener_protocol
  lb_listener_redirect_host                             = var.lb_listener_redirect_host
  lb_listener_redirect_path                             = var.lb_listener_redirect_path
  lb_listener_redirect_port                             = var.lb_listener_redirect_port
  lb_listener_redirect_protocol                         = var.lb_listener_redirect_protocol
  lb_listener_redirect_query                            = var.lb_listener_redirect_query
  lb_listener_redirect_status_code                      = var.lb_listener_redirect_status_code
  lb_listener_ssl_policy                                = var.lb_listener_ssl_policy
  net_lb_listener_action_type                           = var.net_lb_listener_action_type
  net_lb_listener_certificate_arn                       = var.net_lb_listener_certificate_arn
  net_lb_listener_fixed_response_content_type           = var.net_lb_listener_fixed_response_content_type
  net_lb_listener_fixed_response_message_body           = var.net_lb_listener_fixed_response_message_body
  net_lb_listener_fixed_response_status_code            = var.net_lb_listener_fixed_response_status_code
  net_lb_listener_port                                  = var.net_lb_listener_port
  net_lb_listener_protocol                              = var.net_lb_listener_protocol
  net_lb_listener_redirect_host                         = var.net_lb_listener_redirect_host
  net_lb_listener_redirect_path                         = var.net_lb_listener_redirect_path
  net_lb_listener_redirect_port                         = var.net_lb_listener_redirect_port
  net_lb_listener_redirect_protocol                     = var.net_lb_listener_redirect_protocol
  net_lb_listener_redirect_query                        = var.net_lb_listener_redirect_query
  net_lb_listener_redirect_status_code                  = var.net_lb_listener_redirect_status_code
  net_lb_listener_ssl_policy                            = var.net_lb_listener_ssl_policy
  net_tg_enable                                         = var.net_tg_enable
  net_tg_health_check_enabled                           = var.net_tg_health_check_enabled
  net_tg_health_check_interval                          = var.net_tg_health_check_interval
  net_tg_health_check_path                              = var.net_tg_health_check_path
  net_tg_health_check_port                              = var.net_tg_health_check_port
  net_tg_health_check_protocol                          = var.net_tg_health_check_protocol
  net_tg_health_check_timeout                           = var.net_tg_health_check_timeout
  net_tg_healthy_threshold                              = var.net_tg_healthy_threshold
  net_tg_matcher                                        = var.net_tg_matcher
  net_tg_name                                           = var.net_tg_name
  net_tg_port                                           = var.net_tg_port
  net_tg_protocol                                       = var.net_tg_protocol
  net_tg_tags                                           = var.net_tg_tags
  net_tg_target_type                                    = var.net_tg_target_type
  net_tg_unhealthy_threshold                            = var.net_tg_unhealthy_threshold
  net_tg_vpc_id                                         = var.net_tg_vpc_id
  nlb_enable_cross_zone_load_balancing                  = var.nlb_enable_cross_zone_load_balancing
  nlb_enable_deletion_protection                        = var.nlb_enable_deletion_protection
  nlb_enable_http2                                      = var.nlb_enable_http2
  nlb_idle_timeout                                      = var.nlb_idle_timeout
  nlb_internal                                          = var.nlb_internal
  nlb_ip_address_type                                   = var.nlb_ip_address_type
  nlb_load_balancer_type                                = var.nlb_load_balancer_type
  nlb_name                                              = var.nlb_name
  nlb_security_group                                    = var.nlb_security_group
  nlb_subnet_ids                                        = var.nlb_subnet_ids
  nlb_tags                                              = var.nlb_tags
  nlb_vpc_id                                            = var.nlb_vpc_id
  non_routable_vpc                                      = var.non_routable_vpc
  non_routable_vpc_security_group                       = var.non_routable_vpc_security_group
  non_routable_vpc_subnet_ids                           = var.non_routable_vpc_subnet_ids
  propagate_tags                                        = var.propagate_tags
  remotestate_bucket_name                               = var.remotestate_bucket_name
  routable_vpc                                          = var.routable_vpc
  routable_vpc_security_group                           = var.routable_vpc_security_group
  routable_vpc_subnet_ids                               = var.routable_vpc_subnet_ids
  route53_domain_name                                   = var.route53_domain_name
  route53_evaluate_target_health                        = var.route53_evaluate_target_health
  route53_record_type                                   = var.route53_record_type
  route53_tags                                          = var.route53_tags
  route53_vpc_id                                        = var.route53_vpc_id
  ser_tg_cookie_enabled                                 = var.ser_tg_cookie_enabled
  ser_tg_enable                                         = var.ser_tg_enable
  ser_tg_health_check_enabled                           = var.ser_tg_health_check_enabled
  ser_tg_health_check_interval                          = var.ser_tg_health_check_interval
  ser_tg_health_check_path                              = var.ser_tg_health_check_path
  ser_tg_health_check_port                              = var.ser_tg_health_check_port
  ser_tg_health_check_protocol                          = var.ser_tg_health_check_protocol
  ser_tg_health_check_timeout                           = var.ser_tg_health_check_timeout
  ser_tg_healthy_threshold                              = var.ser_tg_healthy_threshold
  ser_tg_matcher                                        = var.ser_tg_matcher
  ser_tg_name                                           = var.ser_tg_name
  ser_tg_port                                           = var.ser_tg_port
  ser_tg_protocol                                       = var.ser_tg_protocol
  ser_tg_stickiness_type                                = var.ser_tg_stickiness_type
  ser_tg_target_type                                    = var.ser_tg_target_type
  ser_tg_unhealthy_threshold                            = var.ser_tg_unhealthy_threshold
  ser_tg_vpc_id                                         = var.ser_tg_vpc_id
  sg_discription                                        = var.sg_discription
  sg_egress_cidr_blocks                                 = var.sg_egress_cidr_blocks
  sg_egress_from_port                                   = var.sg_egress_from_port
  sg_egress_protocol                                    = var.sg_egress_protocol
  sg_egress_to_port                                     = var.sg_egress_to_port
  sg_ingress_cidr_blocks                                = var.sg_ingress_cidr_blocks
  sg_ingress_from_port                                  = var.sg_ingress_from_port
  sg_ingress_protocol                                   = var.sg_ingress_protocol
  sg_ingress_to_port                                    = var.sg_ingress_to_port
  sg_name                                               = var.sg_name
  sg_tags                                               = var.sg_tags
  state_file                                            = var.state_file
  state_file_sg                                         = var.state_file_sg
  td_container_definitions                              = var.td_container_definitions
  td_cpu                                                = var.td_cpu
  td_execution_role_arn                                 = var.td_execution_role_arn
  td_execution_role_name                                = var.td_execution_role_name
  td_family                                             = var.td_family
  td_fileName                                           = var.td_fileName
  td_memory                                             = var.td_memory
  td_network_mode                                       = var.td_network_mode
  td_requires_compatibilities                           = var.td_requires_compatibilities
  td_tags                                               = var.td_tags
  td_task_role_arn                                      = var.td_task_role_arn
  terraform_region                                      = var.terraform_region
  ui_tg_cookie_enabled                                  = var.ui_tg_cookie_enabled
  ui_tg_enable                                          = var.ui_tg_enable
  ui_tg_health_check_enabled                            = var.ui_tg_health_check_enabled
  ui_tg_health_check_interval                           = var.ui_tg_health_check_interval
  ui_tg_health_check_path                               = var.ui_tg_health_check_path
  ui_tg_health_check_port                               = var.ui_tg_health_check_port
  ui_tg_health_check_protocol                           = var.ui_tg_health_check_protocol
  ui_tg_health_check_timeout                            = var.ui_tg_health_check_timeout
  ui_tg_healthy_threshold                               = var.ui_tg_healthy_threshold
  ui_tg_matcher                                         = var.ui_tg_matcher
  ui_tg_name                                            = var.ui_tg_name
  ui_tg_port                                            = var.ui_tg_port
  ui_tg_protocol                                        = var.ui_tg_protocol
  ui_tg_stickiness_type                                 = var.ui_tg_stickiness_type
  ui_tg_tags                                            = var.ui_tg_tags
  ui_tg_target_type                                     = var.ui_tg_target_type
  ui_tg_unhealthy_threshold                             = var.ui_tg_unhealthy_threshold
  ui_tg_vpc_id                                          = var.ui_tg_vpc_id
  vpc_endpoint_service_name                             = var.vpc_endpoint_service_name
  vpc_endpoint_type                                     = var.vpc_endpoint_type
  vpce_acceptance_required                              = var.vpce_acceptance_required
  vpce_tags                                             = var.vpce_tags
}