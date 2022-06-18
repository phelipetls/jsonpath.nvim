" colorizer.lua
if exists('g:loaded_colorizer')
lua << EOF
require("colorizer").setup({
  '!*',
  javascript = { names = false },
  typescript = { names = false },
  typescriptreact = { names = false },
  javascriptreact = { names = false },
  "css",
  "html",
  "vim",
  "json",
}, { rgb_fn = true })
EOF
endif
