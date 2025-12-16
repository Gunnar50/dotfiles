return {
  'rbong/vim-flog',
  lazy = true,
  cmd = { 'Flog', 'Flogsplit', 'Floggit' },
  dependencies = {
    'tpope/vim-fugitive',
  },
  init = function()
    vim.keymap.set('n', '<leader>gg', '<cmd>Flogsplit<CR>')
  end,
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'floggraph',
      callback = function()
        local opts = { buffer = true, silent = true }
        -- Add these lines to restore some remaps:
        vim.keymap.set('n', '(', '5j', opts)
        vim.keymap.set('n', ')', '5k', opts)
      end,
    })
  end,
}
