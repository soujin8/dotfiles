-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.fn.has("linux") == 1 and (vim.env.SSH_CONNECTION or vim.env.TERM_PROGRAM == "rex") then
  -- OSC 52の読み出しは端末の応答待ちで遅いため、書き込みだけOSC 52を使う。
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
  end
  vim.g.clipboard = {
    name = "OSC 52 (write only)",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = ""
vim.g.autoformat = false
