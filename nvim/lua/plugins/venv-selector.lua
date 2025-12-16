return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
  },
  branch = 'regexp',
  config = function()
    require('venv-selector').setup {
      name = { '.venv', 'venv' },
      auto_refresh = true,
    }
  end,
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>', desc = '[V]env [S]elect' },
    { '<leader>vc', '<cmd>VenvSelectCached<cr>', desc = '[V]env Select [C]ached' },
  },
}
