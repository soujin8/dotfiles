return {
  -- syntaxhilight
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufRead',
    opts = {
      -- ensure_installed = "all",
      ensure_installed = { "ruby", "css", "html", "javascript", "typescript", "python", "rust", "go", "sql", "yaml", "vue", "tsx", "terraform", "scss", "markdown", "lua", "vim", "bash", "json", "toml" },
      -- sync_install = false,
      -- auto_install = true,
      highlight = {
        enable = true,
        disable = {},
      },
      autotag = {
        enable = true,
      },
      rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
        -- disable slow treesitter highlight for large files
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      context_commentstring = {
        enable = true
      }
    }
  },

  {
    -- treesitter plugin
    'windwp/nvim-ts-autotag',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'BufRead'
  },

  {
    -- A Neovim plugin for setting the commentstring option based on the cursor location in the file. The location is checked via treesitter queries.
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'BufRead'
  },
}
