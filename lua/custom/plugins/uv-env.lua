local M = {}

-- Function to find the project root directory managed by uv
function M.find_uv_project_root(start_path)
  local current_path = start_path or vim.fn.expand '%:p:h'

  -- List of possible uv project markers
  local uv_markers = {
    'uv.json', -- uv's configuration file
    'pyproject.toml', -- supports modern Python projects
    '.uv', -- uv directory
    'requirements.txt', -- traditional Python dependency file
  }

  while current_path ~= '/' do
    for _, marker in ipairs(uv_markers) do
      if vim.fn.filereadable(current_path .. '/' .. marker) == 1 then
        return current_path
      end
    end

    -- Move up one directory
    current_path = vim.fn.fnamemodify(current_path, ':h')
  end

  return nil
end

--- Execute a function for a specific LSP client
--- @param client_name string
--- @param callback fun(client: vim.lsp.Client)
function M.execute_for_client(client_name, callback)
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == client_name then
      callback(client)
    end
  end
end

--- Hook to update Pyright configuration
--- @param venv_path string
--- @param venv_python string
function M.pyright_hook(venv_path, venv_python)
  M.execute_for_client('pyright', function(client)
    if client.settings then
      client.settings = vim.tbl_deep_extend('force', client.settings, {
        python = {
          pythonPath = venv_python,
          venvPath = venv_path,
          venv = '.venv',
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'workspace',
            useLibraryCodeForTypes = true,
          },
        },
      })
    else
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
        python = {
          pythonPath = venv_python,
          venvPath = venv_path,
          venv = '.venv',
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'workspace',
            useLibraryCodeForTypes = true,
          },
        },
      })
    end
    client.notify('workspace/didChangeConfiguration', { settings = nil })
  end)
end

-- Function to activate virtual environment
function M.activate_uv_venv()
  local project_root = M.find_uv_project_root()

  if not project_root then
    return nil
  end

  -- Potential virtual environment paths
  local venv_paths = {
    project_root .. '/.venv',
    project_root .. '/venv',
    project_root .. '/env',
  }

  for _, venv_path in ipairs(venv_paths) do
    if vim.fn.isdirectory(venv_path) == 1 then
      -- Activate Python virtual environment
      vim.env.VIRTUAL_ENV = venv_path

      -- Modify Python path
      local python_path = venv_path .. '/bin/python'
      if vim.fn.executable(python_path) == 1 then
        vim.g.python3_host_prog = python_path

        -- Configure Pyright LSP
        pcall(function()
          require('lspconfig').pyright.setup {
            settings = {
              python = {
                pythonPath = python_path,
                venvPath = project_root,
                venv = '.venv',
                analysis = {
                  autoSearchPaths = true,
                  diagnosticMode = 'workspace',
                  useLibraryCodeForTypes = true,
                },
              },
            },
          }
        end)

        -- Call the Pyright hook to update configuration
        M.pyright_hook(project_root, python_path)

        vim.notify('Activated virtual environment: ' .. venv_path, vim.log.levels.INFO)
        return venv_path
      end
    end
  end

  return nil
end

-- Automatically activate venv when opening a Python file
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.py', '*.pyw' },
  callback = function()
    M.activate_uv_venv()
  end,
})

return M
