-- 1. Instalar el gestor de plugins (Lazy.nvim) de forma automática
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Configuraciones básicas de IDE
vim.opt.number = true         -- Números de línea
vim.opt.relativenumber = true -- Números relativos (clave para moverse rápido)
vim.opt.shiftwidth = 4        -- Tabulación de 4 espacios
vim.opt.expandtab = true      -- Convertir tabs en espacios
vim.opt.termguicolors = true  -- Colores reales de 24 bits
vim.g.mapleader = " "         -- Tu tecla "Líder" será el Espacio

-- 3. Lista de Plugins Esenciales
require("lazy").setup({
  -- Colores y Estética (Robusto)
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  
  -- El Cerebro: LSP, Autocompletado y Mason
--  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" } },

  -- Inteligencia de Lenguaje (Tree-sitter)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Buscador de Archivos (El mejor invento)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
})

-- 4. Activar el tema
vim.cmd.colorscheme("catppuccin-mocha")

-- 5. Configuración de LSP para tus lenguajes
vim.lsp.enable({ 'pyright', 'gopls', 'clangd', 'bashls' })

-- 6. Atajos rápidos (Keymaps)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Espacio + f + f para buscar archivos
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})     -- 'gd' para ir a la definición del código
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})           -- 'K' para ver documentación bajo el cursor
-- 7. Autocompletado
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),   -- forzar sugerencias
    ['<CR>']      = cmp.mapping.confirm({ select = true }), -- confirmar
    ['<Tab>']     = cmp.mapping.select_next_item(), -- siguiente
    ['<S-Tab>']   = cmp.mapping.select_prev_item(), -- anterior
    ['<C-e>']     = cmp.mapping.abort(),      -- cerrar
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- sugerencias del LSP
    { name = 'luasnip' },  -- snippets
  }),
})
