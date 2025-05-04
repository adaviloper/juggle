---@class CustomModule
---@field toggle_arrow_function_under_cursor function
local M = {}

local ts = vim.treesitter

local function get_lang_from_buf(buf)
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

M.toggle_arrow_function_under_cursor = function()
   local buf = vim.api.nvim_get_current_buf() or 0
   local lang = get_lang_from_buf(buf)

   local parser, message = ts.get_parser(buf, lang, { error = false })
   if message ~= nil then
      print('Parser could not be created: ' .. message)
      return
   end
   local tree = parser:parse()[1]
   local root = tree:root()

   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
   row = row - 1 -- 0-based indexing

   local access_type = "member_access_expression"

   local queries = require('juggle_filetypes.' .. lang).queries


   local keyset={}
   local n=0

   for k,_ in pairs(queries) do
      n=n+1
      keyset[n]=k
   end

   -- Find the smallest node at the cursor
   local node = root:named_descendant_for_range(row, col, row, col)
   local original_node = node

   -- Ensure we found a node and it's an arrow_function
   if not node then
      print("No node found under cursor.")
      return
   end

   -- Walk up to the arrow_function node
   while node and not vim.tbl_contains(keyset, node:type()) do
      node = node:parent()
   end

   if not node then
      return
   end

   access_type = node:type()
   local q = queries[access_type].query

   for _, match, _ in q:iter_matches(node, buf) do
      queries[access_type].callback(buf, node, match, row, col)
   end
end

return M
