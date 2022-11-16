This is a simple test module to model an active-passive setup of 2 RDS Instances. The passive is not actually created until it is required. We restore from either automated or manual snapshhots. When failing over from rds1 to rds2 we remove the rds1 instance from the terraform state. We do this to preserve the availability of that instance in case it is needed afterward for some reason, i.e. further data recovery/analysis. Several SSM Parameters are created where application can pickup the new endpoint for the RDS Instance. Secrets are harded coded into the Terraform code and will be placed into the state. For anything serious this should be fixed.

# Initial deployment

The variable primary is expected to be "rds1" and snapshot_identifier is null for an initial deployment.

```bash
terraform apply;
```

Deploy your Databases as appropriate for your environment.

After take a manual snapshot or wait for an automated backup to complete.

# Restore to rds2

Ensure you have a snapshot from rds1 that we can use to restore from. You can also manually shutdown the rds1 instance in the console. Set the primary variable to rds2 and snapshot_identifier as the snapshot arn.

First remove the state for the rds1 instance. This can be manually deleted later...

```bash
terraform state rm aws_db_instance.rds1;
```

During a real DR occurance you may also want to shut this instance down to prevent applications connecting to it.

Then we can run terraform apply to restore the snapshot to rds2...

```bash
terraform apply
```

# SSM Parameters

The following SSM Parameters are created by this module. Then intention here is to provide a method where applications can pick up the new RDS Instance Endpoint.

* /test/rds/endpoint - The endpoint of the RDS Instance.
* /test/rds/username - The admin username of the RDS Instance.
* /test/rds/password - The admin password of the RDS Instance.

# RDS Instance Password

Please note that the RDS Instance Password is contained within the code and it will be stored in state. Look at [Sensitive Data in State](https://developer.hashicorp.com/terraform/language/state/sensitive-data) for more information and be sure to secure this value for any non-trivial usage.

# Clean Up

To clean everything up perform the following...

* terraform destroy - This will destroy the current rds instance (rds2 if followed above) and the SSM parameters.
* From the RDS Console delete "rds1".
* Check the "Automated backups" and "Snapshots" sections and remove any unwanted backups.
