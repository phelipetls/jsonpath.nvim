My configuration files for Linux and macOS.

# Install git

## Ubuntu

```sh
sudo apt install -y git
```

## Fedora

```sh
sudo dnf install -y git
```

## macOS

Install git with XCode Command Line Tools:

```sh
xcode-select --install
```

# Clone the repository

```sh
git clone git@github.com:phelipetls/dotfiles.git
cd dotfiles
```

# Install Ansible

```sh
./install
```

# Run playbook

```sh
# Bootstrap development environntment in Linux, WSL and macOS
ansible-playbook bootstrap.yml
```
