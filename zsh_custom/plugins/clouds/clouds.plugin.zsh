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
export AWS_DEFAULT_REGION=$(read_aws_credentials_key default region)

export TF_VAR_aws_access_key_id=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_aws_region=$AWS_DEFAULT_REGION

###############################################################################
# Google Cloud
###############################################################################
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
# next line is slow
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
