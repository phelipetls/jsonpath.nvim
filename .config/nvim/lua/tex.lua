local M = {}

function M.latexmk()
  local bufname = vim.fn.expand("%")
  handle, pid = vim.loop.spawn('latexmk', {
    args = { bufname }
  },
  function(code, signal) -- on exit
    print("Latexmk stopped. Code: "..code.." Sinal: "..signal)
    handle:close()
  end
  )
  print("Latexmk is running. PID: "..pid..".")
end

function M.close_latexmk()
  vim.loop.kill(pid, 9)
end

return M
