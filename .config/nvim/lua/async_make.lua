local M = {}

local function has_non_whitespace(str)
  return str:match("[^%s]")
end

local function fill_qflist(lines)
  vim.fn.setqflist({}, "a", {
    title = vim.bo.makeprg,
    lines = vim.tbl_filter(has_non_whitespace, lines),
    efm = vim.bo.errorformat
  })

  vim.api.nvim_command("doautocmd QuickFixCmdPost")
end

local function onread(err, data)
  if err then
    local echoerr = "echoerr '%s'"
    vim.api.nvim_command(echoerr:format(err))
  elseif data then
    local lines = vim.split(data, "\n")
    fill_qflist(lines)
  end
end

function M.make()
  local makeprg = vim.bo.makeprg
  local cmd = vim.fn.expandcmd(makeprg)
  local program, args = string.match(cmd, "([^%s]+)%s(.+)")

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  handle, pid = vim.loop.spawn(program, {
    args = vim.split(args, ' '),
    stdio = { stdout, stderr }
  },
  function(code, signal)
    stdout:read_stop()
    stdout:close()
    stderr:read_stop()
    stderr:close()
    handle:close()
  end
  )

  if vim.fn.getqflist({title = ''}).title == makeprg then
    vim.fn.setqflist({}, "r")
  else
    vim.fn.setqflist({}, " ")
  end

  stderr:read_start(vim.schedule_wrap(onread))
  stdout:read_start(vim.schedule_wrap(onread))
end

return M
