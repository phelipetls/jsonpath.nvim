vim.lsp.set_log_level("debug")

local lspconfig = require "lspconfig"
local js_tools = require "utils/js_tools"

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false,
    update_in_insert = false
  }
)

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = "single"
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {
    border = "single"
  }
)

local function set_buf_keymap(bufnr, mode, lhs, rhs)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, {noremap = true, silent = true})
end

local function set_lsp_config(client, bufnr)
  vim.cmd [[setlocal signcolumn=yes]]

  set_buf_keymap(bufnr, "n", "<C-space>", [[:lua vim.lsp.diagnostic.show_line_diagnostics({ border = 'single' })<CR>]])
  set_buf_keymap(bufnr, "n", "]g", [[:lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = 'single' }})<CR>]])
  set_buf_keymap(bufnr, "n", "[g", [[:lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = 'single' }})<CR>]])

  if client.resolved_capabilities.hover then
    set_buf_keymap(bufnr, "n", "K", [[:lua vim.lsp.buf.hover()<CR>]])
  end

  if client.resolved_capabilities.goto_definition then
    set_buf_keymap(bufnr, "n", "[d", [[:lua require'utils/lsp'.definition_sync()<CR>]])
    set_buf_keymap(bufnr, "n", "[<C-d>", [[:lua require'utils/lsp'.definition_sync()<CR>]])
    set_buf_keymap(bufnr, "n", "<C-w><C-d>", [[:split <bar> lua require'utils/lsp'.definition_sync('split')<CR>]])
    set_buf_keymap(bufnr, "n", "<C-c><C-p>", [[:lua require'utils/lsp'.peek_definition()<CR>]])
  end

  if client.resolved_capabilities.type_definition then
    set_buf_keymap(bufnr, "n", "[t", [[:lua vim.lsp.buf.type_definition()<CR>]])
  end

  if client.resolved_capabilities.find_references then
    vim.cmd [[command! -buffer References lua vim.lsp.buf.references()]]
  end

  if client.resolved_capabilities.rename then
    set_buf_keymap(bufnr, "n", "gR", [[:lua vim.lsp.buf.rename()<CR>]])
  end

  if client.resolved_capabilities.code_action then
    set_buf_keymap(bufnr, "n", "<M-CR>", [[:lua vim.lsp.buf.code_action()<CR>]])
  end

  if client.resolved_capabilities.document_formatting then
    vim.cmd [[command! -buffer Fmt lua vim.lsp.buf.formatting_sync(nil, 1000)]]
    vim.cmd [[augroup LspFormatOnSave]]
    vim.cmd [[  autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 500)]]
    vim.cmd [[augroup END]]
  end

  if client.resolved_capabilities.signature_help then
    set_buf_keymap(bufnr, "i", "<C-x><C-p>", [[<C-o>:lua vim.lsp.buf.signature_help()<CR>]])
  end

  if client.name == "tsserver" then
    vim.cmd [[nnoremap <silent> <S-M-o> :lua require'utils/tsserver'.organize_imports()<CR>]]

    vim.cmd [[augroup LspImportAfterCompletion]]
    vim.cmd [[  au!]]
    vim.cmd [[  autocmd CompleteDone <buffer> lua require'utils/lsp'.import_after_completion()]]
    vim.cmd [[augroup END]]

    _G.rename_hook = require "utils/tsserver".rename
  end
end

lspconfig.pyls.setup {
  on_attach = function(client, bufnr)
    set_lsp_config(client, bufnr)
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

local md_config = {
  formatCommand = "prettier_d_slim --parser=markdown --stdin --stdin-filepath ${INPUT}",
  formatStdin = true
}

local js_formatter = js_tools.get_js_formatter()

local js_config = {
  lintCommand = js_tools.should_use_eslint() and "eslint_d -f unix --stdin --stdin-filename ${INPUT}" or "",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = js_formatter,
  formatStdin = true,
  rootMarkers = {"package.json"}
}

local function should_use_efm_formatter()
  if vim.startswith(vim.bo.filetype, "javascript") or vim.startswith(vim.bo.filetype, "typescript") then
    if js_formatter:find("eslint_d") then
      return js_tools.check_eslint_config()
    end

    return js_formatter ~= ""
  end

  return true
end

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = not should_use_efm_formatter()
    set_lsp_config(client, bufnr)
  end
}

lspconfig.efm.setup {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = should_use_efm_formatter()
    set_lsp_config(client, bufnr)
  end,
  default_config = {
    cmd = {
      "efm-langserver",
      "-c",
      [["$HOME/.config/efm-langserver/config.yaml"]]
    }
  },
  settings = {
    languages = {
      javascript = {js_config},
      javascriptreact = {js_config},
      ["javascript.jsx"] = {js_config},
      typescript = {js_config},
      ["typescript.tsx"] = {js_config},
      typescriptreact = {js_config},
      markdown = {md_config}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "markdown"
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
