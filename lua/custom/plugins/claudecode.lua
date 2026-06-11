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
      -- There is no 'tmux' provider. To open Claude in a real tmux pane we use
      -- the 'external' provider and shell out to `tmux split-window` ourselves.
      provider = 'external',
      split_side = 'right',
      split_width_percentage = 0.38,
      provider_opts = {
        -- Function form so we can forward the plugin's env vars (the WebSocket
        -- port etc.) into the new pane via tmux's `-e KEY=VAL`. A plain
        -- `tmux split-window ... %s` would NOT inherit them and Claude would
        -- fail to connect back to Neovim.
        external_terminal_cmd = function(cmd_string, env_table)
          local args = { 'tmux', 'split-window', '-h', '-l', '38%' }
          for key, value in pairs(env_table or {}) do
            table.insert(args, '-e')
            table.insert(args, string.format('%s=%s', key, value))
          end
          table.insert(args, cmd_string)
          return args
        end,
      },
    },
  },
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection' },
    { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file', ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' } },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
