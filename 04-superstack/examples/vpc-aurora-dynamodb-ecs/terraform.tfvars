# General

region = "eu-west-1"

# Label

namespace = "eg"

stage = "test"

app_name = "vpc-aurora-example"

# VPC

availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

vpc_cidr = "10.0.0.0/16"

public_subnets = []

private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

enable_dns_hostnames = true

enable_dns_support = true

# Aurora

create_aurora = true

cluster_name = "aurora-cluster-1"

instance_type = "db.t3.small"

cluster_family = "aurora5.6"

cluster_size = 1

deletion_protection = false

aurora_autoscaling_enabled = false

engine = "aurora"

engine_mode = "provisioned"

engine_version = "11.9"

database_name = "test_db"

admin_user = "master"

vpc_tags = {
  type        = "internal"
  Terraform   = "true"
  Environment = "staging"
}

cluster_parameters = [
  {
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "pending-reboot"
  },
  {
    name         = "character_set_connection"
    value        = "utf8"
    apply_method = "pending-reboot"
  },
  {
    name         = "character_set_database"
    value        = "utf8"
    apply_method = "pending-reboot"
  },
  {
    name         = "character_set_results"
    value        = "utf8"
    apply_method = "pending-reboot"
  },
  {
    name         = "character_set_server"
    value        = "utf8"
    apply_method = "pending-reboot"
  },
  {
    name         = "collation_connection"
    value        = "utf8_bin"
    apply_method = "pending-reboot"
  },
  {
    name         = "collation_server"
    value        = "utf8_bin"
    apply_method = "pending-reboot"
  },
  {
    name         = "lower_case_table_names"
    value        = "1"
    apply_method = "pending-reboot"
  },
  {
    name         = "skip-character-set-client-handshake"
    value        = "1"
    apply_method = "pending-reboot"
  }
]

# DynamoDB

create_dynamodb_table = true

table_name     = "my-table"
hash_key       = "id"
range_key      = "title"
billing_mode   = "PROVISIONED"
read_capacity  = 5
write_capacity = 5

autoscaling_read = {
  scale_in_cooldown  = 50
  scale_out_cooldown = 40
  target_value       = 45
  max_capacity       = 10
}

autoscaling_write = {
  scale_in_cooldown  = 50
  scale_out_cooldown = 40
  target_value       = 45
  max_capacity       = 10
}

autoscaling_indexes = {
  TitleIndex = {
    read_max_capacity  = 30
    read_min_capacity  = 10
    write_max_capacity = 30
    write_min_capacity = 10
  }
}

dynamodb_table_attributes = [
  {
    name = "id"
    type = "N"
  },
  {
    name = "title"
    type = "S"
  },
  {
    name = "age"
    type = "N"
  }
]

global_secondary_indexes = [
  {
    name               = "TitleIndex"
    hash_key           = "title"
    range_key          = "age"
    projection_type    = "INCLUDE"
    non_key_attributes = ["id"]
    write_capacity     = 10
    read_capacity      = 10
  }
]

table_tags = {
  Terraform   = "true"
  Environment = "staging"
}

# ECS

create_ecs = true

ecs_region = "eu-west-1"

