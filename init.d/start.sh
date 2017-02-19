#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

command="$1"
shift

if [ -z "$command" ]; then
  echo "ERROR: no command specified" >&2
  print_usage
  exit 2
fi

var_file="/opt/vars/env.tfvars"

if [ -z "$REMOTE_BACKEND_S3_BUCKET" -o -z "$REMOTE_BACKEND_S3_KEY" ]; then
  echo "ERROR: the environment variables REMOTE_BACKEND_S3_BUCKET and REMOTE_BACKEND_S3_KEY are required." >&2
  exit 1
fi

# set working directory to ephemeral location in container. This avoids any
# possibility of preserving state files that may get generated
mkdir -p /var/run/terraform
cd /var/run/terraform

## Configure remote state location for terraform
terraform remote config \
  -backend=s3 \
  -backend-config="bucket=$REMOTE_BACKEND_S3_BUCKET" \
  -backend-config="key=$REMOTE_BACKEND_S3_KEY" \
  -backend-config="region=$AWS_REGION" > /dev/null

configs="/opt/terraform/aws"

# ensure AWS_REGION is used as terraform var
export TF_VAR_aws_region="${AWS_REGION}"
terraform get --update "$configs" > /dev/null
case $command in
    "apply")
      terraform apply -var-file="$var_file" "$@" "$configs"
      ;;
    "graph")
      terraform graph -draw-cycles "$configs"
      ;;
    "plan")
      terraform plan -var-file="$var_file" "$@" "$configs"
      ;;
    "refresh")
      terraform refresh -var-file="$var_file" "$@" "$configs"
      ;;
    "destroy")
      terraform destroy -var-file="$var_file" -force "$@" "$configs"
      ;;
    "verify-cluster")
      exec $DIR/verify-cluster.rb
      ;;
    *)
      terraform $command "$@"
  esac
