" colorizer.lua
if exists('g:loaded_colorizer')
lua << EOF
require("colorizer").setup({
  filetypes = {
    javascript = { names = false },
    typescript = { names = false },
    typescriptreact = { names = false },
    javascriptreact = { names = false },
    css = { names = false },
    html = { names = false },
    vim = { names = false },
    json = { names = false },
  },
}, { rgb_fn = true })
EOF
endif
