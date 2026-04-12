return {
  -- snacks.nvim の explorer を無効化
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      indent = { enabled = false },
      scroll = { enabled = false },
    },
  },

  -- nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 50,
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        end,
      })

      vim.keymap.set("n", "<leader>e", function()
        require("nvim-tree.api").tree.find_file({ open = true, focus = true })
      end, { desc = "NvimTree: Open & Focus Current File" })
    end,
  },
}
