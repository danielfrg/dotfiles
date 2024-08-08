default:
  just --list

ansible-laptop:
  cd ansible; ansible-playbook local.yml --tags "laptop"

ansible-nvidia:
  cd ansible; ansible-playbook nvidia.yml

ansible-homelab:
  cd ansible; ansible-playbook homelab.yml --limit homelab

ansible TAG:
  cd ansible; ansible-playbook local.yml --tags "{{TAG}}"

fonts:
  bash install-fonts.sh

stow:
  stow -t $HOME home

unstow:
  stow -t $HOME -D home

gpg:
  gpg --list-keys
  stow -t $HOME gpg
  echo "Manually run 'gpg --import <file>' for the public and private keys"
