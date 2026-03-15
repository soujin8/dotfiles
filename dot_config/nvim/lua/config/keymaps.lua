-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- copy relative file path to clipboard
local function copy_relative_file_path_to_clipboard()
  local file_path = vim.fn.expand("%:~:.")
  if vim.fn.has("clipboard") == 1 then
    vim.fn.setreg("+", file_path)
    print("Copied relative file path to clipboard: " .. file_path)
  else
    print("Clipboard support is not available")
  end
end

vim.keymap.set("n", "<Leader>n", copy_relative_file_path_to_clipboard, { noremap = true, silent = false, desc = "Copy relative file path to clipboard" })

-- jj to escape in insert mode
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })

-- remap lazygit from <leader>gg to <leader>lg
vim.keymap.del("n", "<leader>gg")
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })

