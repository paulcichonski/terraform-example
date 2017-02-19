# terraform-example

Companion code for this blog post: TODO: LINK

This repo produces a Docker image called `paulcichonski/my-cool-infra` that will
stand up a super simplistic infrastructure in AWS that contains:

- a dedicated VPC with 1 public subnet
- a simple web server host running in the public subnet
- hardcoded to deploy into us-west-2

**Warning: this builds aws infrastructure, author is not responsible for AWS
**charges incurred**

## Guide for Consumers

First make sure you have the following environment variables exported:

* AWS_ACCESS_KEY_ID -> Your aws access key
* AWS_SECRET_ACCESS_KEY -> Your aws secret key
* REMOTE_BACKEND_S3_BUCKET -> a versioned s3 bucket in us-west-2. This will hold
your Terraform state file.
* REMOTE_BACKEND_S3_KEY -> s3 key to use for Terraform state file name.
* TF_VAR_infra_name -> unique name of your infra, recommend using `$USER`

Now make sure you have a terraform [variables
file](https://www.terraform.io/intro/getting-started/variables.html) for your
environment (alternatively you could use environment variables for everything):

Here is a sample of what the variables file should hold:

```
$ cat $(pwd)/terraform.tfvars

vpc_cidr = "10.50.0.0/16"
public_subnet_a_cidr = "10.50.1.0/24"

## this keypair needs to exist in your aws account
server_key_name = "example-terraform"
```

Now run the docker image:

```
docker pull paulcichonski/my-cool-infra
docker run -e AWS_ACCESS_KEY_ID \
           -e AWS_SECRET_ACCESS_KEY \
           -e REMOTE_BACKEND_S3_BUCKET \
           -e REMOTE_BACKEND_S3_KEY \
           -e TF_VAR_infra_name \
           -e AWS_REGION=us-west-2 \
           -v $(pwd)/terraform.tfvars:/opt/vars/env.tfvars \
           paulcichonski/my-cool-infra <terraform-command>
```

## Guide for Developers

### Pre-requisites

* [Elsy](https://github.com/cisco/elsy)

### How to Run

The `docker-compose.yml` provides some shortcuts for running common commands:

```
## plan infra
lc dc run plan

## apply infra
lc dc run apply

## graph infra
lc dc run graph

## show infra
lc dc runs show

## print outputs
lc dc run output

## destroy infra
lc dc run destroy
```

### How to Test

The [elsy blackbox-test
lifecycle](https://github.com/cisco/elsy#lc-blackbox-test) will perform the
following:

1. Standup a new version of the infrastructure
1. Run Gherkin tests found in `./blackbox-test/features` on the infrastructure to
verify it is working
1. Teardown the infrastructure
