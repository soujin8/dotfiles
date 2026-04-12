return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- gd を無効化し <leader>gd に移動
          keys = {
            { "gd", false },
            { "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to Definition", has = "definition" },
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "biome",
        "clangd",
        "eslint-lsp",
        "lua-language-server",
        "rubocop",
        "ruby-lsp",
        "rust-analyzer",
        "shfmt",
        "stylua",
        "tree-sitter-cli",
        "typescript-language-server",
      },
    },
  },
}
