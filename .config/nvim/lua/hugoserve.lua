local M = {}

function M.run(arg)
  local lines = {""}
  local winnr = vim.fn.win_getid()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  if not vim.fn.executable("hugo") then
    vim.api.nvim_command("echoerr 'Hugo is not installed'")
  end

  local program = "hugo serve"
  vim.api.nvim_command("compiler hugo")

  local args = vim.fn.expand(arg)
  local cmd = string.format("%s %s", program, args)

  local function on_event(job_id, data, event)
    if event == "stdout" or event == "stderr" then
      if data then
        vim.list_extend(lines, data)
        vim.fn.setloclist(winnr, {}, " ", {
          title = "Hugo",
          lines = lines,
          efm = vim.api.nvim_buf_get_option(bufnr, "errorformat")
        })
        vim.api.nvim_command("doautocmd QuickFixCmdPost")
        vim.api.nvim_command("exe mode() != 'i' ? 'lbottom' : ''")
      end
    end
  end

  vim.fn.jobstart(
    cmd,
    {
      on_stderr = on_event,
      on_stdout = on_event,
      on_exit = on_event,
    }
  )

  vim.api.nvim_command("echomsg 'Running on http://localhost:1313'")
end

return M

