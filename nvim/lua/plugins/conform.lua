return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports', 'ruff_fix' },
    },
    formatters = {
      ruff_format = {
        command = 'ruff',
        args = { 'format', '--config', '~/.config/ruff/ruff.toml', '--stdin-filename', '$FILENAME', '-' },
      },
      ruff_organize_imports = {
        command = 'ruff',
        args = { 'check', '--config', '~/.config/ruff/ruff.toml', '--select', 'I', '--fix', '--stdin-filename', '$FILENAME', '-' },
      },
      ruff_fix = {
        command = 'ruff',
        args = { 'check', '--config', '~/.config/ruff/ruff.toml', '--fix', '--stdin-filename', '$FILENAME', '-' },
      },
    },
  },
}
