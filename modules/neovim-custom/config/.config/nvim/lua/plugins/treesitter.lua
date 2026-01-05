-- lua/plugins/treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
    cmd = { 'TSUpdate', 'TSInstall', 'TSInstallInfo', 'TSUninstall' },
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
    opts = {
      ensure_installed = {
        'bash',
        'css',
        'html',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'regex',
        'typescript',
        'vim',
        'vimdoc',
      },
    },
    config = function(_, opts)
      local TS = require 'nvim-treesitter'

      -- Sanity check for new API
      if not TS.setup then
        vim.notify('nvim-treesitter: please update to main branch', vim.log.levels.ERROR)
        return
      end

      -- Setup treesitter with opts
      TS.setup(opts)

      -- Install missing parsers
      local installed = TS.get_installed and TS.get_installed() or {}
      local installed_set = {}
      for _, lang in ipairs(installed) do
        installed_set[lang] = true
      end

      local to_install = vim.tbl_filter(function(lang)
        return not installed_set[lang]
      end, opts.ensure_installed or {})

      if #to_install > 0 then
        TS.install(to_install)
      end

      -- Single autocmd for all treesitter features
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_setup', { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end

          -- Check if parser is available
          local ok = pcall(vim.treesitter.language.add, lang)
          if not ok then
            return
          end

          -- Enable highlighting
          pcall(vim.treesitter.start, ev.buf)

          -- Enable treesitter-based folding (window-local options)
          local win = vim.api.nvim_get_current_win()
          vim.wo[win].foldmethod = 'expr'
          vim.wo[win].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })
    end,
  },
}
