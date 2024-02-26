vim.loader.enable()

if vim.env.LSP == nil then
  vim.env.LSP = 'nvim'
  -- vim.env.LSP = 'coc'
end

require('rc.keymaps')
require('rc.plugin_manager')
require('rc.options')
require('rc.functions')

---- fern.vim
---- vim.keymap.set("n", "<Leader>df", ":Fern . -drawer<CR>")
---- vim.g['fern#default_hidden'] = 1
---- vim.g['fern#renderer'] = 'nerdfont'
---- vim.g['fern#renderer#nerdfont#indent_markers'] = 1
