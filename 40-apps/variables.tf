variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "Expense"
        Environment = "dev"
        Terraform = true
    }
}

variable "ansible_tags" {
    default = {
        Component = "ansible"
    }
}


variable "mysql_tags" {
    default = {
        Component = "mysql"
    }
}

variable "zone_name" {
    default = "yashd.icu"
}

variable "backend_tags" {
    default = {
        Component = "backend"
    }
}

variable "frontend_tags" {
    default = {
        Component = "frontend"
    }
}