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

-- 3. Lista de Plugins Esenciales (Uso de lazy.nvim)
require("lazy").setup({
  -- Colores y Estética
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  
  -- Infraestructura LSP básica
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" }, -- Removido 'config = true' para manejarlo manualmente abajo

  -- El Cerebro: Motor de Autocompletado y fuentes
  { 
    "hrsh7th/nvim-cmp", 
    dependencies = { 
      "hrsh7th/cmp-nvim-lsp", -- Fuente desde el LSP nativo
      "hrsh7th/cmp-buffer",   -- Fuente de palabras en el buffer actual
      "hrsh7th/cmp-path",     -- Fuente de rutas de archivos
      "L3MON4D3/LuaSnip"      -- Motor de snippets obligatorio
    } 
  },

  -- Inteligencia de Lenguaje (Tree-sitter)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Buscador de Archivos (Telescope)
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
})

-- 4. Activar el tema
vim.cmd.colorscheme("catppuccin-mocha")

-- 5. Configuración de Autocompletado (nvim-cmp)
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),                 -- Forzar menú de sugerencias
    ['<CR>']      = cmp.mapping.confirm({ select = true }), -- 'Enter' confirma opción
    ['<Tab>']     = cmp.mapping.select_next_item(),         -- Bajar en la lista
    ['<S-Tab>']   = cmp.mapping.select_prev_item(),         -- Subir en la lista
    ['<C-e>']     = cmp.mapping.abort(),                    -- Cerrar el menú
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- Sugerencias inteligentes de Mason/LSP
  }, {
    { name = 'buffer' },   -- Palabras de tu archivo actual
    { name = 'path' },     -- Rutas del sistema de archivos
  }),
})

-- 6. Configuración de LSP Nativa (Neovim 0.11+ Way)
-- Inicializa mason-lspconfig para asegurar que tus servidores estén descargados
require("mason-lspconfig").setup({
  ensure_installed = { 'pyright', 'gopls', 'clangd', 'bashls' },
})

-- Obtener las capacidades requeridas por nvim-cmp para el autocompletado
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lista de tus servidores LSP activos
local servers = { 'pyright', 'gopls', 'clangd', 'bashls' }

for _, lsp in ipairs(servers) do
  -- 1. Modificar o inyectar las capacidades de autocompletado nativamente
  vim.lsp.config(lsp, {
    capabilities = capabilities,
  })
  
  -- 2. Habilitar el servidor para que se ejecute en sus tipos de archivo asignados
  vim.lsp.enable(lsp)
end

-- 7. Atajos rápidos (Keymaps)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Espacio + f + f para buscar archivos
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})     -- 'gd' para ir a la definición del código
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})           -- 'K' para ver documentación bajo el cursor
