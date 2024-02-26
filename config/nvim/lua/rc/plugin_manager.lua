local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- require("lazy").setup({
--   'tpope/vim-rails',

--   -- { 'lambdalisue/fern.vim',                        },
--   -- { 'lambdalisue/fern-renderer-nerdfont.vim',      dependencies = { 'lambdalisue/fern.vim' }},
--   -- { 'lambdalisue/nerdfont.vim',                    dependencies = 'lambdalisue/fern.vim'},

--   -- quickrun
--   'thinca/vim-quickrun',
--   -- async quickrun
--   {
--     'Shougo/vimproc.vim',
--     run = 'make'
--   },
--   -- quickrun plugin
--   {
--     'osyo-manga/shabadou.vim',
--     dependencies = 'thinca/vim-quickrun'
--   },

--   {
--     "folke/trouble.nvim",
--     dependencies = { "nvim-tree/nvim-web-devicons" },
--     opts = {
--       -- your configuration comes here
--       -- or leave it empty to use the default settings
--       -- refer to the configuration section below
--     }
--   }
-- })
