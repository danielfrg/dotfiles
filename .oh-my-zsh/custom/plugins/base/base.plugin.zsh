# Color scheme
BASE16_SHELL="$HOME/workspace/dotfiles/iterm2/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export PATH=/usr/local/sbin:$PATH

# Slow
# export PATH=$(brew --prefix coreutils)/libexec/bin:$PATH
# export PATH=$(brew --prefix moreutils)/libexec/bin:$PATH
# Fast
export PATH=/usr/local/opt/coreutils/libexec/bin:$PATH
export PATH=/usr/local/opt/moreutils/libexec/bin:$PATH

bindkey '[C' forward-word
bindkey '[D' backward-word
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word

# GCP
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
# Slow
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# NPM
export PATH=~/workspace/node_modules/.bin:$PATH

# AWS Credentials as ENV VARs
function read_aws_credentials_key {
  section=$1
  key=$2
  awk -F ' *= *' '{ if ($1 ~ /^\[/) section=$1; else if ($1 !~ /^$/) print $1 section "=" $2 }' ~/.aws/credentials | grep "$2\[$1\]" | sed 's/.*=//'
}

export AWS_ACCESS_KEY_ID=$(read_aws_credentials_key default aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(read_aws_credentials_key default aws_secret_access_key)
export AWS_DEFAULT_REGION=$(read_aws_credentials_key default region)

export TF_VAR_aws_access_key_id=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_aws_region=$AWS_DEFAULT_REGION
