local M = {}

local function remove_comments(line)
  return line:gsub("/%*.+%*/", ""):gsub("//.*", "")
end

local function decode_json_with_comments(fname)
  if vim.fn.filereadable(fname) == 0 then
    return nil
  end
  local file = vim.fn.readfile(fname)
  local json_without_comments = vim.tbl_map(remove_comments, file)
  local _, json = pcall(vim.fn.json_decode, json_without_comments)
  if json then
    return json
  end
end

local function find_file(fname, path)
  local found = vim.fn.findfile(fname, path or "")
  if found ~= "" then
    return found
  end
end

local function find_dir(fname, path)
  local found = vim.fn.finddir(fname, path or "")
  if found ~= "" then
    return found
  end
end

local function get_tsconfig_file()
  return find_file("tsconfig.json", ".;") or find_file("jsconfig.json", ".;")
end

local function get_dir(fname)
  return vim.fn.fnamemodify(fname, ":h")
end

local function find_tsconfig_extends(extends, tsconfig_fname)
  if not extends or vim.startswith(extends, "@") then
    return
  end

  local tsconfig_dir = get_dir(tsconfig_fname)
  return vim.fn.simplify(tsconfig_dir .. "/" .. extends)
end

-- Get all possible configured `.compilerOptions.paths` values by walking
-- through all tsconfig.json files recursively. If it finds a base
-- configuration (`.extends` key), it will continue to search there.
-- See https://www.typescriptlang.org/docs/handbook/module-resolution.html#path-mapping.
function M.get_tsconfig_paths(tsconfig_fname, prev_base_url)
  if not tsconfig_fname then
    return {}
  end

  local json = decode_json_with_comments(tsconfig_fname)

  if not json then
    return {}
  end

  local base_url = json.compilerOptions and json.compilerOptions.baseUrl or prev_base_url or ""

  local alias_to_paths = {}

  if json.compilerOptions and json.compilerOptions.paths then
    for alias, paths in pairs(json.compilerOptions.paths) do
      alias_to_paths[alias] = vim.tbl_map(function(path)
        return vim.fn.simplify(get_dir(tsconfig_fname) .. "/" .. base_url .. "/" .. path:gsub("*", ""))
      end, paths)
    end
  end

  local extends = json.extends
  local tsconfig_extends = find_tsconfig_extends(extends, tsconfig_fname)

  return vim.tbl_extend("force", alias_to_paths, M.get_tsconfig_paths(tsconfig_extends, base_url))
end

local strip_glob_patterns = function(glob_pattern)
  -- transform src/**/* into src/
  glob_pattern = glob_pattern:gsub("%*%*/%*$", "")

  -- transform src/* into src/
  glob_pattern = glob_pattern:gsub("%*$", "")

  return glob_pattern
end

-- Recursively collect `.include` array from a tsconfig.json files
local function get_tsconfig_include(tsconfig_fname)
  if not tsconfig_fname then
    return {}
  end

  local tsconfig = decode_json_with_comments(tsconfig_fname)
  local include = tsconfig and tsconfig.include

  if not include then
    return {}
  end

  local extends = tsconfig and tsconfig.extends
  local tsconfig_extends = find_tsconfig_extends(extends, tsconfig_fname)
  if tsconfig_extends then
    vim.list_extend(include, get_tsconfig_include(tsconfig_extends))
  end

  return vim.tbl_map(strip_glob_patterns, include)
end

function M.get_tsconfig_include()
  return get_tsconfig_include(get_tsconfig_file())
end

local function expand_tsconfig_path(input)
  local tsconfig_file = get_tsconfig_file()

  if not tsconfig_file then
    return input
  end

  local alias_to_paths = M.get_tsconfig_paths(tsconfig_file)

  if vim.tbl_isempty(alias_to_paths) then
    return input
  end

  for alias, paths in pairs(alias_to_paths) do
    if alias == "*" or vim.startswith(input, alias:gsub("*", "")) then
      for _, path in pairs(paths) do
        local expanded_path = input:gsub(alias, path)
        local real_path = find_file(expanded_path) or find_dir(expanded_path)

        if real_path then
          return real_path
        end
      end
    end
  end

  return input
end

function M.includeexpr(input)
  local path = expand_tsconfig_path(input)

  path = find_file(path) or find_dir(path) or input

  if vim.fn.isdirectory(path) == 1 then
    path = find_file("index", path) or path
  end

  return path
end

return M
