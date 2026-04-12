return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "│" },
      change       = { text = "│" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      delay = 500,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- hunkナビゲーション
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev hunk")

      -- hunk操作
      map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

      -- visual modeでhunk操作
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk (visual)")

      -- blame toggle
      map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
    end,
  },
}
