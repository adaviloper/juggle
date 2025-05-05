local M = {}

M.get_lang_from_buf = function(buf)
   local ft = vim.bo[buf].filetype
   if ft == "" then
      local match = require("vim.filetype").match
      ft = match({
         buf = buf,
         filename = vim.api.nvim_buf_get_name(buf),
         contents = vim.api.nvim_buf_get_lines(buf, 0, -1, false),
      }) or ""
   end

   if vim.tbl_contains({ 'vue' }, ft) then
      return 'typescript'
   end

   return ft
end

return M
