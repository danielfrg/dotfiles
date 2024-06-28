# Ansible stuff

## Remote machines setup

Add them to the ssh config file:

```
Host remote-host
    Hostname 10.0.0.0
    User danrodriguez
    ForwardAgent yes
```

Setup SSH with a keypair.
This is important for the SSH forward so that cloning of repos work.

```
ssh-copy-id remote-host
```

Setup passwordless sudo.
This is mostly convinient so I dont have to do `--ask-become-pass` everytime.

```
visudo

# Add this at the bottom before the include line

username ALL=(ALL) NOPASSWD: ALL
```



