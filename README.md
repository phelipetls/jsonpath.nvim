My configuration files for Ubuntu and macOS.

# Setup in Ubuntu

```sh
sudo apt install -y git
git clone git@github.com:phelipetls/dotfiles.git

cd dotfiles

./install
ansible-playbook bootstrap.yml
```

# Setup in macOS

Install git with XCode Command Line Tools. This should work:

```sh
xcode-select --install
```

Then clone the repository

```sh
git clone git@github.com:phelipetls/dotfiles.git

cd dotfiles
```

Create a Python virtual environment to install Ansible.

```sh
python3 -m venv venv
source venv/bin/activate
./install

ansible-playbook bootstrap.yml
```
