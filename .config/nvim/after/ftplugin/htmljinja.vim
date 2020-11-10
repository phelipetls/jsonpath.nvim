setlocal commentstring={#\ %s\ #}

inoremap <C-x>{ {{<space><space>}}<left><left><left>
inoremap <C-x>% {%<space><space>%}<left><left><left>

let b:not_end = '\(?:end\)\@<!'

let b:jinja_for = '\<'.b:not_end.'\(for\)\>:\<else\|end\2\>:\<end\2\>'
let b:jinja_block = '\<'.b:not_end.'block\>:\<endblock\>'
let b:jinja_call = '\<'.b:not_end.'call\>:\<endcall\>'
let b:jinja_if = '\<'.b:not_end.'if\>:\<el\(if\)\>:\<else\>:\<end\2\>'
