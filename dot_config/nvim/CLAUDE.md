# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a [LazyVim](https://lazyvim.github.io/) starter configuration for Neovim. LazyVim provides the base plugin setup and defaults; this repo contains only the user customizations layered on top.

## Architecture

- `init.lua` — entry point, bootstraps lazy.nvim and loads `config.lazy`
- `lua/config/` — core config files loaded automatically by LazyVim:
  - `lazy.lua` — lazy.nvim setup, plugin spec root, performance tweaks
  - `options.lua` — Neovim options (currently empty; LazyVim defaults apply)
  - `keymaps.lua` — custom keymaps (currently empty; LazyVim defaults apply)
  - `autocmds.lua` — custom autocommands (currently empty; LazyVim defaults apply)
- `lua/plugins/` — all files here are auto-imported by lazy.nvim as plugin specs:
  - `buffer.lua` — bufferline.nvim tweak (hides close icons)
  - `coding.lua` — adds vim-sandwich for text object surround operations
  - `example.lua` — commented-out reference file showing patterns for overriding LazyVim plugins (not loaded)
- `lazyvim.json` — LazyVim version and extras tracking (do not edit manually)
- `lazy-lock.json` — lockfile for plugin versions (auto-managed by lazy.nvim)
- `stylua.toml` — Lua formatter config: 2-space indent, 120 column width

## Adding/Modifying Plugins

Create or edit a file in `lua/plugins/`. Each file returns a table (or list of tables) following the lazy.nvim spec. To override a LazyVim plugin, return a spec with the same plugin name and set only the fields you want to change — `opts` tables are deep-merged automatically.

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  opts = { some_option = true },
}
```

To disable a LazyVim built-in plugin:
```lua
{ "folke/some-plugin.nvim", enabled = false }
```

To add LazyVim extras (language support, UI packs, etc.), add to the `extras` array in `lazyvim.json` or import directly in a plugin spec:
```lua
{ import = "lazyvim.plugins.extras.lang.typescript" }
```

## Code Style

Lua files are formatted with **StyLua** (`stylua.toml`): 2-space indentation, 120-character line width. Format with:

```sh
stylua lua/
```

## デフォルト設定

LazyVimのデフォルト設定は`~/.local/share/nvim/lazy/LazyVim`を参照すること
