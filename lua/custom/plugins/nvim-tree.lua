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
      width = 40,
      side = 'left',
      -- Keep the tree width when opening files instead of letting Neovim
      -- equalize all windows (which snaps the tree back to `width`).
      preserve_window_proportions = true,
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
