local M = {}

local function remove_comments(line)
  return line:gsub("/%*.*%*/", ""):gsub("//.*", "")
end

local function decode_json_with_comments(json_file)
  local json_without_comments = vim.tbl_map(remove_comments, vim.fn.readfile(json_file))
  return vim.fn.json_decode(json_without_comments)
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
local function get_tsconfig_paths(tsconfig_fname, prev_base_url)
  if not tsconfig_fname then
    return {}
  end

  local alias_to_paths = {}

  local json = decode_json_with_comments(tsconfig_fname)
  local base_url = json and json.compilerOptions and json.compilerOptions.baseUrl or prev_base_url

  if json and json.compilerOptions and json.compilerOptions.paths then
    for alias, paths in pairs(json.compilerOptions.paths) do
      alias_to_paths[alias] =
        vim.tbl_map(
        function(path)
          return vim.fn.simplify(get_dir(tsconfig_fname) .. "/" .. base_url .. "/" .. path:gsub("*", ""))
        end,
        paths
      )
    end
  end

  local tsconfig_extends = find_tsconfig_extends(json.extends, tsconfig_fname)

  return vim.tbl_extend("force", alias_to_paths, get_tsconfig_paths(tsconfig_extends, base_url))
end

-- Get `.include` array from a tsconfig.json file as comma separated string.
local function get_tsconfig_include(tsconfig)
  if not tsconfig then
    return
  end
  local json = decode_json_with_comments(tsconfig)
  if json.include then
    return table.concat(json.include, ",")
  end
  return ""
end

function M.get_tsconfig_include()
  return get_tsconfig_include(get_tsconfig_file())
end

local function expand_tsconfig_path(input)
  local tsconfig_file = get_tsconfig_file()

  if not tsconfig_file then
    return input
  end

  local alias_to_paths = get_tsconfig_paths(tsconfig_file)

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

  path = find_file(path) or find_dir(path)

  if vim.fn.isdirectory(path) == 1 then
    path = find_file("index", path) or path
  end

  return path
end

return M
