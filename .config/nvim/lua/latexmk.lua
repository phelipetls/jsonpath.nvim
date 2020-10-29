local M = {}

local results = {}

function M.run()
  local winnr = vim.fn.win_getid()
  local bufname = vim.fn.expand("%")

  vim.api.nvim_command("compiler latexmk")

  local lines = {}

  local function on_event(job_id, data, event)
    if event == "stdout" or event == "stderr" then
      vim.fn.setloclist(winnr, {}, "a", {
          title = "Latexmk",
          lines = data,
          efm = vim.api.nvim_buf_get_option(bufnr, "errorformat")
        }
      )
    end
  end

  local pid =
    vim.fn.jobstart(
    string.format("latexmk -pvc %s", bufname),
    {
      on_stdout = on_event,
      on_stderr = on_event,
    }
  )

  vim.api.nvim_command("command! StopCompile call jobclose(" ..pid.. ")")

  print("Latexmk is running. PID: "..pid)
end

return M
