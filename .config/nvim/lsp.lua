vim.lsp.set_log_level("debug")

local lspconfig = require "lspconfig"

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false,
    update_in_insert = false
  }
)

local function set_lsp_config(client)
  vim.api.nvim_command [[setlocal signcolumn=yes]]
  vim.api.nvim_command [[nnoremap <buffer><silent> <C-space> :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> ]g :lua vim.lsp.diagnostic.goto_next()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> [g :lua vim.lsp.diagnostic.goto_prev()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> <space>d :lua vim.lsp.diagnostic.set_loclist()<CR>]]

  if client.resolved_capabilities.completion then
    vim.api.nvim_command [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
  end

  if client.resolved_capabilities.hover then
    vim.api.nvim_command [[nnoremap <buffer><silent> K :lua vim.lsp.buf.hover()<CR>]]
  end

  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-LeftMouse> :lua require"lsp_utils".definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> [d :lua require"lsp_utils".definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> [<C-d> :lua require"lsp_utils".definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-w><C-d> :split <bar> lua require"lsp_utils".definition_sync('split')<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-w>} <cmd>lua require"lsp_utils".peek_definition()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-c><C-p> <cmd>lua require"lsp_utils".peek_definition()<CR>]]
  end

  if client.resolved_capabilities.type_definition then
    vim.api.nvim_command [[nnoremap <buffer><silent> [t :lua vim.lsp.buf.type_definition()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-w><C-t> :lua vim.lsp.buf.type_definition()<CR>]]
  end

  if client.resolved_capabilities.find_references then
    vim.api.nvim_command [[command! -buffer References lua vim.lsp.buf.references()]]
  end

  if client.resolved_capabilities.rename then
    vim.api.nvim_command [[nnoremap <buffer><silent> gR :lua vim.lsp.buf.rename()<CR>]]
    vim.api.nvim_command [[command! -buffer Rename lua vim.lsp.buf.rename()]]
  end

  if client.resolved_capabilities.workspace_symbol then
    vim.api.nvim_command [[nnoremap <buffer><silent> gs :lua vim.lsp.buf.workspace_symbol()<CR>]]
  end

  if client.resolved_capabilities.code_action then
    vim.api.nvim_command [[nnoremap <buffer><silent> <M-CR> :lua vim.lsp.buf.code_action()<CR>]]
    vim.api.nvim_command [[vnoremap <buffer><silent> <M-CR> :'<,'>lua vim.lsp.buf.range_code_action()<CR>]]
  end

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[command! -buffer Fmt lua vim.lsp.buf.formatting_sync(nil, 1000)]]
    vim.api.nvim_command [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 500)]]
  end

  if client.resolved_capabilities.signature_help then
    vim.api.nvim_command [[inoremap <buffer><silent> <C-x><C-p> <C-o>:lua vim.lsp.buf.signature_help()<CR>]]
  end
end

lspconfig.pyls.setup {
  on_attach = function(client)
    set_lsp_config(client)
  end,
  settings = {
    pyls = {
      configurationSources = {"flake8"},
      plugins = {
        pycodestyle = {enabled = true},
        pyflakes = {enabled = true},
        yapf = {enabled = false}
      }
    }
  }
}

lspconfig.tsserver.setup {
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    client.server_capabilities.completionProvider.triggerCharacters = {}
    set_lsp_config(client)
  end
}

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") ~= 0 then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

lspconfig.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
    set_lsp_config(client)
  end,
  root_dir = function()
    if not eslint_config_exists() then
      return nil
    end
    return vim.fn.getcwd()
  end,
  settings = {
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      ["javascript.jsx"] = {eslint},
      typescript = {eslint},
      ["typescript.tsx"] = {eslint},
      typescriptreact = {eslint}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  }
}
