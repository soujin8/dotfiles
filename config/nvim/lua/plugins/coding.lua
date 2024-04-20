return {
  { 'mtdl9/vim-log-highlighting' },
  { 'tpope/vim-commentary' },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end,
    event = 'ModeChanged'
  },
  { 'nicwest/vim-camelsnek' },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    config = function()
      vim.keymap.set("n", "<Leader>md", ":MarkdownPreview<CR>")
    end
  },
  {
    'github/copilot.vim',
    config = function()
      -- yamlやmarkdown,gitcommitのときにもcopilotを有効にする
      vim.g.copilot_filetypes = { markdown = true, gitcommit = true, yaml = true }
    end
  },
  {
    'yuki-yano/fuzzy-motion.vim',
    dependencies = 'vim-denops/denops.vim',
    config = function()
      vim.g.fuzzy_motion_matchers = 'kensaku'
      vim.api.nvim_set_keymap("n", "ff", ":FuzzyMotion<CR>", { noremap = true })
    end
  },
  {
    'lambdalisue/kensaku.vim',
    dependencies = 'vim-denops/denops.vim'
  },
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
  { 'slim-template/vim-slim' },
  { 'tpope/vim-rails' },
}
