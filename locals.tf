locals {
  instance_type =   "t3.micro"
  common_name_suffix ="${var.project_name}-${var.environment}"
  vpc_id =  data.aws_ssm_parameter.vpc_id.value
  ami_id    =   data.aws_ami.devops_practice.id
  private_subnet_id = split("," , data.aws_ssm_parameter.private_subnet_id.value)[0]
  private_subnet_ids = split("," , data.aws_ssm_parameter.private_subnet_id.value)
  
  backend_alb_listener_arn =data.aws_ssm_parameter.backend_alb_listener_arn.value
  frontend_alb_listener_arn =data.aws_ssm_parameter.frontend_alb_listener_arn.value
  listener_arn = "${var.component}" == "frontend" ? local.frontend_alb_listener_arn : local.backend_alb_listener_arn

  health_check_path = "${var.component}" == "frontend" ? "/" : "/health" 
  tg_port  =  "${var.component}" == "frontend" ? 80 : 8080
  sg_id =   data.aws_ssm_parameter.sg_id.value

  host_context = "${var.component}" == "frontend" ? "${var.project_name}-${var.environment}.${var.domain_name}" : "${var.component}.backend-alb-${var.environment}.${var.domain_name}"

  common_tags = {
        Project = var.project_name
        Environment = var.environment
        Terraform = "true"
    } 
}