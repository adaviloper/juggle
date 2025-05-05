local eq = assert.are.same
local buffer_utils = require('utils.buffer')

describe("setup", function()
  it("updates class property accessor to array accessor for property under cursor", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/php/class_syntax.php")
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_win_set_cursor(win_id, { 3, 25 })

    vim.cmd('ToggleSyntax')

    -- Get buffer content
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Assert it changed
    eq({
      "<?php",
      "",
      "$bar = (new stdClass)['bar'];",
      "",
    }, new_lines)
  end)

  it("updates array accessor to class property accessor for property under cursor", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/php/array_syntax.php")
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_win_set_cursor(win_id, { 3, 25 })

    vim.cmd('ToggleSyntax')

    -- Get buffer content
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Assert it changed
    eq({
      "<?php",
      "",
      "$bar = (new stdClass)->bar;",
      "",
    }, new_lines)
  end)
end)

