My configuration files for Linux.

# Setup

I use Ansible to set up my development environment.

In a new machine, I expect these commands to handle installing the programs I
use most often:

```sh
sudo apt install -y ansible git

git clone git@github.com:phelipetls/dotfiles.git

ansible-galaxy install -r dotfiles/requirements.yml
ansible-playbook --ask-become-pass dotfiles/bootstrap.yml
```

# Manual Setup

## Start TLP

```sh
tlp start
```
