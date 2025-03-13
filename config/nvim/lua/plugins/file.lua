return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  config = function()
    require("nvim-tree").setup {
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
      end,
    }

    vim.keymap.set('n', 'fd', '<cmd>NvimTreeOpen<CR>', { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>tf", function()
      require("nvim-tree.api").tree.find_file({ open = true, focus = true })
    end, { desc = "NvimTree: Open & Focus Current File" })
  end
}
