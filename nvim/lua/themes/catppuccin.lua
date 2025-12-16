return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
      color_overrides = {
        mocha = {
          base = '#232629',
          mantle = '#1f2225',
          crust = '#1a1d20',
        },
      },
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