##########################################################
# Security Group for ECS Service
#########################################################
sg_name        = "xxxxxx non routable security group"
sg_discription = "Security Group for PROJ UI"
sg_tags = {
  "Name"        = "SG-PROJ-CLUSTER-UI-DEV"
  "project"     = "REGION-PROJ"
  "environment" = "DEV"
}
sg_ingress_from_port   = -1
sg_ingress_to_port     = -1
sg_ingress_protocol    = "all"
sg_ingress_cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
sg_egress_from_port    = -1
sg_egress_to_port      = -1
sg_egress_protocol     = "all"
sg_egress_cidr_blocks  = ["0.0.0.0/0"]
##########################################################
# Roles
#########################################################
ecs_task_role_name                   = "ECSTaskRole_ECSPRJ_DEV"
ecs_task_execution_role_name         = "ECSTaskExecutionRole_ECSPRJ_DEV"
ecs_task_role_policies               = "ECSTaskRolePolicy_ECSPRJ_DEV"
ecs_task_role_policies_des           = "This is Policies for ECS Task Role"
ecs_task_execution_role_policies     = "ECSTaskExecutionRolePolicy_ECSPRJ_DEV"
ecs_task_execution_role_policies_des = "This is Policies for ECS Task execution Role"
ecs_task_role_json                   = "./../../../examples/vpc-aurora-dynamodb-ecs/templates/taskRole.json"
ecs_task_role_execution_json         = "./../../../examples/vpc-aurora-dynamodb-ecs/templates/taskRoleExecution.json"
ecs_task_role_policies_json          = "./../../../examples/vpc-aurora-dynamodb-ecs/templates/taskRolePolicies.json"
ecs_task_execution_policies_json     = "./../../../examples/vpc-aurora-dynamodb-ecs/templates/taskRoleExecutionPolicies.json"
ecs_task_role_tags = {
  "Name"        = "ECSTaskRole_MWSBASE_UI_DEV"
  "project"     = "REGION-PROJ"
  "environment" = "DEV"
}
ecs_task_execution_role_tags = {
  "Name"        = "ECSTaskExecutionRole_MWSBASE_UI_DEV"
  "project"     = "REGION-PROJ"
  "environment" = "DEV"
}
##########################################################
# ECS Cluster configuration parameters
##########################################################
ecs_cluster_name          = "ECS-PROJ-UI-CLUSTER-DEV"
cluster_capacity_provider = ["FARGATE"]
cluster_tags = {
  "Name"        = "ECS-PROJ-UI-CLUSTER-DEV"
  "project"     = "REGION-PROJ"
  "environment" = "DEV"
}
#############################################################
# Task Details configuration parameters
#############################################################
td_family       = "TD-PROJ-UI-DEV"
td_fileName     = "/env_vars/dev/ui_task_details.json"
td_network_mode = "awsvpc"
td_cpu          = 2048
td_memory       = 4096
td_tags = {
  "Name"        = "TD-PROJ-UI-DEV"
  "project"     = "REGION-PROJ"
  "environment" = "DEV"
}
####################################################################
##
## ECS Service 
####################################################################
ecs_service_name                       = "SD-PROJ-DEV"
ecs_service_deployment_controller_type = "ECS"
ecs_service_desired_count              = "1"
enable_ecs_launch_type                 = "FARGATE"
enable_ecs_container_name              = "PROJ"
enable_ecs_container_port              = "80"
ecs_service_assign_public_ip           = false

###############################################################
##
# Scaling
###############################################################
ecs_target_max_capacity                       = 5
ecs_target_min_capacity                       = 1
ecs_target_resource_id                        = "service/ECS-PROJ-CLUSTER-DEV/SD-PROJ-DEV"
ecs_target_scalable_dimension                 = "ecs:service:DesiredCount"
ecs_target_service_namespace                  = "ecs"
ecs_target_cpu_tracking_name                  = "CPU-Utilisation"
ecs_target_cpu_tracking_policy_type           = "TargetTrackingScaling"
ecs_target_cpu_tracking_resource_id           = "service/ECS-PROJ-CLUSTER-DEV/SD-PROJ-DEV"
ecs_target_cpu_tracking_scalable_dimension    = "ecs:service:DesiredCount"
ecs_target_cpu_tracking_service_namespace     = "ecs"
ecs_cpu_scaling_predefined_metric_type        = "ECSServiceAverageCPUUtilization"
ecs_cpu_scaling_target_value                  = 50
ecs_cpu_scaling_scale_in_cooldown             = 300
ecs_cpu_scaling_scale_out_cooldown            = 300
ecs_target_memory_tracking_name               = "Memory-Utilisation"
ecs_target_memory_tracking_policy_type        = "TargetTrackingScaling"
ecs_target_memory_tracking_resource_id        = "service/ECS-PROJ-CLUSTER-DEV/SD-PROJ-DEV"
ecs_target_memory_tracking_scalable_dimension = "ecs:service:DesiredCount"
ecs_target_memory_tracking_service_namespace  = "ecs"
ecs_memory_scaling_predefined_metric_type     = "ECSServiceAverageMemoryUtilization"
ecs_memory_scaling_target_value               = 60
ecs_memory_scaling_scale_in_cooldown          = 300
ecs_memory_scaling_scale_out_cooldown         = 300
####################################################################
##
#ALB details
####################################################################
alb_name                             = "ECS-DEV-ALB"
alb_internal                         = true
alb_load_balancer_type               = "application"
alb_idle_timeout                     = 60
alb_enable_deletion_protection       = false
alb_enable_cross_zone_load_balancing = false
alb_enable_http2                     = true
alb_ip_address_type                  = "ipv4"
alb_tags = {
  "Name"        = "ECS-DEV-ALB"
  "project"     = "REGION"
  "environment" = "DEV"
}
####################################################################
##
#ALB targert group for UI
####################################################################
ui_tg_enable                = 1
ui_tg_name                  = "ECS-PROJ-DEV-TG"
ui_tg_port                  = "80"
ui_tg_protocol              = "HTTP"
ui_tg_health_check_enabled  = true
ui_tg_health_check_interval = 30
ui_tg_health_check_path     = "/status"
ui_tg_health_check_port     = 80
ui_tg_health_check_protocol = "HTTP"
ui_tg_health_check_timeout  = 5
ui_tg_healthy_threshold     = 3
ui_tg_unhealthy_threshold   = 3
ui_tg_matcher               = 200
ui_tg_target_type           = "ip"
ui_tg_stickiness_type       = "lb_cookie"
ui_tg_cookie_enabled        = false
ui_tg_tags = {
  "Name"        = "ECS-PROJ-DEV-TG"
  "project"     = "REGION"
  "environment" = "DEV"
}
####################################################################
##
#ALB Listener 
####################################################################
lb_listener_action_type                 = "forward"
lb_listener_port                        = 80
lb_listener_protocol                    = "HTTP"
lb_listener_ssl_policy                  = ""
lb_listener_certificate_arn             = ""
lb_listener_redirect_host               = ""
lb_listener_redirect_path               = ""
lb_listener_redirect_port               = ""
lb_listener_redirect_protocol           = ""
lb_listener_redirect_query              = ""
lb_listener_redirect_status_code        = "HTTP_301"
lb_listener_fixed_response_content_type = "application/json"
lb_listener_fixed_response_message_body = ""
lb_listener_fixed_response_status_code  = ""

