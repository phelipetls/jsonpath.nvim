inoremap <C-x>{ {{<space><space>}}<left><left><left>
let b:surround_{char2nr("h")} = "{{ \r }}"

command! ShowTags !grep -hR 'tags:' %:p:h/.. | sed 's/tags: //' | sed 's/[][]//g' | tr -d , | tr ' ' '\n' | sort -u
