function copy_relative_file_path_to_clipboard()
    local file_path = vim.fn.expand("%:~:.")
    if vim.fn.has('clipboard') == 1 then
        vim.fn.setreg('+', file_path)
        print("Copied relative file path to clipboard: " .. file_path)
    else
        print("Clipboard support is not available")
    end
end

vim.api.nvim_set_keymap(
  'n', 
  '<Leader>n', 
  [[<Cmd>lua copy_relative_file_path_to_clipboard()<CR>]],
  { noremap = true, silent = true }
)
