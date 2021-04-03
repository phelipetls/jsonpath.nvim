local M = {}

local lspconfig = require "lspconfig"

local function exists_package_json_field(field)
  if vim.fn.filereadable("package.json") == 1 then
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

local function read_json_with_comments(json_file)
  local json_without_comments = vim.tbl_map(remove_comments, vim.fn.readfile(json_file))
  return vim.fn.json_decode(json_without_comments)
end

local function find_tsconfig_root_dir()
  local current_file_fullpath = vim.fn.expand("%:p")
  -- Return early for fugitive:// files, for example
  if not vim.startswith(current_file_fullpath, os.getenv("HOME")) then
    return
  end
  local root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json")(current_file_fullpath)
  if root_dir then
    return root_dir
  end
end

local function find_file(fname, path)
  local found = vim.fn.findfile(fname, path or "")
  if found ~= "" then
    return vim.fn.fnamemodify(found, ":p")
  end
end

local function find_dir(fname, path)
  local found = vim.fn.finddir(fname, path or "")
  if found ~= "" then
    return vim.fn.fnamemodify(found, ":p")
  end
end

local function get_tsconfig_file()
  local root_dir = find_tsconfig_root_dir()

  if not root_dir then
    return
  end

  return find_file("tsconfig.json", root_dir) or find_file("jsconfig.json", root_dir)
end

-- Memoizes the result of a function that takes a tsconfig filename
local function once_per_config(fn)
  local values_per_config = {}
  return function(tsconfig, ...)
    if not tsconfig then
      return
    end
    if vim.tbl_contains(vim.tbl_keys(values_per_config), tsconfig) then
      return values_per_config[tsconfig]
    end
    local value = fn(tsconfig, ...)
    values_per_config[tsconfig] = value
    return value
  end
end

local function path_exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

-- Expand the parent directory accessors in a relative filename.
local function expand_parentdir(dir, relative_fname)
  local fname, parentdir_count = relative_fname:gsub("%.%./", "")
  local parentdir_path = vim.fn.fnamemodify(dir, string.rep(":h", parentdir_count))
  return vim.fn.simplify(parentdir_path .. "/" .. fname)
end

local function expand_tsconfig_extends(extends, tsconfig_dir)
  if not extends or vim.startswith(extends, "@") then
    return
  end

  if vim.startswith(extends, "..") then
    return expand_parentdir(tsconfig_dir, extends)
  end

  return vim.fn.simplify(tsconfig_dir .. "/" .. extends)
end

-- Get all possible configured `.compilerOptions.paths` values by walking
-- through all tsconfig.json files recursively. If it finds a base
-- configuration (`.extends` key), it will continue to search there.
-- See https://www.typescriptlang.org/docs/handbook/module-resolution.html#path-mapping.
local function get_tsconfig_paths(tsconfig, old_alias_to_path)
  local alias_to_path = old_alias_to_path or {}

  if not tsconfig then
    return alias_to_path
  end

  local json = read_json_with_comments(tsconfig)
  local tsconfig_dir = vim.fn.fnamemodify(tsconfig, ":h")

  if json and json.compilerOptions and json.compilerOptions.paths then
    local base_url = json.compilerOptions.baseUrl

    for alias, paths in pairs(json.compilerOptions.paths) do
      for _, path in pairs(paths) do
        local path_without_wildcard = path:gsub("*", "")
        local full_path = tsconfig_dir .. "/" .. base_url .. "/" .. path_without_wildcard
        alias_to_path[alias] = vim.fn.simplify(full_path)
      end
    end
  end

  -- If tsconfig has a `.extends` field, we must search there too.
  local tsconfig_extends = expand_tsconfig_extends(json.extends, tsconfig_dir)

  if tsconfig_extends then
    get_tsconfig_paths(tsconfig_extends, alias_to_path)
  end

  return alias_to_path
end

local memo_get_tsconfig_paths = once_per_config(get_tsconfig_paths)

-- Get `.include` array from a tsconfig.json file as comma separated string.
local function get_tsconfig_include(tsconfig)
  if not tsconfig then
    return
  end
  local json = read_json_with_comments(tsconfig)
  if json.include then
    return table.concat(json.include, ",")
  end
  return ""
end

local memo_get_tsconfig_include = once_per_config(get_tsconfig_include)

function M.get_tsconfig_include()
  return memo_get_tsconfig_include(get_tsconfig_file())
end

local function expand_tsconfig_alias(fname)
  local alias_to_path = memo_get_tsconfig_paths(get_tsconfig_file())

  if not alias_to_path then
    return fname
  end

  for alias, path in pairs(alias_to_path) do
    local alias_without_wildcard = alias:gsub("*", "")
    if vim.startswith(fname, alias_without_wildcard) then
      local real_path = find_file(fname:gsub(alias, path))
      if real_path then
        return real_path
      end
    end
  end

  return fname
end

local function expand_fname(fname)
  if vim.startswith(fname, "..") then
    return expand_parentdir(vim.fn.expand("%:p:h"), fname)
  end

  if vim.startswith(fname, ".") then
    return fname
  end

  return expand_tsconfig_alias(fname)
end

local function find_index_file(fname)
  if vim.fn.isdirectory(fname) then
    return find_file("index", fname)
  end
end

local function find_component(fname)
  if vim.fn.isdirectory(fname) then
    local component_name = vim.fn.fnamemodify(fname, ":t:r")
    return find_file(component_name, fname)
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
--
-- It will replace the tilde in '~/components/App' with
-- '<compilerOptions.baseUrl>/src/components/App'.
--
-- It also tries to find a file with the same name as the folder (e.g.,
-- components) or index files.
function M.js_includeexpr(fname)
  fname = expand_fname(fname)
  return find_component(fname) or find_index_file(fname) or fname
end

function M.go_to_file(cmd)
  local fname = expand_fname(vim.fn.expand("<cfile>"))

  local found = find_component(fname) or find_index_file(fname) or find_file(fname) or fname

  if path_exists(found) then
    vim.cmd(string.format("silent %s %s", cmd, found))
  else
    vim.cmd [[echohl WarningMsg]]
    vim.cmd(string.format("echo '%s'", "Failed to find " .. found))
    vim.cmd [[echohl None]]
  end
end

return M
