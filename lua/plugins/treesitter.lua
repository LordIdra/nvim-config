return {
    'nvim-treesitter/nvim-treesitter',
    opts = {
        ensure_installed = { 'lua', 'luadoc', 'rust', 'toml' },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        rainbow = {
            enable = true,
            extended_mode = true,
        }
    },

    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end
}
