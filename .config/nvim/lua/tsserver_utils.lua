local M = {}

function M.organize_imports()
  vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})
end

function M.rename_file(args)
  local old = args[1]
  local new = args[2]

  local old_uri = vim.uri_from_fname(old)
  local new_uri = vim.uri_from_fname(new)

  vim.lsp.buf_request(
    vim.fn.bufnr("#"),
    "workspace/executeCommand",
    {
      command = "_typescript.applyRenameFile",
      arguments = {
        {
          sourceUri = old_uri,
          targetUri = new_uri
        }
      }
    }
  )
end

return M
