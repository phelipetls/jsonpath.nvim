local M = {}

local js_pattern =
  [[((export\s*)?]] ..
  [[(default\s*)?]] ..
    [[(var|const|let|interface|type|class|(async\s*)?function)]] ..
      [[|(public|private|protected|readonly|static|get|set)]] ..
        [[|(export\s*default\s*abstract\s*class))\s*]] .. [[%s]]

local definition_patterns = {
  javascript = js_pattern,
  typescript = js_pattern,
  ["javascript.jsx"] = js_pattern,
  ["typescript.tsx"] = js_pattern,
  typescriptreact = js_pattern,
  javascriptreact = js_pattern
}

local function parse_rg_result(result)
  local fname_lnum_str = vim.fn.matchstr(result, "\\f\\+:\\d\\+")
  local fname_lnum = vim.split(fname_lnum_str, ":")

  local fname = fname_lnum[1]
  local lnum = fname_lnum[2]

  return "./" .. fname, lnum
end

-- Open file with a command like
local function gotofile(open_cmd, fname, lnum)
  local cmd = string.format("%s +%d %s", open_cmd or "edit", lnum, fname)
  vim.api.nvim_command(cmd)
end

local RG_OPTIONS = "--column --word-regexp"

function M.rg_find(open_cmd)
  local definition_pattern = definition_patterns[vim.bo.filetype]

  if not definition_pattern then
    print("Filetype not configured")
    return
  end

  local word_under_cursor = vim.fn.expand("<cword>")

  local cmd = string.format("rg %s '%s'", RG_OPTIONS, definition_pattern:format(word_under_cursor))
  local results = vim.fn.systemlist(cmd)

  if not results or vim.tbl_isempty(results) then
    print("No results found")
    return
  end

  local fname, lnum = parse_rg_result(results[1])
  gotofile(open_cmd, fname, lnum)

  if #results > 1 then
    vim.fn.setqflist(
      {}, " ", {
        title = string.format("ripgrep results for %s", word_under_cursor),
        lines = results,
        efm = "%f:%l:%c:%m"
      }
    )
    vim.api.nvim_command("doautocmd QuickFixCmdPost")
  end
end

return M
