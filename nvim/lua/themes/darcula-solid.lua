return {
  'briones-gabriel/darcula-solid.nvim',
  dependencies = { 'rktjmp/lush.nvim' }, -- required
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'darcula-solid-custom'
  end,
}
