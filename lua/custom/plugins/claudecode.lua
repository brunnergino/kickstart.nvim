-- Claude Code integration via coder/claudecode.nvim
-- Toggle Claude with <leader>ac (summon/dismiss)
-- Uses a native vertical split terminal; works seamlessly with tmux sessions.
return {
  'coder/claudecode.nvim',
  lazy = false,
  opts = {
    auto_start = true,
    log_level = 'info',
    terminal = {
      provider = 'native', -- opens inside nvim; set to 'tmux' to open in a new tmux pane instead
      split_side = 'right',
      split_width_percentage = 0.38,
    },
  },
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle [C]laude Code' },
    { '<leader>af', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Claude: add current [F]ile' },
    { '<leader>as', '<cmd>ClaudeCodeAdd<cr>', mode = 'v', desc = 'Claude: [S]end selection' },
    { '<leader>at', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Claude: add from [T]ree (neo-tree)' },
  },
}
