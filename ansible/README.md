# Ansible stuff

## Remote machines setup

Add the hosts to the ssh config file

```
Host remote-host
    Hostname 10.0.0.0
    User danielfrg
    ForwardAgent yes
```

Install `openssh`
- Enable and start the service:

```
systemctl enable sshd.service
systemctl start sshd.service
```

Setup passwordless sudo
- So I dont have to do `--ask-become-pass` everytime

```
visudo

# Add this at the bottom before the include line

username ALL=(ALL) NOPASSWD: ALL
```

### SSH Forward

Setup SSH with a keypair by adding the key to the `~/.ssh/authorized_keys` file

```
curl -o ~/.ssh/authorized_keys https://github.com/danielfrg.keys

# or:

ssh-copy-id remote-host
```

- Add or uncomment the `AllowAgentForwarding yes` line in the
`/etc/ssh/sshd_config` file on the remote host

Test by ssh'ing and:

```
echo "$SSH_AUTH_SOCK"

ssh -T git@github.com
```

- For more debugging: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/using-ssh-agent-forwarding

