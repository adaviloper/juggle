local utils = require "utils"

---@class PhpJuggle
---@field toggle_arrow_function_under_cursor function
---@field queries table
local M = {}

local query = vim.treesitter.query

local function get_nodes(match, q)

   local prop_node

   for id, matched_node in pairs(match) do
      local name = q.captures[id]
      if name == "prop" then
         prop_node = matched_node[1]
      end
   end

   return prop_node
end

function exec(buf, node, match, row, col, expr_cb)

   local arrow_function_node = node -- since we walked up to it
   local prop_node = get_nodes(match, M.queries.member_access_expression.query)

   -- Check if cursor is inside the body node
   if utils.cursor_in_node(arrow_function_node, row, col) then
      -- property → array
      local expr, start_row, start_col, end_row, end_col = expr_cb(prop_node)

      vim.api.nvim_buf_set_text(buf, start_row, start_col, end_row, end_col, { expr })
   end
end

M.queries = {
   member_access_expression = {
      query = query.parse("php", [[
      (member_access_expression
        (name) @prop
        )
      ]]),
      callback = function(buf, node, match, row, col)
         exec(buf, node, match, row, col, function (prop_node)
            local start_row, start_col, end_row, end_col = prop_node:range()
            return "['" .. vim.treesitter.get_node_text(prop_node, buf) .. "']", start_row, start_col - 2, end_row, end_col

         end)
      end
   },
   subscript_expression = {
      query = query.parse("php", [[
      (subscript_expression
        (string
          (string_content) @prop
          )
        )
      ]]),
      callback = function(buf, node, match, row, col)
         exec(buf, node, match, row, col, function (prop_node)
            -- array → property
            if prop_node:type() == "string_content" then
               local expr = vim.treesitter.get_node_text(prop_node, buf)
               local start_row, start_col, end_row, end_col = prop_node:range()

               return "->" .. expr, start_row, start_col - 2, end_row, end_col + 2
            end
         end)
      end
   }
}

return M
