local eq = assert.are.same

local function load_stub_to_buffer(path)
  local full_path = vim.fn.getcwd() .. "/../stubs/" .. path
  local lines = {}
  for line in io.lines(full_path) do
    table.insert(lines, line)
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_name(bufnr, vim.fn.fnamemodify(full_path, ":p"))

  local win_id = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = 80,
    height = 10,
    row = 3,
    col = 25,
    style = "minimal",
  })

  return bufnr, win_id
end


describe("setup", function()
  it("updates arrow function syntax to block function syntax", function ()
    local bufnr, win_id = load_stub_to_buffer("javascript/arrow_function_syntax.js")
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
    local bufnr, win_id = load_stub_to_buffer("javascript/block_function_syntax.js")
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


