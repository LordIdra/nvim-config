return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'onsails/lspkind-nvim',
        'ryo33/nvim-cmp-rust'
    },
    performance = {
        debounce = 1000
    },
    config = function ()
        local cmp = require 'cmp'
        cmp.setup {
            completion = {
                completeopt = 'menu,menuone,noinsert,popup'
            },
            mapping = cmp.mapping.preset.insert {
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                ['<CR>'] = cmp.mapping.confirm(),
            },
            formatting = {
                format = require('lspkind').cmp_format {
                    mode = 'symbol',
                    maxwidth = 50,
                    menu = {},
                }
            }
        }

        local compare = require "cmp.config.compare"
        cmp.setup.filetype({
            "rust"
        }, {
            sorting = {
                priority_weight = 2,
                comparators = {
                    -- deprioritize `.box`, `.mut`, etc.
                    require("cmp-rust").deprioritize_postfix,
                    -- deprioritize `Borrow::borrow` and `BorrowMut::borrow_mut`
                    require("cmp-rust").deprioritize_borrow,
                    -- deprioritize `Deref::deref` and `DerefMut::deref_mut`
                    require("cmp-rust").deprioritize_deref,
                    -- deprioritize `Into::into`, `Clone::clone`, etc.
                    require("cmp-rust").deprioritize_common_traits,
                    compare.offset,
                    compare.exact,
                    compare.score,
                    compare.recently_used,
                    compare.locality,
                    compare.sort_text,
                    compare.length,
                    compare.order,
                },
            }
        })
    end
}
