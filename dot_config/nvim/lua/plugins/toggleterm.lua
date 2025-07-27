return {
  {
    'akinsho/toggleterm.nvim',
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        hidden = true
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>")
    end,
  }
}
