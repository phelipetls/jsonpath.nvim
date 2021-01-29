vim.lsp.set_log_level("debug")

local nvim_lsp = require "nvim_lsp"
local rg_find = require "rg_find"

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = false,
    underline = false
  }
)

local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    return
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end

function definition_sync(fallback_command)
  local params = vim.lsp.util.make_position_params()
  local clients, err = vim.lsp.buf_request_sync(0, "textDocument/definition", params, timeout_ms or 1000)

  if err or not clients or vim.tbl_isempty(clients) then
    require"rg_find".rg_find()
    return
  end

  local results  = {}

  for i, client in ipairs(clients) do
    if client.result then
      results[i] = client.result[1]
    end
  end

  vim.lsp.util.jump_to_location(results[1])
  if #results > 1 then
    util.set_qflist(util.locations_to_items(results))
  end
end

local function set_lsp_config(client)
  vim.api.nvim_command [[setlocal signcolumn=yes]]
  vim.api.nvim_command [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]

  if client.resolved_capabilities.completion then
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-space> :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> ]g :lua vim.lsp.diagnostic.goto_next()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> [g :lua vim.lsp.diagnostic.goto_prev()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <space>d :lua vim.lsp.diagnostic.set_loclist()<CR>]]
  end

  if client.resolved_capabilities.hover then
    vim.api.nvim_command [[nnoremap <buffer><silent> K :lua vim.lsp.buf.hover()<CR>]]
  end

  if client.resolved_capabilities.goto_definition then
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-LeftMouse> :lua definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> [d :lua definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> gd :lua definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> [<C-d> :lua definition_sync()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-w><C-d> :split <bar> lua definition_sync('split')<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-w>} <cmd>lua peek_definition()<CR>]]
    vim.api.nvim_command [[nnoremap <buffer><silent> <C-c><C-p> <cmd>lua peek_definition()<CR>]]
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
    vim.api.nvim_command [[vnoremap <buffer><silent> <M-CR> :lua vim.lsp.buf.range_code_action()<CR>]]
  end

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_command [[command! -buffer Fmt lua vim.lsp.buf.formatting_sync(nil, 1000)]]
    vim.api.nvim_command [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
  end

  if client.resolved_capabilities.signature_help then
    vim.api.nvim_command [[inoremap <buffer><silent> <C-x><C-p> <C-o>:lua vim.lsp.buf.signature_help()<CR>]]
  end
end

nvim_lsp.pyls.setup {
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

nvim_lsp.tsserver.setup {
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    set_lsp_config(client)
  end
}

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

nvim_lsp.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
    set_lsp_config(client)
  end,
  default_config = {
    cmd = { "efm-langserver" }
  },
  root_dir = function()
    if not vim.tbl_contains(vim.fn.glob("*", 0, 1), '.eslintrc') then
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
