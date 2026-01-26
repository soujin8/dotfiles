  return {
    dir = '~/dev/github.com/soujin8/my-note.nvim',
    config = function()
      require('my-note').setup({
        notes_dir = '~/notes',
      })
    end,
  }

