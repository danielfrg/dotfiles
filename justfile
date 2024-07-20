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

link:
  stow -t $HOME base
  stow -t $HOME bin
  stow -t $HOME js
  stow -t $HOME nvim
  stow -t $HOME python
  stow -t $HOME zsh

unstow:
  stow -t $HOME -D nvim

gpg:
  gpg --list-keys
  stow -t $HOME gpg
  echo "Manually run 'gpg --import <file>' for the public and private keys"
