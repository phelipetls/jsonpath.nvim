This is a Neovim-only plugin containing a function to return a path to access
the value under the cursor by using treesitter. It may help you understand how
to access even deeply nested values in JSON files.

A "JSON path" is a [jq](https://github.com/stedolan/jq)-like expression, such
as `.` for root, `.[0]` for the first array item, `.name` for the property
"name" of an object.

[jsonpath-nvim-demo.webm](https://user-images.githubusercontent.com/39670535/194754315-57601183-fd1e-4633-982b-66c0c77fea29.webm)

*Colorscheme is [vim-moonfly-colors](https://github.com/bluz71/vim-moonfly-colors)*

# Dependencies

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/).

# Install

With Lazy:

```lua
{
    "phelipetls/jsonpath.nvim",
    cmd = "JsonPathCopy",
    opts = { show_on_winbar = true, reg = "+" },
},
```

# Usage

Using the lua command:
```lua
vim.keymap.set("n", "y<C-p>", "<cmd>JsonPathCopy<CR>", { desc = "copy json path", buffer = true })
```

Using lua:
```lua
-- in after/ftplugin/json.lua

-- show json path in the winbar
if vim.fn.exists("+winbar") == 1 then
  vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
end

-- send json path to clipboard
vim.keymap.set("n", "y<C-p>", function()
  vim.fn.setreg("+", require("jsonpath").get())
end, { desc = "copy json path", buffer = true })
```

Using vim:
```vim
" in after/ftplugin/json.vim

" show json path in the winbar
if exists('+winbar')
  setlocal winbar=%{luaeval('require\"jsonpath\".get()')}
endif

" send json path to clipboard
nnoremap <buffer> y<C-p> :let @+=luaeval('require"jsonpath".get()')<CR>
```
