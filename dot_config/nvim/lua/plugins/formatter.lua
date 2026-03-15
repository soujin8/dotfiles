return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      ruby = { "rubocop" },
      rust = { "rustfmt" },
      javascript = { "biome" },
      javascriptreact = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      json = { "biome" },
      jsonc = { "biome" },
      css = { "biome" },
      graphql = { "biome" },
      svelte = { "biome" },
      vue = { "biome" },
      astro = { "biome" },
    },
    formatters = {
      biome = {
        require_cwd = true,
      },
    },
  },
}
