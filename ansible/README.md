# Ansible stuff

## Remote machines setup

- Add the hosts to the ssh config file

```
Host remote-host
    Hostname 10.0.0.0
    User danrodriguez
    ForwardAgent yes
```

- Setup passwordless sudo
  - So I dont have to do `--ask-become-pass` everytime

```
visudo

# Add this at the bottom before the include line

username ALL=(ALL) NOPASSWD: ALL
```

### SSH Forward

- Setup SSH with a keypair
  - Add the key to the `~/.ssh/authorized_keys` file
- Add `AllowAgentForwarding` to the sshd_config file on the remote host:

More debugging: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/using-ssh-agent-forwarding

- This might also be needed:

```
ssh-copy-id remote-host
```

