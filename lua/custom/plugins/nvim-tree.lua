-- nvim-tree: classic sidebar file tree
-- <leader>nn to toggle, <leader>nf to locate current file in the tree.
-- Note: neo-tree (bound to `\`) is also available; use whichever you prefer.
return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = true,
  -- Do NOT set vim.g.loaded_netrw here; snacks/neo-tree already manage netrw.
  opts = {
    hijack_netrw = false,
    view = {
      width = 30,
      side = 'left',
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
    },
    filters = {
      dotfiles = false,
    },
    git = {
      enable = true,
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
      },
    },
  },
  keys = {
    { '<leader>nn', '<cmd>NvimTreeToggle<cr>', desc = '[N]vim-tree toggle' },
    { '<leader>nf', '<cmd>NvimTreeFindFile<cr>', desc = '[N]vim-tree [F]ind file' },
  },
}
