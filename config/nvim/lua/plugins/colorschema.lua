return {
  -- 'cocopon/iceberg.vim',
  -- config = function()
  --   vim.cmd("colorscheme iceberg")
  -- end,

  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd("colorscheme tokyonight-night")
  end,
}
