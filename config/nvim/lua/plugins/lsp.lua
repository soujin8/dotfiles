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

    { "L3MON4D3/LuaSnip" },

    -- 補完エンジン
    {
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        -- refer: https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/completion/copilot-lua-cmp/init.lua
        local cmp, copilot = require "cmp", require "copilot.suggestion"
        local snip_status_ok, luasnip = pcall(require, "luasnip")
        if not snip_status_ok then return end
        local function has_words_before()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end
        if not opts.mapping then opts.mapping = {} end
        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
          if copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" })

        opts.mapping["<C-x>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.next() end
        end)

        opts.mapping["<C-z>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.prev() end
        end)

        opts.mapping["<C-right>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.accept_word() end
        end)

        opts.mapping["<C-l>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.accept_word() end
        end)

        opts.mapping["<C-down>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.accept_line() end
        end)

        opts.mapping["<C-j>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.accept_line() end
        end)

        opts.mapping["<C-c>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.dismiss() end
        end)

        return opts
      end,
    },
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
    { "saadparwaiz1/cmp_luasnip" },
    {
      "zbirenbaum/copilot-cmp",
      config = function()
        require("copilot_cmp").setup()
      end
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
      config = function()
        require("fidget").setup()
      end,
    },
  }
end

return {
  config,
}
