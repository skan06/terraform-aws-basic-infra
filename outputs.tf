output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_instance.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.mydb.endpoint
}


output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "bastion_ip" {
  description = "Public IP of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}
