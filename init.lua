vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 500
vim.opt.timeoutlen = 50
vim.opt.ttimeoutlen = 50
vim.opt.scrolloff = 5
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.showmode = false
vim.opt.relativenumber = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = "all"
        },
        check = {
          command = "clippy",
          features = "all"
        }
      }
    }
  }
}

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>td', '<cmd>Trouble diagnostics toggle<CR>', { desc = '[T]oggle [D]iagnostics' })
vim.keymap.set('n', '<leader>rt', function ()
  require("neotest").run.run(vim.fn.getcwd())
  require("neotest").summary.open()
end, { desc = '[R]un [T]ests' })
vim.keymap.set('n', '<Esc>', function ()
  vim.cmd.nohlsearch()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
end)

require('config.lazy')

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })

  vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { buffer = bufnr, desc = 'LSP: [G]oto [D]efinition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = bufnr, desc = 'LSP: [G]oto [R]eferences' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').lsp_document_symbols, { buffer = bufnr, desc = 'LSP: [S]earch [D]ocument symbols' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').lsp_workspace_symbols, { buffer = bufnr, desc = 'LSP: [S]earch [W]orkspace symbols' })
  vim.keymap.set('n', '<F3>', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'LSP: [W]orkspace [S]ymbols' })
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { buffer = bufnr, desc = 'LSP: [W]orkspace [S]ymbols' })
end)

require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = { 'yamlls' },
  handlers = {
    ['rust_analyzer'] = function() end,
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

require('lspconfig').lua_ls.setup({})
require('lspconfig').yamlls.setup({})

require('auto-save').setup({
  write_all_buffers = true
})

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true,
  }
)

require('dracula').setup({})

require('lualine').setup {
  options = {
    theme = "dracula-nvim",
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'diagnostics'},
    lualine_x = {},
    lualine_y = {'filename'},
    lualine_z = {'location'}
  }
}

require('trouble').setup({})

vim.cmd [[ 
  sign define DiagnosticSignError text=  linehl= texthl=DiagnosticSignError numhl= 
  sign define DiagnosticSignWarn text= linehl= texthl=DiagnosticSignWarn numhl= 
  sign define DiagnosticSignInfo text=  linehl= texthl=DiagnosticSignInfo numhl= 
  sign define DiagnosticSignHint text=  linehl= texthl=DiagnosticSignHint numhl= 
]]

require('noice').setup {}

require("neotest").setup({
  adapters = {
    require("neotest-rust") {
        args = { "--no-capture" },
        dap_adapter = "lldb",
    }
  }
})
