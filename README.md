This is a Neovim-only plugin containing a function to return a path to access
the value under the cursor by using treesitter. It may help you understand how
to access even deeply nested values in JSON files.

A "JSON path" is a [jq](https://github.com/stedolan/jq)-like expression, such
as `.` for root, `.[0]` for the first array item, `.name` for the property
"name" of an object.

[Demonstration](https://user-images.githubusercontent.com/39670535/194752997-f6048859-44b8-447c-935f-99808771d924.webm)

# Dependencies

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/).

# Usage

```vim
" in ~/after/ftplugin/json.vim

" show json path in the winbar
if exists('+winbar')
  setlocal winbar=%{luaeval('require\"jsonpath\".get()')}
endif

" send json path to clipboard
nnoremap <buffer> y<C-p> :let @+=luaeval('require"jsonpath".get()')<CR>
```
