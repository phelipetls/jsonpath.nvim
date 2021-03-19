setlocal shiftwidth=2 softtabstop=2

setlocal path+=./components,./views
setlocal path-=./node_modules/**,node_modules/**
lua require"js_utils".set_tsconfig_include_in_path()

if executable("jest") && match(expand("%:p:t"), 'test\.\(js\|ts\|jsx\|tsx\)$') != -1
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

function JsIncludeExpr(fname)
  return luaeval("require'js_utils'.js_includeexpr(_A)",a:fname)
endfunction

setlocal includeexpr=JsIncludeExpr(v:fname)

setlocal isfname+=@-@

setlocal include=^\\s*[^\/]\\+\\(from\\\|require(\\)\\s*['\"]\\ze[\.]

let &l:define = '^\s*\('
      \ . '\(export\s\)*\(\w\+\s\)*\(var\|const\|let\|function\|class\|interface\|as\)\s'
      \ . '\|\(public\|private\|protected\|readonly\|static\|get\s\|set\)\s'
      \ . '\|\(export\sdefault\s\|abstract\sclass\s\)'
      \ . '\|\(async\sfunction\)\s'
      \ . '\|\(\ze\i\+([^)]*).*{$\)'
      \ . '\)'
