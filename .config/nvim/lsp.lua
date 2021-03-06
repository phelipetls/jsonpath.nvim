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
  vim.api.nvim_command [[nnoremap <buffer><silent> <C-space> :lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> ]g :Lspsaga diagnostic_jump_next<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> [g :Lspsaga diagnostic_jump_prev<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> <space>d :lua vim.lsp.diagnostic.set_loclist()<CR>]]

  if client.resolved_capabilities.completion then
    vim.api.nvim_command [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
  end

  if client.resolved_capabilities.hover then
    vim.api.nvim_command [[nnoremap <buffer><silent> K :lua require('lspsaga.hover').render_hover_doc()<CR>]]
  end

  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-LeftMouse> :lua require"lsp_utils".definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> [d :lua require"lsp_utils".definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> [<C-d> :lua require"lsp_utils".definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-w><C-d> :split <bar> lua require"lsp_utils".definition_sync('split')<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-w>} :Lspsaga preview_definition<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-c><C-p> :Lspsaga preview_definition<CR>]]
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
    vim.api.nvim_command [[inoremap <buffer><silent> <C-x><C-p> <C-o>:lua require('lspsaga.signaturehelp').signature_help()<CR>]]
  end

  if client.name == "tsserver" then
    vim.api.nvim_command [[command! OrganizeImports :lua require'tsserver_utils'.organize_imports()<CR>]]
    vim.api.nvim_command [[nnoremap <silent> <S-M-o> :lua require'tsserver_utils'.organize_imports()<CR>]]

    vim.api.nvim_command("let g:DovishRename = function('tsserver#Rename')")
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
    client.server_capabilities.completionProvider.triggerCharacters = {"."}
    set_lsp_config(client)
  end
}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = require"js_utils".get_js_formatter(),
  formatStdin = true
}

lspconfig.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    set_lsp_config(client)
  end,
  -- default_config = {
  --   cmd = {
  --     "efm-langserver",
  --     "-c",
  --     [["$HOME/.config/efm-langserver/config.yaml"]]
  --   },
  --   filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"}
  -- },
  root_dir = function()
    if not require"js_utils".eslint_config_exists() then
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
