local lspconfig = require("lspconfig")
local node_servers = require("cli.node_servers")

-- node_servers を有効化
node_servers.config({ dir = node_servers.dir })

-- Existing LSP configurations
lspconfig.lua_ls.setup {}
lspconfig.rubocop.setup {
  -- cmd = { "bundle", "exec", "rubocop" },
  -- root_markers = {
  --   "/home/h-mochizuki/dev/github.com/soujin8/dotfiles/config/nvim/lua/cli/ruby_servers/Gemfile"
  -- }
}
lspconfig.ruby_lsp.setup {
  -- cmd = { "bundle", "exec", "ruby-lsp" },
  -- root_markers = {
  --   "/home/h-mochizuki/dev/github.com/soujin8/dotfiles/config/nvim/lua/cli/ruby_servers/Gemfile"
  -- }
}
lspconfig.ts_ls.setup {}
lspconfig.eslint.setup {}
lspconfig.stylelint_lsp.setup {}
-- lspconfig.denols.setup{}

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Attach key mappings for LSP functionalities",
  callback = function()
    local set = vim.keymap.set
    local opts = { buffer = true }
    set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    set("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    set("n", "<leader>gD", "<cmd>Lspsaga incoming_calls<CR>", opts)
    set("n", "<leader>ac", "<cmd>Lspsaga code_action<CR>", opts)
    set("n", "<leader>gd", "<cmd>Lspsaga peek_definition<CR>", opts)
    set('n', '[d', "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    set('n', ']d', "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
    set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
    set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
    set("n", "<leader>gi", "<cmd>Lspsaga finder<CR>", opts)

    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", max_item_count = 15, keyword_length = 2 },
        { name = "vsnip", max_item_count = 15, keyword_length = 2 },
        { name = "copilot", max_item_count = 15, keyword_length = 2 },
        { name = "nvim_lsp_signature_help" },
        { name = "buffer", max_item_count = 15, keyword_length = 2 },
        { name = "path" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          preset = "default",
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end
})
