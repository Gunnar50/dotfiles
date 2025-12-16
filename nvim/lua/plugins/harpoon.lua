return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}

    -- Default Harpoon UI
    vim.keymap.set('n', '<leader>m', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle harpoon menu' })

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Add to Harpoon list' })

    vim.keymap.set('n', '<leader>h', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon list 1' })

    vim.keymap.set('n', '<leader>j', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon list 2' })

    vim.keymap.set('n', '<leader>k', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon list 3' })

    vim.keymap.set('n', '<leader>l', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon list 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>p', function()
      harpoon:list():prev()
    end)

    vim.keymap.set('n', '<leader>n', function()
      harpoon:list():next()
    end)
  end,
}
