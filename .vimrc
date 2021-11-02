set runtimepath+=~/.config/nvim runtimepath+=~/.config/nvim/after
let &packpath=&runtimepath
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
if has("unix")
  !silent !stty -ixon > /dev/null 2>/dev/null
endif
source $HOME/.config/nvim/init.vim
