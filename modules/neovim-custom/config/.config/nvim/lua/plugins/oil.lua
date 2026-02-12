return {
  'stevearc/oil.nvim',
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} }
  },
  opts = {
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    default_file_explorer = true,
    -- Columns to display
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    -- Buffer-local options for oil buffers
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
    -- Window-local options for oil buffers
    win_options = {
      wrap = false,
      signcolumn = 'no',
      cursorcolumn = false,
      foldcolumn = '0',
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = 'nvic',
    },
    -- Send deleted files to OS trash instead of permanently deleting
    delete_to_trash = true,
    -- Skip confirmation for simple operations
    skip_confirm_for_simple_edits = false,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    prompt_save_on_select_new_entry = true,
    -- Keymaps in oil buffer
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-v>'] = 'actions.select_vsplit',
      ['<C-x>'] = 'actions.select_split',
      ['<C-t>'] = 'actions.select_tab',
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-l>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        return vim.startswith(name, '.')
      end,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr)
        return name == '.git' or name == 'node_modules'
      end,
      sort = {
        -- sort order can be "asc" or "desc"
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
      override = function(conf)
        return conf
      end,
    },
    -- Configuration for the actions floating preview window
    preview = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = 0.9,
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
    },
    -- Configuration for the floating progress window
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = 'rounded',
      minimized_border = 'none',
      win_options = {
        winblend = 0,
      },
    },
    -- Configuration for the file preview window
    preview_win = {
      -- Update preview as cursor moves
      update_on_cursor_moved = true,
    },
  },
  keys = {
    {
      '-',
      '<cmd>Oil<cr>',
      desc = 'Open parent directory (Oil)',
    },
  },
}
