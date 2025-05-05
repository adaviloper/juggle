local M = {}

M.load_stub_to_buffer = function(path)
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

return M
