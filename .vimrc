set runtimepath+=~/.config/nvim runtimepath+=~/.config/nvim/after
let &packpath=&runtimepath
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
source $HOME/.config/nvim/init.vim
