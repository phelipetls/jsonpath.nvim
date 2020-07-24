local M = {}

local results = {}

function M.latexmk()
  local bufname = vim.fn.expand("%")
  handle, pid = vim.loop.spawn('latexmk', {
    args = { bufname }
  },
  function(code, signal)
    print("Latexmk stopped. Code: "..code.." Sinal: "..signal)
    handle:close()
  end
  )
  print("Latexmk is running. PID: "..pid..".")
end

function M.close_latexmk()
  if pid then
    vim.loop.kill(pid, 9)
  end
end

return M
