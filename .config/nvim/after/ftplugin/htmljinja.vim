"{{{ comment
setlocal commentstring={#\ %s\ #}
"}}}
"{{{ matchit
let b:not_end = '\(?:end\)\@<!'

let b:jinja_for = '\<'.b:not_end.'\(for\)\>:\<else\|end\2\>:\<end\2\>'
let b:jinja_block = '\<'.b:not_end.'block\>:\<endblock\>'
let b:jinja_call = '\<'.b:not_end.'call\>:\<endcall\>'
let b:jinja_if = '\<'.b:not_end.'if\>:\<el\(if\)\>:\<else\>:\<end\2\>'

let b:match_words = b:match_words.',' .
      \ '{%-\? *block\>.\{-}%}:{%-\? *endblock\>.\{-}%},' .
      \ '{%-\? *call\>.\{-}%}:{%-\? *endcall\>.\{-}%},' .
      \ '{%-\? *for\>.\{-}%}:{%-\? *\(empty\|endfor\)\>.\{-}%},' .
      \ '{%-\? *blocktrans\>.\{-}%}:{%-\? *endblocktrans\>.\{-}%},' .
      \ '{%-\? *cache\>.\{-}%}:{%-\? *endcache\>.\{-}%},' .
      \ '{%-\? *comment\>.\{-}%}:{%-\? *endcomment\>.\{-}%},' .
      \ '{%-\? *filter\>.\{-}%}:{%-\? *endfilter\>.\{-}%},' .
      \ '{%-\? *if\>.\{-}%}:{%-\? *else\>.\{-}%}:{%-\? *elif\>.\{-}%}:{%-\? *endif\>.\{-}%},' .
      \ '{%-\? *ifchanged\>.\{-}%}:{%-\? *else\>.\{-}%}:{%-\? *endifchanged\>.\{-}%},' .
      \ '{%-\? *ifequal\>.\{-}%}:{%-\? *else\>.\{-}%}:{%-\? *endifequal\>.\{-}%},' .
      \ '{%-\? *ifnotequal\>.\{-}%}:{%-\? *else\>.\{-}%}:{%-\? *endifnotequal\>.\{-}%},' .
      \ '{%-\? *spaceless\>.\{-}%}:{%-\? *endspaceless\>.\{-}%},' .
      \ '{%-\? *verbatim\>.\{-}%}:{%-\? *endverbatim\>.\{-}%},' .
      \ '{%-\? *with\>.\{-}%}:{%-\? *endwith\>.\{-}%}'
"}}}
