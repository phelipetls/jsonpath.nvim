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

if executable("prettier")
  let &l:formatprg='prettier --parser typescript'
endif

let b:surround_{char2nr("c")} = "console.log(\r)"
let b:surround_{char2nr("e")} = "${\r}"

iabbr <buffer><silent> clog console.log();<Left><Left><C-R>=Eatchar('\s')<CR>
iabbr consoel console
iabbr lenght length
iabbr edf export default function
iabbr improt import
iabbr Obejct Object
iabbr entires entries
iabbr cosnt const
iabbr /** /****/<Up>

nnoremap <buffer> [<C-c> "zyiwOconsole.log(z);<Esc>
nnoremap <buffer> ]<C-c> "zyiwoconsole.log(z);<Esc>

if executable("firefox")
  setlocal keywordprg=firefox\ https://developer.mozilla.org/search?topic=api\\&topic=js\\&q=\
endif

" " we will need this in several places so let's do it once
" let b:js_node_modules = fnamemodify(finddir('node_modules', '.;'), ':.')

" " return an accurate glob string for the given filename which should look like this:
" " src/foo/Bar{/Bar,/index,*}.{js,jsx,ts,tsx,vue}
" function! s:Build_glob_string_from_relative_fname(fname, modifier) abort
"     let ext = fnamemodify(a:fname, ':e')
"     return ''
"         \ . expand('%:.:h' . a:modifier) . '/'
"         \ . fnamemodify(matchstr(a:fname, '\(\(\.\)\+/\)\+\zs.*'), ':r')
"         \ . '{/' . fnamemodify(split(a:fname, '/')[-1], ':r') . ',/index,*}'
"         \ . '.' . (empty(ext) ? '{js,jsx,ts,tsx,vue}' : ext)
" endfunction

" " same, but specifically for aliased imports, which are easier to resolve
" function! s:Build_glob_string_from_aliased_fname(fname) abort
"     let ext = fnamemodify(a:fname, ':e')
"     return ''
"         \ . fnamemodify(a:fname, ':r')
"         \ . '{/' . fnamemodify(split(a:fname, '/')[-1], ':r') . ',/index,*}'
"         \ . '.' . (empty(ext) ? '{js,jsx,ts,tsx,vue}' : ext)
" endfunction

" " the big deal
" function! IncludeExpression(fname, gf) abort
"     " BUILT-IN NODE MODULES
"     if index([ 'assert', 'async_hooks',
"         \ 'child_process', 'cluster', 'crypto',
"         \ 'dgram', 'dns', 'domain',
"         \ 'evenjs',
"         \ 'fs',
"         \ 'http', 'http2', 'https',
"         \ 'inspector',
"         \ 'net',
"         \ 'os',
"         \ 'path', 'perf_hooks', 'punycode',
"         \ 'querystring',
"         \ 'readline',
"         \ 'stream', 'string_decoder',
"         \ 'tls', 'tty',
"         \ 'url', 'util',
"         \ 'v8', 'vm',
"         \ 'zlib' ], a:fname) != -1
"         let found_definition = b:js_node_modules . '/@types/node/' . a:fname . '.d.ts'

"         if filereadable(found_definition)
"             return found_definition
"         endif

"         return 0
"     endif

"     " LOCAL IMPORTS
"     if a:fname =~ '^\.\./'
"         let modifier = substitute(matchstr(a:fname, '\(\(\.\)\+/\)\+'), '\.\./', ':h', 'g')
"         return get(glob(s:Build_glob_string_from_relative_fname(a:fname, modifier), 0, 1), 0, a:fname)
"     endif

"     if a:fname =~ '^\./'
"         return get(glob(s:Build_glob_string_from_relative_fname(a:fname, ''), 0, 1), 0, a:fname)
"     endif

"     " ALIASED IMPORTS
"     if !empty(get(b:, 'js_config_aliases', []))
"         for alias in b:js_config_aliases
"             if a:fname =~ alias[0]
"                 let base_name = substitute(a:fname, alias[0], alias[1] . '/', '')
"                 return get(glob(s:Build_glob_string_from_aliased_fname(base_name), 0, 1), 0, a:fname)
"             endif
"         endfor
"     endif

"     if !a:gf
"         return a:fname
"     endif

"     " NPM IMPORTS
"     if empty(get(b:, 'js_node_modules', ''))
"         return 0
"     endif

"     let found_package = globpath(b:js_node_modules, a:fname, 0, 1)

"     if len(found_package)
"         let package_json = found_package[0] . '/package.json'
"         let package_json_data = json_decode(join(readfile(package_json)))
"         return found_package[0] . "/" . get(package_json_data, "main", "index.js")
"     endif

"     return a:fname
" endfunction
" setlocal includeexpr=IncludeExpression(v:fname,0)

" " @ is a popular alias
" setlocal isfname+=@-@

" " this pattern is voluntarily limited to local imports just to validate an hypothesis
" setlocal include=^\\s*[^\/]\\+\\(from\\\|require(\\)\\s*['\"]\\ze[\.]

" " this pattern should cover most definition expressions
" let &l:define = '^\s*\('
"     \ . '\(export\s\)*\(\w\+\s\)*\(var\|const\|let\|function\|class\|interface\|as\)\s'
"     \ . '\|\(public\|private\|protected\|readonly\|static\|get\s\|set\)\s'
"     \ . '\|\(export\sdefault\s\|abstract\sclass\s\)'
"     \ . '\|\(async\sfunction\)\s'
"     \ . '\|\(\ze\i\+([^)]*).*{$\)'
"     \ . '\)'

" " the underlying implementation of gf is not JS-friendly at all
" " so we override it with a wrapper that makes use of &includeexpr
" function! s:GF(text, split, tab) abort
"     let include_expression = IncludeExpression(a:text, 1)

"     if len(include_expression) > 1
"         let cmds = {
"             \ "00": "silent edit ",
"             \ "10": "silent split ",
"             \ "11": "silent tab split "
"             \ }

"         execute cmds[a:split . a:tab] . include_expression
"     else
"         echohl WarningMsg
"         echo "Can't find file " . a:text
"         echohl None
"     endif
" endfunction
" nnoremap <silent> <buffer> gf      :call <SID>GF(expand('<cfile>'), 0, 0)<CR>
" nnoremap <silent> <buffer> <C-w>f  :call <SID>GF(expand('<cfile>'), 1, 0)<CR>
" nnoremap <silent> <buffer> <C-w>gf :call <SID>GF(expand('<cfile>'), 1, 1)<CR>
