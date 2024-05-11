return {
  { 'mtdl9/vim-log-highlighting' },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end,
    event = 'ModeChanged',
  },
  {
    'nicwest/vim-camelsnek',
  },
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
  -- {
  --   "zbirenbaum/copilot.lua",
  --   -- cmd = "Copilot",
  --   -- event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({})
  --   end,
  -- },
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
    dependencies = 'vim-denops/denops.vim',
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
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup({})
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
  -- coding for Ruby on Rails application
  { 'slim-template/vim-slim' },
  { 'tpope/vim-rails' },
  -- generate code documentation
  {
    "danymat/neogen",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    version = "*"
  },
  -- preview of quickfix window buffer
  {
    -- ctrl + q でtoggle-previewに入って、fzfzのアクションを行えるようになる
    -- ctrl-fとctrl-bでpreviewのウィンドウを移動できる
    'kevinhwang91/nvim-bqf'
  },
  -- splitting/joining lines
  -- コードの意味を変えずに複数行を一行に、一行を複数行に変換する
  {
    'Wansmer/treesj',
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ --[[ your config ]] })
    end,
  },
}
