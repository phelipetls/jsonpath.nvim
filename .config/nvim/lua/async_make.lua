local M = {}

local function fill_qflist(lines, efm)
  vim.fn.setqflist({}, "a", {
    title = makeprg,
    lines = lines,
    efm = efm
  })
  vim.api.nvim_command("doautocmd QuickFixCmdPost")
end

local function onread(err, data)
  if data then
    local newlines = vim.split(data, "\n")
    lines[#lines] = lines[#lines] .. newlines[1]
    vim.list_extend(lines, {unpack(newlines, 2, #newlines)})
  end
end

function M.make()
  lines = {""}
  local makeprg = vim.bo.makeprg
  local efm = vim.bo.errorformat

  local cmd = vim.fn.expandcmd(makeprg)
  local program, args = string.match(cmd, "([^%s]+)%s(.+)")

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  handle, pid = vim.loop.spawn(program, {
    args = vim.split(args, ' '),
    stdio = { stdout, stderr }
  },
  vim.schedule_wrap(function(code, signal)
    stdout:read_stop()
    stdout:close()
    stderr:read_stop()
    stderr:close()
    handle:close()

    fill_qflist(lines, efm)
  end)
  )

  if vim.fn.getqflist({title = ''}).title == makeprg then
    vim.fn.setqflist({}, "r")
    vim.api.nvim_command("cclose")
  else
    vim.fn.setqflist({}, " ")
  end

  stdout:read_start(vim.schedule_wrap(onread))
  stderr:read_start(vim.schedule_wrap(onread))
end

return M
