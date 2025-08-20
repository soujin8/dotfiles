return {
  { 'mtdl9/vim-log-highlighting' },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    keys = {
      { "<Leader>sm", ":RenderMarkdown toggle<CR>" },
    },
    opts = {},
    config = function()
      require("render-markdown").setup {
        heading = {
          width = "block",
          left_pad = 0,
          right_pad = 4,
          icons = {},
        },
        code = {
          width = "block",
        },
      }
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false, },
        panel = { enabled = false, },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim",        branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      require("CopilotChat").setup {
        debug = true,
        proxy = nil,
        allow_insecure = false,
        model = 'claude-3.7-sonnet',
        temperature = 0.1,
        prompts = {
          Explain = {
            prompt = '/COPILOT_EXPLAIN 選択したコードの説明を段落をつけて書いてください。',
          },
          Fix = {
            prompt = '/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。',
          },
          Optimize = {
            prompt = '/COPILOT_OPTIMIZE 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。',
          },
          Docs = {
            prompt = '/COPILOT_DOCS 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）',
          },
          Tests = {
            prompt = '/COPILOT_TESTS 選択したコードの詳細な単体テスト関数を書いてください。',
          },
          FixDiagnostic = {
            prompt = '/COPILOT_FIXDIAGNOSTIC ファイル内の次のような診断上の問題を解決してください：',
          },
          Commit = {
            prompt = '/COPILOT_COMMIT この変更をコミットしてください。',
          },
          CommitStaged = {
            prompt = '/COPILOT_COMMITSTAGED ステージングされた変更をコミットしてください。',
          },
        },
      }
      vim.api.nvim_set_keymap("n", "<leader>0", ":CopilotChatPrompts <CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<leader>0", ":CopilotChatPrompts <CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>9", ":CopilotChatToggle <CR>", { noremap = true, silent = true })
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
  {
    'tpope/vim-rails',
  },
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
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup {
        auto_enable = true,
        func_map = {
          vsplit = '',
        },
      }
    end,
  },
  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    opts = {},
  },
  -- splitting/joining lines
  -- コードの意味を変えずに複数行を一行に、一行を複数行に変換する
  {
    'Wansmer/treesj',
    keys = { '<leader>m', '<leader>j', '<leader>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ --[[ your config ]] })
    end,
  },
  -- コメントアノテーション自動生成
  {
    "danymat/neogen",
    config = true,
    keys = {
      { '<leader>d', ':Neogen<CR>' }
    },
  },
  -- snippet engine
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").load({ paths = { "./lua/snippets" } })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  }
}
