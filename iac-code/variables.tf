##################################################################################
# VARIABLES
##################################################################################

variable "region" {
  type        = string
  description = "(Optional) AWS Region to use. Default: us-east-1"
  default     = "eu-central-1"
}

variable "prefix" {
  type        = string
  description = "(Optional) Prefix to use for all resources in this module. Default: globo-dev"
  default     = "minecraft"
}

variable "environment" {
  type        = string
  description = "Working environment"
  default     = "dev"
}

variable "cidr_block" {
  type        = string
  description = "(Optional) The CIDR block for the VPC. Default:10.42.0.0/16"
  default     = "10.42.0.0/16"
}

variable "public_subnet" {
  type        = string
  description = "public subnet"
  default     = "10.42.10.0/24"
}

variable "ip_range" {
  default = "0.0.0.0/0"
}

variable "playbook_url" {
  type        = string
  description = "Github content URL for Ansible Playbook"
  default     = "https://raw.githubusercontent.com/aaosopra/django-course/main/ansible/playbooks/server_config.yaml"
}

variable "home_path" {
  type        = string
  description = "Local users home path"
  default     = "/home/aao"
}