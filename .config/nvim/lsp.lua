vim.lsp.stop_client(vim.lsp.buf_get_clients())

local nvim_lsp = require'nvim_lsp'
local util = require'nvim_lsp/util'
local configs = require'nvim_lsp/configs'

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = false,
  }
)

local function set_lsp_config(_)
  vim.api.nvim_command [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
  vim.api.nvim_command [[setlocal signcolumn=yes]]
  vim.api.nvim_command [[nnoremap <buffer><silent> K :lua vim.lsp.buf.hover()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> gd :lua vim.lsp.buf.definition()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> [<C-d> :lua vim.lsp.buf.definition()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> <C-w><C-d> :split <bar> lua vim.lsp.buf.definition()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> gr :lua vim.lsp.buf.references()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> gs :lua vim.lsp.buf.workspace_symbol()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer> gR :lua vim.lsp.buf.rename()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer> <M-CR> :lua vim.lsp.buf.code_action()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> <C-space> :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> ]g :lua vim.lsp.diagnostic.goto_next()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> [g :lua vim.lsp.diagnostic.goto_prev()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> <space>d :lua vim.lsp.diagnostic.set_loclist()<CR>]]
end

nvim_lsp.pyls.setup {
  on_attach = set_lsp_config,
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

nvim_lsp.tsserver.setup{
  on_attach = set_lsp_config;
  root_dir = function(fname)
    return util.find_package_json_ancestor(fname) or
           util.find_git_ancestor(fname) or
           vim.loop.os_homedir()
  end;
}

nvim_lsp.r_language_server.setup{
  on_attach=set_lsp_config;
}
