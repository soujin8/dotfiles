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
    dependencies = 'nvim-telescope/telescope.nvim',
    build = "make tiktoken",
    config = function()
      local select = require("CopilotChat.select")

      require("CopilotChat").setup({
        -- debug = true,
        model = 'o3-mini',

        window = {
          layout = "float",
          relative = "editor",
        },
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN 選択されたコードの説明を段落をつけて書いてください。",
          },
          Review = {
            prompt = "/COPILOT_REVIEW 選択されたコードをレビューしてください。",
            callback = function(response, source) end,
          },
          Fix = {
            prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き直してください。",
          },
          Optimize = {
            prompt = "/COPILOT_REFACTOR 選択されたコードを最適化してパフォーマンスと可読性を向上させてください。",
          },
          Docs = {
            prompt = "/COPILOT_DOCS 選択されたコードに対してドキュメンテーションコメントを追加してください。",
          },
          Tests = {
            prompt = "/COPILOT_TESTS 選択されたコードの詳細な単体テスト関数を書いてください。",
          },
          FixDiagnostic = {
            prompt = "ファイル内の次のような診断上の問題を解決してください:",
            selection = select.diagnostics,
          },
        },
      })

      function CopilotChatBuffer()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end

      vim.api.nvim_set_keymap("n", "<leader>9", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<leader>9", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })

      function ShowCopilotChatActionPrompt()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
      end

      vim.api.nvim_set_keymap(
        "n",
        "<leader>0",
        "<cmd>lua ShowCopilotChatActionPrompt()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<leader>0",
        "<cmd>lua ShowCopilotChatActionPrompt()<cr>",
        { noremap = true, silent = true }
      )
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
}
