local M = {}

local function exists_package_json_field(field)
  if vim.fn.filereadable("package.json") ~= 0 then
    local package_json = vim.fn.json_decode(vim.fn.readfile("package.json"))
    return package_json[field] ~= nil
  end
end

local prettier_ignore = {
  vim.fn.expand("~/Mutual/mutual"),
  vim.fn.expand("~/Mutual/mutualapp"),
  vim.fn.expand("~/Mutual/mutualapp-alpha")
}

local function should_ignore_prettier()
  for _, dir in ipairs(prettier_ignore) do
    if dir == vim.fn.getcwd() then
      return true
    end
  end

  return false
end

local function exists_glob(glob)
  return vim.fn.glob(glob) ~= ""
end

function M.prettier_config_exists()
  if should_ignore_prettier() then
    return false
  end

  return exists_glob(".prettierrc*") or exists_package_json_field("prettier")
end

function M.eslint_config_exists()
  return exists_glob(".eslintrc*") or exists_package_json_field("eslintConfig")
end

function M.get_js_formatter()
  if M.prettier_config_exists() and vim.fn.executable("prettier_d") then
    return "prettier_d --parser=typescript"
  end

  if M.eslint_config_exists() and vim.fn.executable("eslint_d") then
    return "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}"
  end

  return ""
end

local function remove_comments(line)
  return line:gsub("/%*.*%*/", ""):gsub("//.*", "")
end

local function read_json_with_comments(file)
  local file_without_comments = vim.tbl_map(remove_comments, vim.fn.readfile(file))
  return vim.fn.json_decode(file_without_comments)
end

local function get_tsconfig_file()
  if vim.fn.filereadable("tsconfig.json") then
    return "tsconfig.json"
  end

  if vim.fn.filereadable("jsconfig.json") then
    return "jsconfig.json"
  end
end

local function once(fn)
  local value
  return function(...)
    if not value then
      value = fn(...)
    end
    return value
  end
end

-- Get all possible configured `.compilerOptions.paths` values by walking
-- through all tsconfig.json configuration recursively, e.g., if it find a base
-- configuration (in `.extends` key), it will continue to search there.
local function get_tsconfig_paths(tsconfig, old_paths)
  local new_paths = old_paths or {}
  local json = read_json_with_comments(tsconfig or get_tsconfig_file())

  if json and json.compilerOptions and json.compilerOptions.paths then
    for alias, path in pairs(json.compilerOptions.paths) do
      if not vim.tbl_contains(vim.tbl_keys(new_paths), alias) then
        new_paths[alias] = path[1]
      end
    end
  end

  if json and json.extends and vim.startswith(json.extends, ".") then
    get_tsconfig_paths(json.extends, new_paths)
  end

  return new_paths
end

local memo_get_tsconfig_paths = once(get_tsconfig_paths)

-- Get `.include` array from a tsconfig.json file as comma separated string.
local function get_tsconfig_include()
  local include = read_json_with_comments(get_tsconfig_file()).include
  if include then
    return table.concat(include, ",")
  end
end

local memo_get_tsconfig_include = once(get_tsconfig_include)

-- Helper function to include tsconfig's `.include` array inside `:h path`.
M.set_tsconfig_include_in_path = function()
  local include_paths = memo_get_tsconfig_include()
  if not include_paths then
    return
  end
  if not vim.bo.path:match(include_paths) then
    vim.bo.path = vim.bo.path .. "," .. include_paths
  end
end

-- includeexpr that understands tsconfig.json `.compilerOptions.paths`.
-- For example, if tsconfig.json has
-- {
--   "compilerOptions": {
--     "paths": {
--       "~/*": ["src/*"]
--     }
--   }
-- }
-- When you do gf in a string like '~/components/App', it will end up being
-- './src/components/App'.
function M.js_includeexpr(fname)
  local paths = memo_get_tsconfig_paths()

  if paths then
    for alias, path in pairs(paths) do
      if vim.startswith(fname, alias:gsub("*", "")) then
        local real_path = fname:gsub(alias, "./" .. path:gsub("*", ""))
        return real_path
      end
    end
  end

  return fname
end
return M
