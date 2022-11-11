locals {
    primary             = "rds2"

    allocated_storage        = 10
    engine                   = "mariadb"
    engine_version           = "10.6"
    instance_class           = "db.t3.micro"
    skip_final_snapshot      = true
    delete_automated_backups = false
    backup_window            = "00:00-23:00"
    backup_retention_period  = 35

    username = "admin"
    password = "TopSecret915!"           
    
    snapshot_identifier = "arn:aws:rds:eu-central-1:824543128771:snapshot:rds:rds1-2022-11-11-11-03"
}

resource "aws_db_instance" "rds1" {
    count = local.primary == "rds1" ? 1 : 0

    identifier               = "rds1"
    allocated_storage        = local.allocated_storage
    engine                   = local.engine
    engine_version           = local.engine_version
    instance_class           = local.instance_class
    username                 = local.username
    password                 = local.password
    skip_final_snapshot      = local.skip_final_snapshot
    delete_automated_backups = local.delete_automated_backups
    backup_window            = local.backup_window
    backup_retention_period  = local.backup_retention_period

    snapshot_identifier      = local.snapshot_identifier
}

resource "aws_db_instance" "rds2" {
    count = local.primary == "rds2" ? 1 : 0

    identifier               = "rds2"
    allocated_storage        = local.allocated_storage
    engine                   = local.engine
    engine_version           = local.engine_version
    instance_class           = local.instance_class
    username                 = local.username
    password                 = local.password
    skip_final_snapshot      = local.skip_final_snapshot
    delete_automated_backups = local.delete_automated_backups
    backup_window            = local.backup_window
    backup_retention_period  = local.backup_retention_period

    snapshot_identifier      = local.snapshot_identifier
}

resource "aws_ssm_parameter" "endpoint" {
    name        = "/test/rds/endpoint"
    description = "Endpoint of the active RDS Instance"
    type        = "String"
    value       = local.primary == "rds1" ? aws_db_instance.rds1.0.endpoint : aws_db_instance.rds2.0.endpoint
}

resource "aws_ssm_parameter" "admin_username" {
    name        = "/test/rds/username"
    description = "Username of RDS Instance"
    type        = "String"
    value       = local.username
}

resource "aws_ssm_parameter" "admin_password" {
    name        = "/test/rds/password"
    description = "Username of RDS Instance"
    type        = "SecureString"
    value       = local.password
}