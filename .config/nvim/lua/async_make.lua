local M = {}

function M.make(arg)
  local lines = {""}
  local winnr = vim.fn.win_getid()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  local makeprg = vim.api.nvim_buf_get_option(bufnr, "makeprg")
  if not makeprg then
    return
  end

  local args = vim.fn.expand(arg)
  local cmd = vim.fn.expandcmd(makeprg) .. " " .. args

  local timer = vim.loop.new_timer()
  local i = 0
  timer:start(0, 1000, vim.schedule_wrap(function()
    vim.g.async_make_status = 'Loading' .. string.rep(".", i % 3 + 1)
    i = i + 1
  end))

  local function on_event(_, data, event)
    if event == "stdout" or event == "stderr" then
      if data then
        vim.list_extend(lines, data)
      end
    end

    local ok, efm = pcall(vim.api.nvim_buf_get_option, bufnr, "errorformat")
    efm = not ok and vim.o.errorformat or efm

    if event == "exit" then
      vim.fn.setqflist(
        {},
        " ",
        {
          title = cmd,
          lines = lines,
          efm = efm
        }
      )

      vim.g.async_make_status = ''
      timer:stop()

      vim.api.nvim_command("doautocmd QuickFixCmdPost")
    end
  end

  vim.fn.jobstart(
    cmd,
    {
      on_stderr = on_event,
      on_stdout = on_event,
      on_exit = on_event,
      stdout_buffered = true,
      stderr_buffered = true
    }
  )
end

return M
