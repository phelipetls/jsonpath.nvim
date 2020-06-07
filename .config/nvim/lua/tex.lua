local M = {}

local results = {}

local function onread(err, data)
  if err then
    table.insert(results, err)
  end
  if data then
    table.insert(results, data)
  end
  vim.fn.setqflist({}, "r", { title = "Latexmk", lines = results })
end

function M.latexmk()
  local bufname = vim.fn.expand("%")
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  handle, pid = vim.loop.spawn('latexmk', {
    args = { bufname },
    stdio = { stdout, stderr }
  },
  function(code, signal)
    print("Latexmk stopped. Code: "..code.." Sinal: "..signal)
    handle:close()
    stdout:read_stop()
    stderr:read_stop()
  end
  )
  stdout:read_start(vim.schedule_wrap(onread))
  stderr:read_start(vim.schedule_wrap(onread))
  print("Latexmk is running. PID: "..pid..".")
end

function M.close_latexmk()
  if pid then
    vim.loop.kill(pid, 9)
  end
end

return M
