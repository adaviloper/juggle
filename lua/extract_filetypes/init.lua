local buf_utils = require('core.buf_utils')
local function pos_is_before(a, b)
  return a[2] < b[2] or (a[2] == b[2] and a[3] <= b[3])
end

local M = {}

M.extract = function (opts)
  local extraction_type = opts.args
  local buf = vim.api.nvim_get_current_buf() or 0
  local lang = buf_utils.get_lang_from_buf(buf)

  local start_pos = vim.fn.getpos(".")
  local end_pos = vim.fn.getpos("v")

  if not pos_is_before(start_pos, end_pos) then
    start_pos, end_pos = end_pos, start_pos
  end

  local start_row = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3]

  local extract_ft = require('extract_filetypes.' .. lang)

  vim.ui.input({
    prompt= "Rename " .. extraction_type .. " to:",
  }, function (name)
      if not name then return end

      -- Get the selected text
      local lines = vim.api.nvim_buf_get_text(buf, start_row, start_col, end_row, end_col, {})
      local selected_text = table.concat(lines, "\n")

      -- Insert the new variable assignment above the current line
      local var_name = extract_ft.prep_variable(name)
      local assignment_line = string.format(extract_ft[extraction_type].format, var_name, selected_text)
      vim.api.nvim_buf_set_lines(buf, start_row, start_row, false, { assignment_line })

      -- Replace the selection with the new variable name
      vim.api.nvim_buf_set_text(buf, start_row + 1, start_col, end_row + 1, end_col, { var_name })
    end)
end

return M
