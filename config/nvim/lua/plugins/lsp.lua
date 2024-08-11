local config = {}

if vim.env.LSP == "nvim" then
  config = {
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
      },
    },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    -- 補完エンジン
    { "hrsh7th/nvim-cmp" },
    -- LSPを補完ソースにする
    { "hrsh7th/cmp-nvim-lsp" },
    -- bufferを補完ソースにする
    { "hrsh7th/cmp-buffer" },
    -- pathを補完ソースにする
    { "hrsh7th/cmp-path", },
    -- スニペットエンジン
    { "hrsh7th/vim-vsnip", },
    -- vim-vsnipの補完ソース
    { "hrsh7th/cmp-vsnip", },
    -- nvim-cmpと連携してアイコン表示
    { "onsails/lspkind.nvim", },
    -- snippetの補完ソース
    { "saadparwaiz1/cmp_luasnip" },
    -- snippet集
    { "rafamadriz/friendly-snippets" },
    {
      "zbirenbaum/copilot-cmp",
      config = true
    },
    -- Improves the Neovim built-in LSP experience.
    {
      "nvimdev/lspsaga.nvim",
      config = function()
        require("lspsaga").setup({
          symbol_in_winbar = {
            enable = false,
          },
          lightbulb = {
            enable = false,
          },
          code_action = {
            extend_gitsigns = true,
          },
        })
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
    },
    -- LSPの起動状況や状態をいい感じに通知してくれる
    {
      "j-hui/fidget.nvim",
      config = true
    },
    -- linter
    {
      -- https://www.josean.com/posts/neovim-linting-and-formatting
      "mfussenegger/nvim-lint",
      event = {
        "BufReadPre",
        "BufNewFile",
      },
      config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          svelte = { "eslint_d" },
          sh = { "shellcheck" },
          css = { "stylelint" },
          scss = { "stylelint" },
          sass = { "stylelint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
          group = lint_augroup,
          callback = function()
            lint.try_lint()
            lint.try_lint("codespell")
          end,
        })

        vim.keymap.set("n", "<leader>l", function()
          lint.try_lint()
          lint.try_lint("codespell")
        end, { desc = "Trigger linting for current file" })
      end,
    },
    -- formatter
    {
      "stevearc/conform.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local conform = require("conform")

        conform.setup({
          formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            svelte = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            graphql = { "prettier" },
          },
          format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
          conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          })
        end, { desc = "Format file or range (in visual mode)" })
      end,
    },
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    }
  }
end

return {
  config,
}
