local eq = assert.are.same
local buffer_utils = require('utils.buffer')

describe("setup", function()
  it("updates arrow function syntax to block function syntax", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/typescript/arrow_function_syntax.ts")
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_win_set_cursor(win_id, { 1, 19 })

    vim.cmd('ToggleSyntax')

    -- Get buffer content
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Assert it changed
    eq(
      {
        "const foo = () => {",
        "  return 5 * 8;",
        "};",
        "",
      },
      new_lines
    )
  end)

  it("updates block function syntax to arrow function syntax", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/typescript/block_function_syntax.ts")
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_win_set_cursor(win_id, { 2, 3 })

    vim.cmd('ToggleSyntax')

    -- Get buffer content
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Assert it changed
    eq(
      {
        "const foo = () => 5 * 8;",
        "",
      },
      new_lines
    )
  end)
end)


