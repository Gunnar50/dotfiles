vim.opt.background = 'dark'
vim.g.colors_name = 'darcula-solid-custom'

local lush = require 'lush'
local darcula_solid = require 'lush_theme.darcula-solid'

local spec = lush.extends({ darcula_solid }).with(function()
  -- VSCode PyCharm Darcula exact color palette
  local bg = lush.hsl '#26292c' -- editor.background
  local fg = lush.hsl '#A9B7C6' -- editor.foreground
  local comment = lush.hsl '#808080' -- comments
  local keyword = lush.hsl '#CC7832' -- keywords, control flow
  local string = lush.hsl '#6A8759' -- strings
  local number = lush.hsl '#6897BB' -- numbers
  local func = lush.hsl '#FAC26B' -- functions
  local variable = lush.hsl '#9876AA' -- variables, properties
  local constant = lush.hsl '#9876AA' -- constants
  local type_color = lush.hsl '#8888C6' -- types, classes (builtin functions)
  local cursor_line = lush.hsl '#323232' -- current line highlight
  local line_nr = lush.hsl '#5c6166' -- line numbers
  local selection = lush.hsl '#3d3d3d' -- visual selection
  local sidebar_bg = lush.hsl '#313437' -- sidebar background

  return {
    -- Base colors
    Normal { fg = fg, bg = bg },
    Comment { fg = comment, gui = 'italic' },

    -- Syntax
    Keyword { fg = keyword },
    String { fg = string },
    Number { fg = number },
    Function { fg = func },
    Type { fg = type_color },
    Constant { fg = constant },
    Identifier { fg = variable },
    Boolean { fg = keyword },

    -- UI elements
    CursorLine { bg = cursor_line },
    LineNr { fg = line_nr },
    CursorLineNr { fg = fg },
    Visual { bg = selection },

    -- Treesitter
    sym '@keyword' { Keyword },
    sym '@string' { String },
    sym '@number' { Number },
    sym '@function' { Function },
    sym '@function.call' { Function },
    sym '@type' { Type },
    sym '@constant' { Constant },
    sym '@comment' { Comment },
    sym '@variable' { fg = variable },
    sym '@property' { fg = variable },
    sym '@parameter' { fg = variable },
  }
end)

lush(spec)

-- Force overrides after Lush loads
-- Brackets to yellow
vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#FED601', bold = true })
vim.api.nvim_set_hl(0, '@punctuation.bracket.python', { fg = '#FED601', bold = true })
vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = '#A9B7C6', bold = true })
vim.api.nvim_set_hl(0, '@punctuation.special', { fg = '#FED601', bold = true })

-- Builtin functions to purple
vim.api.nvim_set_hl(0, '@function.builtin', { fg = '#8888C6' })
vim.api.nvim_set_hl(0, '@function.builtin.python', { fg = '#8888C6' })
vim.api.nvim_set_hl(0, '@type.builtin', { fg = '#8888C6' })
vim.api.nvim_set_hl(0, '@type.builtin.python', { fg = '#8888C6' })

-- Import module names to white
vim.api.nvim_set_hl(0, '@module', { fg = '#A9B7C6' })
vim.api.nvim_set_hl(0, '@module.python', { fg = '#A9B7C6' })

-- True, False, None to orange
vim.api.nvim_set_hl(0, '@boolean', { fg = '#CC7832' })
vim.api.nvim_set_hl(0, '@boolean.python', { fg = '#CC7832' })
vim.api.nvim_set_hl(0, '@constant.builtin', { fg = '#CC7832' })
vim.api.nvim_set_hl(0, '@constant.builtin.python', { fg = '#CC7832' })

-- Special variables like self, cls, __name__, __main__ to bright purple/pink
vim.api.nvim_set_hl(0, '@variable.builtin', { fg = '#B200B2' })
vim.api.nvim_set_hl(0, '@variable.builtin.python', { fg = '#B200B2' })
vim.api.nvim_set_hl(0, '@variable.parameter.builtin', { fg = '#B200B2' })
vim.api.nvim_set_hl(0, '@variable.parameter.builtin.python', { fg = '#B200B2' })
vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'Comment' })
