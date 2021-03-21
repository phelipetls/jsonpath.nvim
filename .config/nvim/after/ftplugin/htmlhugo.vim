inoremap <C-x>{ {{<space><space>}}<left><left><left>
inoreabbrev {{ {{<space><space>}}<left><left><left><C-R>=Eatchar('\s')<CR>

let b:surround_{char2nr("h")} = "{{ \r }}"

setlocal omnifunc=syntaxcomplete#Complete
