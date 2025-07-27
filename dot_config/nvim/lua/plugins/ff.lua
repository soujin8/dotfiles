return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-l>'] = require('telescope.actions.layout').toggle_preview
            }
          },
          preview = {
            hide_on_startup = true -- hide previewer when picker starts
          }
        },
      }
      require("telescope").load_extension("ui-select")
      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')

      -- when a count N is given to a telescope mapping called through the following
      -- function, the search is started in the Nth parent directory
      local function telescope_cwd(picker, args)
        builtin[picker](vim.tbl_extend("error", args or {}, { cwd = ("../"):rep(vim.v.count) .. "." }))
      end

      local map, opts = vim.keymap.set, { noremap = true, silent = true }
      map("n", "<leader>ff", function() telescope_cwd('find_files', { hidden = true }) end, opts)
      map("n", "<leader>gf", function() telescope_cwd('git_files', { hidden = true }) end, opts)
      map("n", "<leader>gr", function() telescope_cwd('live_grep') end, opts)
      map("n", "<leader>ds", builtin.lsp_document_symbols, opts)
      map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, opts)
      map('n', '<leader>fb', builtin.buffers, opts)
      map("n", "<leader>fo", builtin.oldfiles, opts)
      map("n", "<leader>ts", "<cmd>Telescope<cr>", opts)
    end
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
}
