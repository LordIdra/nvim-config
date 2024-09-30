return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',

    dependencies = {
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },

    config = function()
        require('telescope').setup {
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                }
            }
        }

        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', function()
            builtin.find_files({ no_ignore = true })
        end, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    end
}
