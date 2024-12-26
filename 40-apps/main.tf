module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = local.ami_id
  name = "${var.project_name}-${var.environment}-mysql"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_id 
  tags = merge (
    var.common_tags,
    var.mysql_tags,
    {
        Name = "${var.project_name}-${var.environment}-mysql"
    }
  )
    }
  

module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = local.ami_id
  name = "${var.project_name}-${var.environment}-backend"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id #
  tags = merge (
    var.common_tags,
    var.backend_tags,
    {
        Name = "${var.project_name}-${var.environment}-backend"
    }
  )
}

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = local.ami_id
  name = "${var.project_name}-${var.environment}-frontend"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_id #
  tags = merge (
    var.common_tags,
    var.frontend_tags,
    {
        Name = "${var.project_name}-${var.environment}-frontend"
    }
  )
}

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = local.ami_id
  name = "${var.project_name}-${var.environment}-ansible"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.ansible_sg_id]
  subnet_id              = local.public_subnet_id 
  user_data = file("expense.sh")
  tags = merge (
    var.common_tags,
    var.ansible_tags,
    {
        Name = "${var.project_name}-${var.environment}-ansible"
    }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql.private_ip
        ]
    },
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend.private_ip
        ]
    },
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.private_ip
        ]
    },
    {
      name    = "expense"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.public_ip
        ]
    }
  ]
}