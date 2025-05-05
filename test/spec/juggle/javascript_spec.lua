local eq = assert.are.same
local buffer_utils = require('utils.buffer')

describe("arrow function to block function", function()
  after_each(function ()
    vim.cmd('bd')
  end)

  it("updates syntax", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/javascript/arrow_function_syntax.js")
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

  it("updates syntax when there is a single parameter with no parentheses", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/javascript/arrow_function_syntax_single_param.js")
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_win_set_cursor(win_id, { 1, 19 })

    vim.cmd('ToggleSyntax')

    -- Get buffer content
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Assert it changed
    eq(
      {
        "const foo = n => {",
        "  return n * 8;",
        "};",
        "",
      },
      new_lines
    )
  end)
end)

describe("block function to arrow function", function()
  it("updates syntax", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/javascript/block_function_syntax.js")
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

  it("updates syntax when there is a single parameter with no parentheses", function ()
    local bufnr, win_id = buffer_utils.load_stub_to_buffer("juggle/javascript/block_function_syntax_single_param.js")
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_win_set_cursor(win_id, { 1, 19 })

    vim.cmd('ToggleSyntax')

    -- Get buffer content
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Assert it changed
    eq(
      {
        "const foo = n => n * 8;",
        "",
      },
      new_lines
    )
  end)
end)


