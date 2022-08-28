set runtimepath^=~/.config/nvim
set runtimepath+=~/.config/nvim/after
let &packpath=&runtimepath
source $HOME/.config/nvim/init.vim
