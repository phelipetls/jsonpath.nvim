local M = {}

local function exists_package_json_field(field)
  if vim.fn.filereadable("package.json") ~= 0 then
    local package_json = vim.fn.json_decode(vim.fn.readfile("package.json"))
    return package_json[field] ~= nil
  end
end

local function exists_glob(glob)
  return vim.fn.glob(glob) ~= ""
end

function M.prettier_config_exists()
  return exists_glob(".prettierrc*") or exists_package_json_field("prettier")
end

function M.eslint_config_exists()
  return exists_glob(".eslintrc*") or exists_package_json_field("eslintConfig")
end

function M.get_js_formatter()
  if M.prettier_config_exists() and vim.fn.executable("prettier_d")  then
    return "prettier_d --parser=typescript"
  end

  if M.eslint_config_exists() and vim.fn.executable("eslint_d")  then
    return "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}"
  end

  return ""
end

return M
