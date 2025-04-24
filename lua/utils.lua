local M = {}

M.cursor_in_node = function (node, cursor_row, cursor_col)
  local sr, sc, er, ec = node:range()
  return (cursor_row > sr or (cursor_row == sr and cursor_col >= sc)) and
         (cursor_row < er or (cursor_row == er and cursor_col <= ec))
end

return M

