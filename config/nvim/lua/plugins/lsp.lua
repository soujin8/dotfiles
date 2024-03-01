local config = {}

if vim.env.LSP == 'nvim' then
  config = {
    {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufWrite' },
      dependencies = {
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'jose-elias-alvarez/null-ls.nvim' },
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
        local mason = require('mason')
        local lspconfig = require('lspconfig')
        local mason_lspconfig = require('mason-lspconfig')

        mason.setup()
        mason_lspconfig.setup(
          {
            ensure_installed = {
              'lua_ls',
              'ruby_ls',
              'rust_analyzer',
              'tsserver',
              'tailwindcss',
            },
            automatic_installation = true,
          }
        )
        mason_lspconfig.setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({})
          end,
        })

        -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        -- vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
        -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        -- vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
        -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
        -- vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        -- vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        -- vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        -- vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
        -- vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
        -- vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
      end,
    },

    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      config = function()
        local cmp = require("cmp")
        local lspkind = require('lspkind')

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },

          window = {
            completion = cmp.config.window.bordered({
              border = 'single'
            }),
            documentation = cmp.config.window.bordered({
              border = 'single'
            }),
          },

          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'calc' },
          }, {
            { name = 'buffer', keyword_length = 2 },
          }),

          formatting = {
            format = lspkind.cmp_format({
              mode = 'text',
              preset = 'default',
              maxwidth = 50,
              ellipsis_char = '...',
            })
          },

          mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ['<C-l>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm { select = true },
          }),

          experimental = {
            ghost_text = true,
          },
        })

        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'nvim_lsp_document_symbol' }
          }, {
            { name = 'buffer' }
          })
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline', keyword_length = 2 }
          })
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        vim.cmd('let g:vsnip_filetypes = {}')
      end,
    },

    -- 補完とLSの連携
    { 'hrsh7th/cmp-nvim-lsp',                 event = 'InsertEnter' },
    { 'hrsh7th/cmp-buffer',                   event = 'InsertEnter' },
    { 'hrsh7th/cmp-path',                     event = 'InsertEnter' },
    { 'hrsh7th/cmp-vsnip',                    event = 'InsertEnter' },
    { 'hrsh7th/cmp-cmdline',                  event = 'ModeChanged' }, --これだけは'ModeChanged'でなければまともに動かなかった。
    { 'hrsh7th/cmp-nvim-lsp-signature-help',  event = 'InsertEnter' },
    { 'hrsh7th/cmp-nvim-lsp-document-symbol', event = 'InsertEnter' },
    { 'hrsh7th/cmp-calc',                     event = 'InsertEnter' },
    { 'hrsh7th/vim-vsnip',            event = 'InsertEnter' },
    { 'hrsh7th/vim-vsnip-integ',      event = 'InsertEnter' },
    { 'onsails/lspkind.nvim',         event = 'InsertEnter' },
    { 'rafamadriz/friendly-snippets', event = 'InsertEnter' },
    {
      "j-hui/fidget.nvim",
      config = function()
        require('fidget').setup()
      end
    },
    {
      'lewis6991/hover.nvim',
      config = function()
          require("hover").setup {
              init = function()
                  -- Require providers
                  require("hover.providers.lsp")
                  -- require('hover.providers.gh')
                  -- require('hover.providers.gh_user')
                  -- require('hover.providers.jira')
                  -- require('hover.providers.man')
                  -- require('hover.providers.dictionary')
              end,
              preview_opts = {
                  border = 'single'
              },
              -- Whether the contents of a currently open hover window should be moved
              -- to a :h preview-window when pressing the hover keymap.
              preview_window = false,
              title = true,
              mouse_providers = {
                  'LSP'
              },
              mouse_delay = 1000
          }

          -- Setup keymaps
          vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
          vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
          vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
          vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})

          -- Mouse support
          vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
          vim.o.mousemoveevent = true
      end
    },

  }
end

return {
  config
}
