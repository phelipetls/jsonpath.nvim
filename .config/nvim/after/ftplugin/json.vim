if executable('jq')
  setlocal formatprg=jq\ .
elseif executable('python3')
  setlocal formatprg=python3\ -m\ json.tool
endif

if exists('+winbar')
  setlocal winbar=%{luaeval('require\"jsonpath\".get()')}
endif

nnoremap <buffer> y<C-p> :let @+=luaeval('require"jsonpath".get()')<CR>
