local M = {}

local lspconfig = require "lspconfig"
local path_utils = require "path_utils"

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

function M.check_eslint_config()
  local current_file = vim.fn.expand("%")
  local exit_code = os.execute("eslint_d --print-config " .. current_file)
  return exit_code == 0
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

local function expand_tsconfig_extends(extends, tsconfig_dir)
  if not extends or vim.startswith(extends, "@") then
    return
  end

  if vim.startswith(extends, "../") then
    return path_utils.expand_parentdir(extends, tsconfig_dir)
  end

  return path_utils.path_join(tsconfig_dir, extends)
end

local function remove_wildcard(path)
  local str, _ = path:gsub("*", "")
  return str
end

-- Get all possible configured `.compilerOptions.paths` values by walking
-- through all tsconfig.json files recursively. If it finds a base
-- configuration (`.extends` key), it will continue to search there.
-- See https://www.typescriptlang.org/docs/handbook/module-resolution.html#path-mapping.
local function get_tsconfig_paths(tsconfig)
  local alias_to_path = {}

  if not tsconfig then
    return alias_to_path
  end

  local json = read_json_with_comments(tsconfig)
  local tsconfig_dir = vim.fn.fnamemodify(tsconfig, ":h")

  if json and json.compilerOptions and json.compilerOptions.paths then
    local base_url = json.compilerOptions.baseUrl

    for alias, paths in pairs(json.compilerOptions.paths) do
      for _, path in pairs(paths) do
        alias_to_path[alias] = path_utils.path_join(tsconfig_dir, base_url, remove_wildcard(path))
      end
    end
  end

  -- If tsconfig has a `.extends` field, we must search there too.
  local tsconfig_extends = expand_tsconfig_extends(json.extends, tsconfig_dir)

  if tsconfig_extends then
    return vim.tbl_extend("force", alias_to_path, get_tsconfig_paths(tsconfig_extends))
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
      local expanded_path = fname:gsub(alias, path)
      local real_path = find_file(expanded_path) or find_dir(expanded_path)
      if real_path then
        return real_path
      end
    end
  end

  return fname
end

local function expand_fname(fname)
  if vim.startswith(fname, "..") then
    return path_utils.expand_parentdir(fname, path_utils.get_current_file_dir())
  end

  if vim.startswith(fname, ".") then
    return path_utils.expand_curdir(fname)
  end

  return expand_tsconfig_alias(fname)
end

local function find_index_file(dir)
  return find_file("index", dir)
end

local function find_component(dir)
  local fname = vim.fn.fnamemodify(dir, ":h:t")
  return find_file(fname, dir)
end

local function get_file_under_cursor()
  return vim.fn.expand("<cfile>")
end

-- gf that understands tsconfig.json `.compilerOptions.paths`.
-- For example, if tsconfig.json has
-- {
--   "baseUrl": ".",
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
function M.go_to_file(cmd)
  local cfile = get_file_under_cursor()
  local fname = expand_fname(cfile)

  fname = find_file(fname) or find_dir(fname)

  if vim.fn.isdirectory(fname) == 1 then
    fname = find_component(fname) or find_index_file(fname) or fname
  end

  if path_utils.path_exists(fname) then
    vim.cmd(string.format("silent %s %s", cmd, fname))
  else
    vim.cmd [[echohl WarningMsg]]
    vim.cmd(string.format("echo '%s'", "Failed to find " .. cfile))
    vim.cmd [[echohl None]]
  end
end

return M
