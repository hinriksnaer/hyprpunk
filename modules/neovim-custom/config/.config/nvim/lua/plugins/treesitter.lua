-- lua/plugins/treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false, -- nvim-treesitter doesn't support lazy-loading
    dependencies = {
      { 'folke/which-key.nvim' },
    },
    keys = function()
      local wk = require 'which-key'
      wk.add {
        { '<leader>T', group = '󰦨 Treesitter' },
        { '<leader>Ti', '<cmd>TSInstallInfo<cr>', desc = 'Install info' },
        { '<leader>Tu', '<cmd>TSUpdate<cr>', desc = 'Update parsers' },
      }
      return {}
    end,
    config = function()
      -- New nvim-treesitter API - just install parsers
      local parsers = {
        'lua',
        'vim',
        'vimdoc',
        'python',
        'javascript',
        'typescript',
        'html',
        'css',
        'json',
        'bash',
        'regex',
        'markdown',
        'markdown_inline',
      }

      -- Install parsers asynchronously
      require('nvim-treesitter').install(parsers)

      -- Enable treesitter highlighting via autocmd
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'lua', 'vim', 'python', 'javascript', 'typescript', 'html', 'css', 'json', 'bash', 'markdown' },
        callback = function()
          vim.treesitter.start()
        end,
      })

      -- Enable treesitter-based folding
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'lua', 'vim', 'python', 'javascript', 'typescript', 'html', 'css', 'json', 'bash', 'markdown' },
        callback = function()
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
        end,
      })
    end,
  },
}
