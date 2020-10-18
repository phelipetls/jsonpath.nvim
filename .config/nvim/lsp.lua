vim.lsp.stop_client(vim.lsp.buf_get_clients())

local nvim_lsp = require'nvim_lsp'
local util = require'nvim_lsp/util'
local configs = require'nvim_lsp/configs'

local severity_map = { "E", "W", "I", "H" }

local parse_diagnostics = function(diagnostics)
  if not diagnostics then return end
  local items = {}
  for _, diagnostic in ipairs(diagnostics) do
    local fname = vim.fn.bufname()
    local position = diagnostic.range.start
    local severity = diagnostic.severity
    table.insert(items, {
      filename = fname,
      type = severity_map[severity],
      lnum = position.line + 1,
      col = position.character + 1,
      text = diagnostic.message:gsub("\r", ""):gsub("\n", " ")
    })
  end
  return items
end

update_diagnostics_loclist = function()
  bufnr = vim.fn.bufnr()
  diagnostics = vim.lsp.util.diagnostics_by_buf[bufnr]

  items = parse_diagnostics(diagnostics)
  vim.lsp.util.set_loclist(items)
end

vim.lsp.util.buf_diagnostics_signs = function() return end
vim.lsp.util.buf_diagnostics_virtual_text = function() return end
vim.lsp.util.buf_diagnostics_underline = function() return end

local function set_lsp_config(_)
  vim.api.nvim_command [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
  vim.api.nvim_command [[nnoremap <buffer><silent> K :lua vim.lsp.buf.hover()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> gd :lua vim.lsp.buf.definition()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> [<C-d> :lua vim.lsp.buf.definition()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> <C-w><C-d> :split <bar> lua vim.lsp.buf.definition()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> gs :lua vim.lsp.buf.signature_help()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer><silent> gr :lua vim.lsp.buf.references()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer> gR :lua vim.lsp.buf.rename()<CR>]]
  vim.api.nvim_command [[nnoremap <buffer> <M-CR> :lua vim.lsp.buf.code_action()<CR>]]
  vim.api.nvim_command [[let b:completion_command = "\<C-x>\<C-o>"]]
  vim.api.nvim_command [[if exists("#LintOnSave") | autocmd! LintOnSave | endif]]
  vim.api.nvim_command [[autocmd! User LspDiagnosticsChanged lua update_diagnostics_loclist()]]
  vim.api.nvim_command [[autocmd! BufWritePost <buffer> call OpenLocationList()]]
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
