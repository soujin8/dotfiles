return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufRead',
    dependencies = {
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
      { 'nvim-treesitter/nvim-treesitter-context' },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'windwp/nvim-ts-autotag' },
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
      { 'RRethy/nvim-treesitter-endwise' },
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        -- ensure_installed = "all",
        ensure_installed = { "ruby", "css", "html", "javascript", "typescript", "python", "rust", "go", "sql", "yaml", "vue", "tsx", "terraform", "scss", "markdown", "lua", "vim", "bash", "json", "toml", "vimdoc", "diff" },
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
        endwise = {
          enable = true,
        },
      })
    end,
  },
}
