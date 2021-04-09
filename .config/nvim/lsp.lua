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
  vim.cmd [[setlocal signcolumn=yes]]
  vim.cmd [[nnoremap <buffer><silent> <C-space> :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> ]g :lua vim.lsp.diagnostic.goto_next()<CR>]]
  vim.cmd [[nnoremap <buffer><silent> [g :lua vim.lsp.diagnostic.goto_prev()<CR>]]

  vim.cmd [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]

  if client.resolved_capabilities.hover then
    vim.cmd [[nnoremap <buffer><silent> K :lua vim.lsp.buf.hover()<CR>]]
  end

  if client.resolved_capabilities.goto_definition then
    vim.cmd [[nnoremap <buffer><silent> <C-LeftMouse> :lua require"lsp_utils".definition_sync()<CR>]]
    vim.cmd [[nnoremap <buffer><silent> [d :lua require"lsp_utils".definition_sync()<CR>]]
    vim.cmd [[nnoremap <buffer><silent> [<C-d> :lua require"lsp_utils".definition_sync()<CR>]]
    vim.cmd [[nnoremap <buffer><silent> <C-w><C-d> :split <bar> lua require"lsp_utils".definition_sync('split')<CR>]]
    vim.cmd [[nnoremap <buffer><silent> <C-w>} :lua require"lsp_utils".peek_definition()<CR>]]
    vim.cmd [[nnoremap <buffer><silent> <C-c><C-p> :lua require"lsp_utils".peek_definition()<CR>]]
  end

  if client.resolved_capabilities.type_definition then
    vim.cmd [[nnoremap <buffer><silent> [t :lua vim.lsp.buf.type_definition()<CR>]]
    vim.cmd [[nnoremap <buffer><silent> <C-w><C-t> :lua vim.lsp.buf.type_definition()<CR>]]
  end

  if client.resolved_capabilities.find_references then
    vim.cmd [[command! -buffer References lua vim.lsp.buf.references()]]
  end

  if client.resolved_capabilities.rename then
    vim.cmd [[nnoremap <buffer><silent> gR :lua vim.lsp.buf.rename()<CR>]]
    vim.cmd [[command! -buffer Rename lua vim.lsp.buf.rename()]]
  end

  if client.resolved_capabilities.workspace_symbol then
    vim.cmd [[nnoremap <buffer><silent> gs :lua vim.lsp.buf.workspace_symbol()<CR>]]
  end

  if client.resolved_capabilities.code_action then
    vim.cmd [[nnoremap <buffer><silent> <M-CR> :lua vim.lsp.buf.code_action()<CR>]]
    vim.cmd [[vnoremap <buffer><silent> <M-CR> :'<,'>lua vim.lsp.buf.range_code_action()<CR>]]
  end

  if client.resolved_capabilities.document_formatting then
    vim.cmd [[command! -buffer Fmt lua vim.lsp.buf.formatting_sync(nil, 1000)]]
    vim.cmd [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 500)]]
  end

  if client.resolved_capabilities.signature_help then
    vim.cmd [[inoremap <buffer><silent> <C-x><C-p> <C-o>:lua vim.lsp.buf.signature_help()<CR>]]
  end

  if client.name == "tsserver" then
    vim.cmd [[command! OrganizeImports :lua require'tsserver_utils'.organize_imports()<CR>]]
    vim.cmd [[nnoremap <silent> <S-M-o> :lua require'tsserver_utils'.organize_imports()<CR>]]

    vim.cmd [[augroup LspImportAfterCompletion]]
    vim.cmd [[  au!]]
    vim.cmd [[  autocmd CompleteDone <buffer> lua require"lsp_utils".import_after_completion()]]
    vim.cmd [[augroup END]]

    _G.rename_hook = require "tsserver_utils".rename
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

local js_config = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = require "js_utils".get_js_formatter(),
  formatStdin = true
}

local function should_use_efm_formatting()
  if js_config.formatCommand == "" then
    return false
  end

  if js_config.formatCommand:find("eslint_d") then
    return require"js_utils".check_eslint_config()
  end

  return js_config.formatCommand ~= ""
end

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = not should_use_efm_formatting()
    client.server_capabilities.completionProvider.triggerCharacters = nil
    set_lsp_config(client)
  end
}

lspconfig.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = should_use_efm_formatting()
    set_lsp_config(client)
  end,
  default_config = {
    cmd = {
      "efm-langserver",
      "-c",
      [["$HOME/.config/efm-langserver/config.yaml"]]
    }
  },
  root_dir = function()
    if require "js_utils".eslint_config_exists() then
      return vim.fn.getcwd()
    end
  end,
  settings = {
    languages = {
      javascript = {js_config},
      javascriptreact = {js_config},
      ["javascript.jsx"] = {js_config},
      typescript = {js_config},
      ["typescript.tsx"] = {js_config},
      typescriptreact = {js_config}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  },
  commands = {
    EfmLog = {
      function()
        local logfile = "$HOME/efmlangserver.log"
        local cmd = string.format("tail -1000 %s | grep -E '^[0-9]{4}/[0-9]{2}/[0-9]{2}'", logfile)

        vim.cmd("split new")
        vim.cmd("10wincmd _")
        vim.cmd("set bt=nofile")
        vim.cmd("setlocal nowrap")
        vim.cmd("setlocal bufhidden=wipe")
        vim.cmd(string.format("r ++edit !%s", cmd))
      end
    }
  }
}
