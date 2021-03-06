###############################################################################
# AWS
###############################################################################

alias ec2pubips="aws ec2 describe-instances --query 'Reservations[*].Instances[*].{A_PUB:PublicIpAddress, B_PRIV:NetworkInterfaces[0].PrivateDnsName}' --output text"

# AWS Credentials as ENV VARs
function read_aws_credentials_key {
  FILE=~/.aws/credentials
  if [ -f $FILE ]; then
    section=$1
    key=$2
    awk -F ' *= *' '{ if ($1 ~ /^\[/) section=$1; else if ($1 !~ /^$/) print $1 section "=" $2 }' $FILE | grep "$2\[$1\]" | sed 's/.*=//'
  fi
}

export AWS_ACCESS_KEY_ID=$(read_aws_credentials_key default aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(read_aws_credentials_key default aws_secret_access_key)
# export AWS_DEFAULT_REGION=$(read_aws_credentials_key default region)

# export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
# export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
# export TF_VAR_AWS_REGION=$AWS_DEFAULT_REGION
