return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<C-j>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<C-k>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
    opts = {
      show_buffer_close_icons = false,
    },
  },
}
