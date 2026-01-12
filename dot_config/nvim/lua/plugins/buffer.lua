return {
  {
    'akinsho/bufferline.nvim',
    branch = 'main',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    event = 'BufRead',
    config = function()
      local nb = require("rc.nb")

      require("bufferline").setup {
        options = {
          show_buffer_close_icons = false,
          name_formatter = function(buf)
            local title = nb.get_title(buf.path)
            return title or buf.name
          end,
        }
      }
      vim.keymap.set("n", "<C-j>", ":BufferLineCycleNext<CR>")
      vim.keymap.set("n", "<C-k>", ":BufferLineCyclePrev<CR>")
      vim.keymap.set("n", "<C-c>", ":bdelete!<CR>")
    end,
  },
}
