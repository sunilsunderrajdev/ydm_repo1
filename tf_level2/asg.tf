module "asg" {
    source = "../modules/asg"

    env_code            = var.env_code
    ec2_instance_type   = var.ec2_instance_type
    private_subnet_id   = data.terraform_remote_state.level1.outputs.private_subnet_id
    vpc_id              = data.terraform_remote_state.level1.outputs.vpc_id
    load_balancer_sg    = module.lb.load_balancer_sg
    target_group_arn    = module.lb.target_group_arn
}
