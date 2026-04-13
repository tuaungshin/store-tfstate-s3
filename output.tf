
output "public_instance_id" {
  value = aws_instance.ec2_node.id
}

output "private_instance_id" {
  value = aws_instance.ec2_private.id
}