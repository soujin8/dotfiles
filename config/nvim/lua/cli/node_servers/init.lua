-- 参考
-- https://github.com/ryoppippi/dotfiles/blob/4c1e0e0d6cca7f2c3d830cc1f4923bd9491015f2/nvim/lua/cli/node_servers/init.lua#L4
return {
	name = "node_servers",
	dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
	build = "bun install",
	config = function(spec)
		local dir = spec.dir

		vim.system({ "bun", "i" }, { cwd = dir, text = true })

		local BIN_DIR =
			assert((vim.system({ "bun", "pm", "bin" }, { cwd = dir, text = true }):wait()).stdout):gsub("\n[^\n]*$", "")
		vim.env.PATH = ("%s:%s"):format(BIN_DIR, vim.env.PATH)
	end,
}
