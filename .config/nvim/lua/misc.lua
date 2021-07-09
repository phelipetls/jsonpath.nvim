local M = {}

function M.once(fn)
  local value
  return function(...)
    if not value then
      value = fn(...)
    end
    return value
  end
end

return M
