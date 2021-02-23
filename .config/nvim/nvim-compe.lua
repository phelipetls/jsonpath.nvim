require "compe".setup(
  {
    enabled = 1,
    min_length = 3,
    preselect = "enable",
    allow_prefix_unmatch = 0,
    source_timeout = 300,
    throttle_time = 100,
    incomplete_delay = 400,
    documentation = 0,
    source = {
      path = 1,
      buffer = 1,
      calc = 1,
      omni = {filetypes = {"css", "html"}},
      nvim_lua = {filetypes = {"lua"}},
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
