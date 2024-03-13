local config = {}

if vim.env.LSP == "nvim" then
  config = {
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufWrite" },
      dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "jose-elias-alvarez/null-ls.nvim" },
        -- { 'jose-elias-alvarez/null-ls.nvim' },
        -- { 'hrsh7th/cmp-nvim-lsp' },
        -- { 'hrsh7th/cmp-buffer' },
        -- { 'hrsh7th/cmp-path' },
        -- { 'hrsh7th/cmp-vsnip' },
        -- { 'hrsh7th/cmp-cmdline' },
        -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        -- { 'hrsh7th/cmp-calc' },
        -- { '' },
        -- { '' },
        -- { '' },
        -- { 'b0o/SchemaStore.nvim' },
        -- { 'SmiteshP/nvim-navic' },
        -- { 'jose-elias-alvarez/typescript.nvim' },
        -- { 'yioneko/nvim-vtsls' },
        -- { 'folke/neodev.nvim' },
        -- { 'lewis6991/hover.nvim' },
        -- { 'davidosomething/format-ts-errors.nvim' },
      },
      config = function()
        local mason = require("mason")
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local null_ls = require("null-ls")

        mason.setup()
        mason_lspconfig.setup({
          ensure_installed = {
            "lua_ls",
            "ruby_ls",
            "rust_analyzer",
            "tsserver",
            "tailwindcss",
          },
          automatic_installation = true,
        })
        mason_lspconfig.setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({})
          end,
        })

        -- local bufopts = function(desc)
        --   return { noremap = true, silent = true, buffer = bufnr, desc = desc }
        -- end

        -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        -- vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
        -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        -- vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
        vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
        -- vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        -- vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        -- vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
        -- vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
        -- vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
        vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
        vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
        vim.keymap.set({ "n" }, "gd", vim.lsp.buf.type_definition)
        vim.keymap.set("n", "rn", "<cmd>Lspsaga rename<CR>")
        vim.keymap.set("n", "ca", "<cmd>Lspsaga code_action<CR>")
        vim.keymap.set("n", "<Leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>")
        vim.keymap.set("n", "<Leader>fmt", function()
          vim.lsp.buf.format({ async = true })
        end)



        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        null_ls.setup({
          capabilities = capabilities,
          sources = {
            null_ls.builtins.formatting.stylua.with({
              condition = function(utils)
                return utils.root_has_file({ ".stylua.toml" })
              end,
            }),
            null_ls.builtins.diagnostics.rubocop.with({
              prefer_local = ".bundle/bin",
              condition = function(utils)
                return utils.root_has_file({ ".rubocop.yml" })
              end,
            }),
            null_ls.builtins.diagnostics.yamllint,
            null_ls.builtins.diagnostics.commitlint.with({
              condition = function(utils)
                return utils.root_has_file({ "commitlint.config.js" })
              end,
            }),
            null_ls.builtins.formatting.rubocop.with({
              -- prefer_local = ".bundle/bin",
              prefer_local = "bundle exec rubocop",
              condition = function(utils)
                return utils.root_has_file({ ".rubocop.yml" })
              end,
            }),
            null_ls.builtins.completion.spell,
          },
        })
      end,
    },

    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered({
              border = "single",
            }),
            documentation = cmp.config.window.bordered({
              border = "single",
            }),
          },
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "vsnip" },
            { name = "nvim_lsp_signature_help" },
            { name = "calc" },
          }, {
            { name = "buffer", keyword_length = 2 },
          }),
          formatting = {
            format = lspkind.cmp_format({
              mode = "text",
              preset = "default",
              maxwidth = 50,
              ellipsis_char = "...",
            }),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-l>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          experimental = {
            ghost_text = true,
          },
        })

        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "nvim_lsp_document_symbol" },
          }, {
            { name = "buffer" },
          }),
        })

        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline", keyword_length = 2 },
          }),
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        vim.cmd("let g:vsnip_filetypes = {}")
      end,
    },

    -- 補完とLSの連携
    { "hrsh7th/cmp-nvim-lsp",                 event = "InsertEnter" },
    { "hrsh7th/cmp-buffer",                   event = "InsertEnter" },
    { "hrsh7th/cmp-path",                     event = "InsertEnter" },
    { "hrsh7th/cmp-vsnip",                    event = "InsertEnter" },
    { "hrsh7th/cmp-cmdline",                  event = "ModeChanged" }, --これだけは'ModeChanged'でなければまともに動かなかった。
    { "hrsh7th/cmp-nvim-lsp-signature-help",  event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "InsertEnter" },
    { "hrsh7th/cmp-calc",                     event = "InsertEnter" },
    { "hrsh7th/vim-vsnip",                    event = "InsertEnter" },
    { "hrsh7th/vim-vsnip-integ",              event = "InsertEnter" },
    { "onsails/lspkind.nvim",                 event = "InsertEnter" },
    { "rafamadriz/friendly-snippets",         event = "InsertEnter" },
    {
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup()
      end,
    },

    -- Improves the Neovim built-in LSP experience.
    {
      "nvimdev/lspsaga.nvim",
      config = function()
        require("lspsaga").setup({})
      end,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
    },

    -- NOTE: null-lsが利用不可になったら
    -- -- linter
    -- {
    -- 	"mfussenegger/nvim-lint",
    -- 	config = function()
    -- 		require("lint").linters_by_ft = {
    -- 			javascript = { "eslint" },
    -- 			typescript = { "eslint" },
    -- 			typescriptreact = { "eslint" },
    -- 			ruby = { "rubocop" },
    -- 		}
    -- 	end,
    -- },
    -- -- formatter
    -- {
    -- 	"stevearc/conform.nvim",
    -- 	opts = {},
    -- 	config = function()
    -- 		require("conform").setup({
    -- 			formatters_by_ft = {
    -- 				lua = { "stylua" },
    -- 				javascript = { "prettier" },
    -- 				ruby = { "rubocop" },
    -- 			},
    -- 			format_on_save = {
    -- 				timeout_ms = 500,
    -- 				lsp_fallback = true,
    -- 			},
    -- 		})
    -- 	end,
    -- },
  }
end

return {
  config,
}
