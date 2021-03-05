setlocal shiftwidth=2 softtabstop=2

setlocal path+=./components,./views

if executable("jest") && match(expand("%:p:t"), "test.js") != -1
  compiler jest
elseif executable("eslint_d")
  compiler eslint_d
elseif executable("eslint")
  compiler eslint
endif

if executable("node")
  noremap <buffer> <F5> :w !node<CR>
endif

let &l:formatprg=luaeval("require'js_utils'.get_js_formatter()")

let b:surround_{char2nr("c")} = "console.log(\r)"
let b:surround_{char2nr("C")} = "console.log(JSON.stringify(\r, null, 2))"
let b:surround_{char2nr("j")} = "JSON.stringify(\r, null, 2)"
let b:surround_{char2nr("e")} = "${\r}"

nnoremap <buffer> [<C-c> "zyiwOconsole.log(z)<Esc>
nnoremap <buffer> ]<C-c> "zyiwoconsole.log(z)<Esc>
nnoremap <buffer> [<C-j> "zyiwOJSON.stringify(z, null, 2)<Esc>
nnoremap <buffer> ]<C-j> "zyiwoJSON.stringify(z, null, 2)<Esc>

iabbr <buffer><silent> clog console.log()<Left><C-R>=Eatchar('\s')<CR>
iabbr consoel console
iabbr lenght length
iabbr edf export default function
iabbr improt import
iabbr Obejct Object
iabbr entires entries
iabbr cosnt const
iabbr /** /****/<Up>
iabbr docuemnt document

if executable("firefox")
  setlocal keywordprg=firefox\ https://developer.mozilla.org/search?topic=api\\&topic=js\\&q=\
endif

let b:dsf_function_pattern = '\(new\s*\)\?\k\+'
