# This is the main configuration file. You can deploy your Serverpod by only
# doing changes to this file. However, by default, the configuration uses
# the lowest tier for the database and Redis setup. You will want to edit the
# database.tf and redis.tf files if you need higher performance.


# The name of your project. Used to configure names of resources. In most
# instances you want to set this to the same as your Serverpod project name, but
# avoid any underscores.
# NOTE: the project name cannot use underscore, spaces, or any special
# characters.
project_name = "pullventure"

# The region where to deploy the server. If you change the region you will also
# need to update the instance_ami variable (see below) and update the region in
# the .github/workflows/deployment-aws.yml file. In some cases you will also
# need to update your instance_type.
aws_region = "us-west-2"

# Enabling Redis may incur additional costs. You will also need to enable Redis
# in your staging.yaml and production.yaml configuration files.
enable_redis = false

# Domain and certificates used by this Serverpod. You will need to have created
# a public hosted zone in Route 53 and retrieved its id. You will also need to
# manually create a certificate in AWS's Certificate Manager. The certificate
# should cover the top domain and any subdomains. E.g. add example.com and
# *.example.com to your certificate. You will need to create one certificate
# for your main region and one for use with Cloudfront that resides in the
# us-east-1 region.
hosted_zone_id             = "Z06969532HT4OM0LTT53T"
top_domain                 = "pullventure.live"
certificate_arn            = "arn:aws:acm:us-west-2:639240623034:certificate/0a90232a-1d1f-42f2-953c-af57cd7d0078"
cloudfront_certificate_arn = "arn:aws:acm:us-east-1:639240623034:certificate/7117fc13-1e74-4f1e-baf4-b583fe92829a"

# Subdomains for different services. Default values are recommended, but you
# may want to change the subdomain_web to www if you are using the top domain
# for the web server.
subdomain_database = "database"
subdomain_redis    = "redis"
subdomain_api      = "api"
subdomain_insights = "insights"
subdomain_web      = "app"
subdomain_storage  = "storage"

subdomain_database_staging = "database-staging"
subdomain_redis_staging    = "redis-staging"
subdomain_api_staging      = "api-staging"
subdomain_insights_staging = "insights-staging"
subdomain_web_staging      = "app-staging"
subdomain_storage_staging  = "storage-staging"

# Set to true if you want to use the top domain for the web server.
use_top_domain_for_web = false

# The definition of the server instances to deploy. Note that if you change the
# region, you will have to change the AMI as they are bound to specific regions.
# Serverpod is tested with Amazon Linux 2 Kernel 5.x (You can find the AMI ids
# for a specifc region under EC2 > AMI Catalog in your AWS console.)
# Note: For some regions the t2.micro is not available. If so, consult the AWS
# documentation to find another instance type that suits your needs.
instance_type                = "t2.micro"
instance_ami                 = "ami-0ca285d4c2cda3300"
autoscaling_min_size         = 1
autoscaling_max_size         = 1
autoscaling_desired_capacity = 1


# Setup an additional server cluster and associated load balancers for staging.
# By default, the staging server uses the same database and Redis setup as the
# production server. If you want to change this behavior you will need add
# and edit the Terraform files.
# Note: By turning this feature on, the server setup will no longer fit within
# the AWS free tier as it will use multiple server instances and load balancers.
enable_staging_server = false

staging_instance_type                = "t2.micro"
staging_autoscaling_min_size         = 1
staging_autoscaling_max_size         = 1
staging_autoscaling_desired_capacity = 1

# The deployment bucket name needs to be unique and can only contain lower case
# letters and dashes (no underscored allowed).
deployment_bucket_name              = "pullventure-deployment-4206335"
public_storage_bucket_name          = "pullventure-public-storage-4206335"
private_storage_bucket_name         = "pullventure-private-storage-4206335"
public_storage_bucket_name_staging  = "pullventure-public-storage-staging-4206335"
private_storage_bucket_name_staging = "pullventure-private-storage-staging-4206335"
