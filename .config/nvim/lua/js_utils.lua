local M = {}

function M.prettier_config_exists()
  local prettierrc = vim.fn.glob(".prettierrc*", 0, 1)

  if not vim.tbl_isempty(prettierrc) then
    return true
  end

  if vim.fn.filereadable("package.json") ~= 0 then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["prettier"] then
      return true
    end
  end

  return false
end

function M.eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") ~= 0 then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

return M
