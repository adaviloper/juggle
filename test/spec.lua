vim.opt.runtimepath:append('./vendor/plenary.nvim/')
vim.opt.runtimepath:append('./vendor/matcher_combinators.lua/')
vim.opt.runtimepath:append('./vendor/nvim-treesitter/')
vim.opt.runtimepath:append('./vendor/tree-sitter-parsers')
vim.opt.runtimepath:append('../')

vim.cmd([[runtime plugin/plenary.vim]])

require('plenary.busted')
require('matcher_combinators.luassert')

require("nvim-treesitter.configs").setup({
  parser_install_dir = "vendor/tree-sitter-parsers",  -- where your manually installed grammars are
  highlight = {
    enable = true,
  },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.php = {
  install_info = {
    url = "vendor/tree-sitter-parsers/php",
    files = { "php/src/parser.c", "php/src/scanner.cc" },
  },
}
parser_config.javascript = {
  install_info = {
    url = "vendor/tree-sitter-parsers/javascript",
    files = { "src/parser.c", "src/scanner.cc" },
  },
}
parser_config.typescript = {
  install_info = {
    url = "vendor/tree-sitter-parsers/typescript",
    files = { "typescript/src/parser.c", "typescript/src/scanner.cc" },
  },
}

for _, lang in ipairs({ "php", "javascript", "typescript" }) do
  print(lang)
  local ok, parser = vim.treesitter.language.add(lang)
  print("-- Ok: " .. vim.inspect(ok))
  print("-- Parser: " .. vim.inspect(parser))
  if not ok then
    print("Could not build parser for " .. lang)
  end
end

print(vim.inspect(vim.api.nvim_get_runtime_file("parser/*.so", true)))

-- configuring the plugin
require('juggle').setup()
