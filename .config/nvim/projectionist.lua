global_projections = {["*"] = {}}

local function update_projectionist(projections)
  for pattern, projection in pairs(projections) do
    global_projections["*"][pattern] = projection
  end
end

for _, extension in ipairs({"js", "jsx", "ts", "tsx"}) do
  update_projectionist(
    {
      ["*." .. extension] = {
        alternate = {"{basename}.test." .. extension, "{dirname}/__tests__/{basename.test}." .. extension},
        type = "source"
      },
      ["*.test." .. extension] = {
        alternate = "{basename}." .. extension,
        type = "test"
      },
      ["**/__tests__/*.test" .. extension] = {
        alternate = "{dirname}/{basename}." .. extension
      }
    }
  )
end

vim.g.projectionist_heuristics = global_projections
