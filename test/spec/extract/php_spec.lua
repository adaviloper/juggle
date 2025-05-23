local eq = assert.are.same
local buffer_utils = require("utils.buffer")

local function close_buffer(bufnr)
	local current_buf = vim.api.nvim_get_current_buf()
	if bufnr ~= current_buf then
		vim.api.nvim_set_current_buf(bufnr)
	end

	vim.api.nvim_buf_delete(bufnr, { force = true })
end

describe("extract variable", function()
	local test_cases = {
		{
			start_col = 7,
			motion = "vel",
			file = "extract_variable",
			expected_var = "$bar = 'bar';",
			expected_assignment = "$foo = $bar;",
		},
		{
			start_col = 7,
			motion = "vE",
			file = "extract_variable_partial",
			expected_var = "$bar = 'bar';",
			expected_assignment = "$foo = $bar . ' acme';",
		},
		{
			start_col = 7,
			motion = "v$hh",
			file = "extract_variable_partial",
			expected_var = "$bar = 'bar' . ' acme';",
			expected_assignment = "$foo = $bar;",
		},
	}

	for idx, case in ipairs(test_cases) do
		it("extracts a highlighted region into its own variable [index: " .. idx .. "]", function()
			local bufnr, win_id = buffer_utils.load_stub_to_buffer("extract/php/" .. case.file .. ".php")
			vim.api.nvim_set_current_buf(bufnr)
			vim.api.nvim_win_set_cursor(win_id, { 3, case.start_col })
			local original_ui_input = vim.ui.input

			vim.ui.input = function(opts, on_confirm)
				assert.is_truthy(opts.prompt)
				on_confirm("bar")
			end
			vim.cmd("norm " .. case.motion)

			vim.cmd("Extract variable")

			local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

			eq({
				"<?php",
				"",
				case.expected_var,
				case.expected_assignment,
				"",
			}, new_lines)

			vim.ui.input = original_ui_input
			close_buffer(bufnr)
		end)
	end
end)
