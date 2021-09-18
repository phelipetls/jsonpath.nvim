local M = {}

local baseUrl = 'https://gitlab.com/api/v4'

local function echoerr(msg)
  vim.cmd('echohl WarningMsg')
  vim.cmd(string.format('echomsg "%s"', msg))
  vim.cmd('echohl None')
end

local function executable(program)
  local is_executable = vim.fn.executable(program) == 1
  if not is_executable then
    vim.cmd('echohl WarningMsg')
    vim.cmd(string.format('echomsg "%s is required"', program))
    vim.cmd('echohl None')
  end
  return is_executable
end

local function get_merge_request_by_source_branch(source)
  if not executable('curl') then
    return
  end

  local authToken = vim.fn.system('pass show gitlab-token')
  if vim.v.shell_error > 1 or not authToken then
    echoerr('A private token is required')
    return
  end

  local privateTokenHeader = string.format('"PRIVATE-TOKEN: %s"', authToken:gsub('\n', ''))

  local url = baseUrl .. '/merge_requests?source_branch=' .. source

  local cmd = 'curl --silent ' .. url .. ' --header ' .. privateTokenHeader
  local response = vim.fn.system(cmd)

  if vim.v.shell_error > 1 or not response then
    echoerr('Error')
    return
  end

  local json = vim.fn.json_decode(response)

  if json then
    return json
  end

  echoerr('Could not find a merge request with source branch set to ' .. source)
end

function M.open_mr(target_branch)
  if not executable('firefox') then
    return
  end

  if not target_branch and vim.fn.exists('*fugitive#Head') == 0 then
    echoerr('vim-fugitive is required')
    return
  end

  local source_branch = target_branch or vim.fn['fugitive#Head']()

  local merge_requests = get_merge_request_by_source_branch(source_branch)

  local url

  if #merge_requests == 1 then
    url = merge_requests[1].web_url
  else
    local prompt_lines = {}

    for index, mr in pairs(merge_requests) do
      local prompt = string.format('%s: %s', index, mr.title)
      table.insert(prompt_lines, prompt)
    end

    local choice = tonumber(vim.fn.input({
      prompt = table.concat(prompt_lines, '\n') .. '\nPrompt: ',
    }))

    if not choice or choice > #merge_requests then
      echoerr('Not a valid input')
      return
    end

    url = merge_requests[choice].web_url
  end

  if url == '' then
    return
  end

  vim.fn.system('firefox ' .. url)
end

return M
