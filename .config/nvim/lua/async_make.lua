local M = {}

local function populate_loclist(lines, bufnr)
  local makeprg = vim.api.nvim_buf_get_option(bufnr, "makeprg")
  local efm = vim.api.nvim_buf_get_option(bufnr, "errorformat")
  vim.fn.setloclist(winnr, {}, "r", {
    title = makeprg,
    lines = lines,
    efm = efm
  })
  vim.api.nvim_command("doautocmd QuickFixCmdPost")
end

local function on_event(job_id, data, event)
  if event == "stdout" or event == "stderr" then
    if data then
      vim.list_extend(lines, data)
    end
  end

  if event == "exit" then
    populate_loclist(lines, bufnr)
  end
end

function M.make()
  lines = {""}
  winnr = vim.fn.win_getid()
  bufnr = vim.api.nvim_win_get_buf(winnr)

  local makeprg = vim.api.nvim_buf_get_option(bufnr, "makeprg")
  if not makeprg then return end

  local cmd = vim.fn.expandcmd(makeprg)

  local job_id =
    vim.fn.jobstart(
    cmd,
    {
      on_stderr = on_event,
      on_stdout = on_event,
      on_exit = on_event,
      stdout_buffered = true,
      stderr_buffered = true,
    }
  )
end

return M
