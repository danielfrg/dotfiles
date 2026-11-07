default:
  just --list

ansible TAG:
  cd ansible; ansible-playbook local.yml --tags "{{TAG}}"

ansible-laptop:
  cd ansible; ansible-playbook local.yml --tags "laptop"

ansible-nvidia:
  cd ansible; ansible-playbook nvidia.yml

ansible-homelab:
  cd ansible; ansible-playbook homelab.yml --limit homelab

stow:
  # Create these directories first so stow links configs individually instead of
  # folding into the repo (which would put private keys in it)
  mkdir -p -m 700 $HOME/.gnupg
  stow -t $HOME home

unstow:
  stow -t $HOME -D home

gpg:
  @echo "Configs are linked by 'just stow'. Manually run 'gpg --import <file>' for the public and private keys"
