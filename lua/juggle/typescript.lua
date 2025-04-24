local utils = require "utils"
---@class TypescriptJuggle
---@field toggle_arrow_function_under_cursor function
local M = {}

local ts = vim.treesitter
local query = vim.treesitter.query

local function get_nodes(match, q)
    local body_node, param_node, type_node

    for id, matched_node in pairs(match) do
      local name = q.captures[id]
      if name == "body" then
        body_node = matched_node[1]
      elseif name == "return_type" then
        type_node = matched_node[1]
      elseif name == "params" then
        param_node = matched_node[1]
      end
    end

  return body_node, param_node, type_node
end

M.queries = {
  arrow_function = {
    query = query.parse("typescript", [[
    (arrow_function
      parameters: (formal_parameters) @params
      return_type: (type_annotation)* @return_type
      body: (_) @body)
    ]]),
    callback = function(buf, node, match, row, col)
      local arrow_function_node = node -- since we walked up to it
      local body_node, param_node, type_node = get_nodes(match, M.queries.arrow_function.query)

      -- Check if cursor is inside the body node
      local start_row, start_col, end_row, end_col = body_node:range()

      if utils.cursor_in_node(arrow_function_node, row, col) then
        local body_type = body_node:type()
        local type = type_node and vim.treesitter.get_node_text(type_node, buf) or ""
        local _, _, _, param_end_col = param_node:range()

        if body_type ~= "statement_block" then
          -- Concise → Block
          local expr = vim.treesitter.get_node_text(body_node, buf)
          local expr_lines = vim.split(expr, "\n")
          local output = {
            "{",
          }
          if #expr_lines > 1 then
            expr_lines[1] = 'return {'
            expr_lines[#expr_lines] = '};'

            for _, key_val in ipairs(expr_lines) do
              table.insert(output, key_val)
            end
          else
            table.insert(output, "  return " .. expr .. ";")
          end
          table.insert(output, "}")
          vim.api.nvim_buf_set_text(buf, start_row, start_col, end_row, end_col, output)
          vim.cmd('norm =af')
        else
          -- Block → Concise
          for child in body_node:iter_children() do
            if child:type() == "return_statement" and child:child(1) then
              local expr = vim.treesitter.get_node_text(child:child(1), buf)

              local expr_lines = vim.split(expr, "\n")
              local output = {
              }
              if #expr_lines > 1 then
                expr_lines[1] = '({'
                expr_lines[#expr_lines] = '})'
                for _, key_val in ipairs(expr_lines) do
                  table.insert(output, key_val)
                end
              else
                table.insert(output, expr)
              end

              vim.api.nvim_buf_set_text(buf, start_row, start_col, end_row, end_col, output)
              vim.cmd('norm =af')
              return
            end
          end
        end

        return
      end
    end
  }
}

return M

