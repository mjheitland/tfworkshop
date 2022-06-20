resource "aws_cloudwatch_log_group" "tfw_loggroup" {
  name = "my_loggroup.${terraform.workspace}"

  tags = {
    Environment = terraform.workspace
    Application = "tfworkshop"
  }
}

output "log_group_id" {
  value = aws_cloudwatch_log_group.tfw_loggroup.id
}