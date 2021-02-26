require "compe".setup(
  {
    enabled = true,
    min_length = 3,
    preselect = "disable",
    source_timeout = 300,
    throttle_time = 100,
    incomplete_delay = 400,
    documentation = true,
    source = {
      path = {
        priority = 100
      },
      buffer = true,
      calc = true,
      omni = {filetypes = {"css", "html"}},
      nvim_lua = true,
      nvim_lsp = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescript.tsx",
          "typescriptreact"
        }
      }
    }
  }
)

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local prev_char_is_whitespace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif prev_char_is_whitespace() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
