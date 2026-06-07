-- oil.nvim: edit the filesystem like a buffer
-- Press `-` in any buffer to open the parent directory in oil.
-- Navigate dirs, rename/delete/create files, then save with `:w`.
return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  opts = {
    -- Do not replace netrw (snacks and neo-tree handle that)
    default_file_explorer = false,
    columns = { 'icon', 'permissions', 'size' },
    view_options = {
      show_hidden = true,
    },
    -- Keep the oil buffer from cluttering the buffer list
    buf_options = {
      buflisted = false,
    },
    float = {
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = 'rounded',
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent dir (Oil)' },
    { '<leader>o-', '<cmd>Oil --float<cr>', desc = 'Open parent dir in float (Oil)' },
  },
}
