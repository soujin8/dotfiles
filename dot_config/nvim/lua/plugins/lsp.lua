return {
  {
    "williamboman/mason.nvim",
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
