vim.loader.enable()

if vim.env.LSP == nil then
  vim.env.LSP = 'nvim'
end

require('rc.keymaps')
require('rc.plugin_manager')
require('rc.options')
require('rc.functions')
require('rc.lsp_config')
