return {
  {
    {
      'akinsho/bufferline.nvim',
      branch = 'main',
      dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
      event = 'BufRead',
      config = function()
        require("bufferline").setup {
          options = {
            show_buffer_close_icons = false,
          }
        }
        vim.keymap.set("n", "<C-j>", ":BufferLineCycleNext<CR>")
        vim.keymap.set("n", "<C-k>", ":BufferLineCyclePrev<CR>")
        vim.keymap.set("n", "<C-c>", ":bdelete!<CR>")
      end
    },
  }
}
