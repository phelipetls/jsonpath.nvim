let b:coc_root_patterns = ['package.json', '.git']

setlocal path-=./node_modules/**,node_modules/**
setlocal path=node_modules
setlocal path+=cypress/fixtures

let &l:path .= ',' . join(map(finddir('node_modules', '.;', -1), 'fnamemodify(resolve(v:val), ":p:s?[\\/]$??")'), ',')

if has('nvim')
  let tsconfig_include = join(luaeval("require'tsconfig'.get_tsconfig_include()"), ',')
  if !empty(tsconfig_include) && stridx(&l:path, tsconfig_include) == -1
    let &l:path .= ',' . tsconfig_include
  endif
endif

setlocal include=\\%(\\<require\\s*(\\s*\\\|\\<import\\\|from\\>[^;\"']*\\)[\"']\\zs[^\"']*

let &l:define = '^\s*\('
      \ . '\(export\s\)*\(\w\+\s\)*\(var\|const\|type\|let\|function\|class\|interface\|as\|enum\)\s'
      \ . '\|\(public\|private\|protected\|readonly\|static\|get\s\|set\)\s'
      \ . '\|\(export\sdefault\s\|abstract\sclass\s\)'
      \ . '\|\(async\sfunction\)\s'
      \ . '\|\(\ze\i\+([^)]*).*{$\)'
      \ . '\)'

if executable('jest') && match(expand('%:p:t'), 'test\.\(js\|ts\|jsx\|tsx\)$') != -1
  compiler jest
elseif !empty(findfile('tsconfig.json', ';.')) || !empty(findfile('jsconfig.json', ';.'))
  compiler tsc_lint
elseif executable('eslint_d')
  compiler eslint_d
elseif executable('eslint')
  compiler eslint
endif

command! TSLint compiler tsc_lint | Make
command! ESLint compiler eslint_d | Make "src/**/*.{js,tsx,ts,tsx}"

if executable('node')
  noremap <buffer> <F5> :w !node<CR>
endif

if executable('npx')
  let &l:formatprg='npx prettier --parser=typescript'
elseif executable('eslint_d')
  let &l:formatprg='eslint_d --fix-to-stdout --stdin'
endif

let b:surround_{char2nr('c')} = 'console.log(\r)'
let b:surround_{char2nr('C')} = 'console.log(JSON.stringify(\r, null, 2))'
let b:surround_{char2nr('j')} = 'JSON.stringify(\r, null, 2)'
let b:surround_{char2nr('e')} = '${\r}'

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
inoreabbrev {/* {/*  */}<left><left><left><left><C-r>=Eatchar('\s')<CR>
inoreabbrev docuemnt document

setlocal isfname+=@-@
setlocal suffixesadd=.js,.jsx,.ts,.tsx,.d.ts,.vue,/package.json

function! JavascriptNodeFind(target, current) abort
  let target = substitute(a:target, '^\~[^/]\@=', '', '')
  if target =~# '^\.\.\=/'
    let target = simplify(fnamemodify(resolve(a:current), ':p:h') . '/' . target)
  endif
  let found = findfile(target)
  if found =~# '[\/]package\.json$' && target !~# '[\/]package\.json$'
    try
      let package = json_decode(join(readfile(found)))
      let target .= '/' . substitute(get(package, 'main', 'index'), '\.js$', '', '')
    catch
    endtry
  endif
  if has('nvim')
    return luaeval("require'tsconfig'.includeexpr(_A)", target)
  endif
  return target
endfunction

setlocal includeexpr=JavascriptNodeFind(v:fname,@%)
