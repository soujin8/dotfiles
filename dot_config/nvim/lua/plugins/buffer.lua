return {
  {
    "akinsho/bufferline.nvim",
    event = "BufRead",
    keys = {
      { "<C-j>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<C-k>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<C-c>", "<cmd>bdelete!<cr>", desc = "Delete Buffer" },
    },
    opts = {
      options = {
        show_buffer_close_icons = false,
      },
    },
  },
}
