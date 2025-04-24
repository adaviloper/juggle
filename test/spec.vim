set rtp^=./vendor/plenary.nvim/
set rtp^=./vendor/matcher_combinators.lua/
set rtp^=./vendor/nvim-treesitter/
set rtp^=../

runtime plugin/plenary.vim

lua require('plenary.busted')
lua require('matcher_combinators.luassert')

" configuring the plugin
runtime plugin/my_awesome_plugin.lua
lua require('juggle').setup({ name = 'Jane Doe' })
