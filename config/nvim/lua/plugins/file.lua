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

    vim.keymap.set('n', 'fd', '<cmd>NvimTreeOpen<CR>', { buffer = true })
  end
}
