module "ssh_keys" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~>2.0.0"

  key_name           = "${var.prefix}-tdd-keys"
  create_private_key = true
}

resource "local_file" "private_key" {
  content         = nonsensitive(module.ssh_keys.private_key_pem)
  filename        = "private_key.pem"
  file_permission = 0400
}

