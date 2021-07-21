setlocal path-=./node_modules/**,node_modules/**
setlocal path+=cypress/fixtures
if has("nvim")
  let tsconfig_include = luaeval("require'tsconfig'.get_tsconfig_include()")
  if !empty(tsconfig_include) && match(&l:path, tsconfig_include) == -1
    let &l:path .= ',' . tsconfig_include
  endif
endif

setlocal include=\\s*from\\s*['\"]

function JsIncludeExpr(fname)
  return luaeval("require'tsconfig'.includeexpr(_A)",a:fname)
endfunction

setlocal includeexpr=JsIncludeExpr(v:fname)
let &l:define = '^\s*\('
      \ . '\(export\s\)*\(\w\+\s\)*\(var\|const\|let\|function\|class\|interface\|as\|enum\)\s'
      \ . '\|\(public\|private\|protected\|readonly\|static\|get\s\|set\)\s'
      \ . '\|\(export\sdefault\s\|abstract\sclass\s\)'
      \ . '\|\(async\sfunction\)\s'
      \ . '\|\(\ze\i\+([^)]*).*{$\)'
      \ . '\)'

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

if executable('prettier_d_slim')
  let &l:formatprg='prettier_d_slim --parser=typescript --stdin --stdin-filepath'
elseif executable('prettier')
  let &l:formatprg='prettier --parser=typescript'
elseif executable('eslint_d')
  let &l:formatprg='eslint_d --fix-to-stdout --stdin'
endif

let b:surround_{char2nr("c")} = "console.log(\r)"
let b:surround_{char2nr("C")} = "console.log(JSON.stringify(\r, null, 2))"
let b:surround_{char2nr("j")} = "JSON.stringify(\r, null, 2)"
let b:surround_{char2nr("e")} = "${\r}"

nnoremap <buffer> [<C-c> "zyiwOconsole.log(z)<Esc>
nnoremap <buffer> ]<C-c> "zyiwoconsole.log(z)<Esc>

inoreabbrev <buffer><silent> clog console.log()<Left><C-R>=Eatchar('\s')<CR>
inoreabbrev consoel console
inoreabbrev lenght length
inoreabbrev edf export default function
inoreabbrev improt import
inoreabbrev Obejct Object
inoreabbrev entires entries
inoreabbrev cosnt const
inoreabbrev /** /****/<Up>
inoreabbrev docuemnt document

setlocal isfname+=@-@
setlocal suffixesadd=.js,.jsx,.ts,.tsx,.d.ts,.vue

if has("nvim")
  nnoremap <silent><buffer> gf :call luaeval("require'tsconfig'.go_to_file(_A)","edit")<CR>
  nnoremap <silent><buffer> <C-w>f :call luaeval("require'tsconfig'.go_to_file(_A)","split")<CR>
  nnoremap <silent><buffer> <C-w><C-f> :call luaeval("require'tsconfig'.go_to_file(_A)","split")<CR>
endif
