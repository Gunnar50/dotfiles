return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesitter-context').setup {
      enable = true,
      max_lines = 3, -- How many lines the context should span
      trim_scope = 'outer', -- Remove whitespace
    }
  end,
}
