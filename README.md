My configuration files for Linux and macOS.

# Install git

| Ubuntu | Fedora | macOS |
| ------ | ------ | ----- |
| `sudo apt install -y git` | `sudo dnf install -y git` | `xcode-select --install` |

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
./bootstrap
```
