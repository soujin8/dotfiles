return {
  "TimUntersberger/neogit",
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<leader>gl", function() require("neogit").action("log", "log_current", { "--graph", "--decorate", "--max-count=256" })() end, desc = "Neogit Log" },
    { "<leader>gc", function() require("neogit").action("commit", "commit", { "--verbose" })() end, desc = "Neogit Commit" },
  },
}