#######################################################################
## NLB load Balancer
#######################################################################
nlb_name                             = "ECS-DEV-NLB"
nlb_internal                         = true
nlb_load_balancer_type               = "network"
nlb_idle_timeout                     = 60
nlb_enable_deletion_protection       = false
nlb_enable_cross_zone_load_balancing = false
nlb_enable_http2                     = true
nlb_ip_address_type                  = "ipv4"
nlb_tags = {
  "Name"        = "ECS-DEV-NLB"
  "project"     = "REGION"
  "environment" = "DEV"
}
################################################################################
### NLB TG
################################################################################
net_tg_enable                = 0
net_tg_name                  = "ECS-DEV-NLB-TG"
net_tg_port                  = 80
net_tg_protocol              = "TCP"
net_tg_health_check_enabled  = true
net_tg_health_check_interval = 30
net_tg_health_check_path     = "/"
net_tg_health_check_port     = 80
net_tg_health_check_protocol = "TCP"
net_tg_health_check_timeout  = 5
net_tg_healthy_threshold     = 3
net_tg_unhealthy_threshold   = 3
net_tg_matcher               = 200
net_tg_target_type           = "ip"
net_tg_tags = {
  "Name"        = "ECS-DEV-NLB-TG"
  "project"     = "REGION"
  "environment" = "DEV"
}
####################################################################
##
#NLB Listener 
####################################################################
net_lb_listener_action_type                 = "forward"
net_lb_listener_port                        = 80
net_lb_listener_protocol                    = "TCP"
net_lb_listener_ssl_policy                  = ""
net_lb_listener_certificate_arn             = ""
net_lb_listener_redirect_host               = ""
net_lb_listener_redirect_path               = ""
net_lb_listener_redirect_port               = ""
net_lb_listener_redirect_protocol           = ""
net_lb_listener_redirect_query              = ""
net_lb_listener_redirect_status_code        = "HTTP_301"
net_lb_listener_fixed_response_content_type = "application/json"
net_lb_listener_fixed_response_message_body = ""
net_lb_listener_fixed_response_status_code  = ""
################################################################################
# VPC endpoint service configuration parameters
################################################################################
vpce_acceptance_required = false
vpce_tags = {
  "Name"        = "SERVICE-ENDPOINT-ECS-DEV-NLB"
  "project"     = "REGION"
  "environment" = "DEV"
}
vpc_endpoint_type = "Interface"
####################################################################
##
#EndPoint 
####################################################################
endpoint_dns_enabled = false
endpoint_type        = "Interface"
endpoint_tags = {
  "Name"        = "ENDPOINT-ECS-DEV"
  "project"     = "REGION"
  "environment" = "DEV"
}
###############################################################
##
# Route 53
###############################################################
route53_domain_name = "xxxxxxxxx"
route53_record_type = "A"
route53_tags = {
  "Name"        = "xxxxxxxxxxx"
  "project"     = "REGION"
  "environment" = "dev"
}

###############################################################
##
# CloudWatch logging and alerting
###############################################################

# Cloudwatch log group name should be same as the one mentione din ui_task_definition
cloudwatch_lg = "awslogs-base-logs"

ecs_alarms_enabled = true
