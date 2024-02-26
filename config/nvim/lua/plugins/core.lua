return {
  {
    -- common utilities
    'nvim-lua/plenary.nvim',
    -- ecosystem to develop with deno
    {
      'vim-denops/denops.vim',
      lazy = false
    },
    {
      'toppair/peek.nvim',
      run = 'deno task --quiet build:fast'
    },
    -- surroundings operator, textobject
    {
      'machakann/vim-sandwich',
      event = 'ModeChanged'
    },
    -- indent line
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
      config = function()
        require("ibl").setup {}
        vim.opt.list = true
        vim.opt.listchars:append "eol:↴"
      end
    },
    -- color preview
    {
      'norcalli/nvim-colorizer.lua',
      event = 'BufRead',
      config = function()
        require('colorizer').setup()
      end
    },
    -- file icons
    { 'nvim-tree/nvim-web-devicons' },
    -- mode
    {
      'mvllow/modes.nvim',
      tag = 'v0.2.1',
      config = function()
        require('modes').setup({
          colors = {
            copy = '#FFEE55',
            delete = '#DC669B',
            insert = '#55AAEE',
            visual = '#DD5522',
          },
        })
      end
    },
  }
}
