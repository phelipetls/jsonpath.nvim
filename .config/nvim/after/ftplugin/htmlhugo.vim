" source $HOME/.config/nvim/after/ftplugin/html.vim

inoremap <C-x>{ {{<space><space>}}<left><left><left>
inoreabbrev {{ {{<space><space>}}<left><left><left><C-R>=Eatchar('\s')<CR>

let b:surround_{char2nr("h")} = "{{ \r }}"

setlocal omnifunc=syntaxcomplete#Complete

command! ShowTags !grep -hR 'tags:' %:p:h/.. | sed 's/tags: //' | sed 's/[][]//g' | tr -d , | tr ' ' '\n' | sort -u
