inoremap <C-x>{ {{<space><space>}}<left><left><left>

let b:surround_{char2nr("h")} = "{{ \r }}"
let b:surround_{char2nr("H")} = "{{ \1control flow: \1 \r }}\n{{ end }}"
