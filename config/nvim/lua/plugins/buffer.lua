return {
  {
    {
      'akinsho/bufferline.nvim',
      tag = "v3.3.0",
      dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
      event = 'BufRead',
      config = function()
        require("bufferline").setup {}
        vim.keymap.set("n", "<C-j>", ":BufferLineCycleNext<CR>")
        vim.keymap.set("n", "<C-k>", ":BufferLineCyclePrev<CR>")
        vim.keymap.set("n", "<C-c>", ":bdelete!<CR>")
      end
    },
  }
}
