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

# Usage

Using lua:
```lua
-- in after/ftplugin/json.lua or ~/.config/nvim/init.lua

-- show json path in the winbar
-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "json" },
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = false,
  }
}
-- option 1
-- https://github.com/phelipetls/jsonpath.nvim
vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved" },{
  pattern = { "*.json" },
  callback = function()
    vim.opt_local.winbar = require("jsonpath").get()
  end,
})
-- option 2
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
