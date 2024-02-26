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

---- vim-quickrun
--vim.keymap.set("n", "<Leader>r", ":QuickRun<CR>")
---- vim.g['quickrun_config'] = {
----   "_" = {
----       "outputter" = "multi:buffer:quickfix",
----       "outputter/buffer/split" = ":botright 8px",
----       "runner" = "vimproc",
----       "runner/vimproc/updatetime" = 40,
----       "hook/close_quickfix/enable_hook_loaded" = 1,
----       "hook/close_quickfix/enable_success" = 1,
----       "hook/close_buffer/enable_failure" = 1,
----       "hook/close_buffer/enable_empty_data" = 1,
----       "hook/inu/enable" = 1,
----       "hook/inu/wait" = 20,
----   },
---- }
