resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    delete_on_termination = var.delete_on_termination
    encrypted             = var.encrypt_root_volume
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    kms_key_id            = var.encrypt_root_volume ? var.kms_key_arn : null
    iops                  = var.volume_type == "io1" || var.volume_type == "io2" || var.volume_type == "gp3" ? var.iops : null
    throughput            = var.volume_type == "gp3" ? var.throughput : null
  }
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  key_name               = var.key_pair_name

  tags                   = var.ec2_tags
}