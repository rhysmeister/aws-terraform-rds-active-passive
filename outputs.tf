output rds_instance_endpoint {
    description = "Endpoint of the active RDS Instance"
    value       = local.primary == "rds1" ? aws_db_instance.rds1.0.endpoint : aws_db_instance.rds2.0.endpoint
}

output rds_instance_username {
    description = "RDS Instance admin username"
    value       = local.username
}

output rds_instance_password {
    description = "RDS Instance admin password"
    value       = local.password
    sensitive   = true
}