-- Minimal Neovim Config for Quick Edits
-- =========================================

-- =========================================
-- 1. BOOTSTRAP PLUGIN MANAGER (lazy.nvim)
-- =========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- =========================================
-- 2. YOUR SETTINGS
-- =========================================
vim.opt.number = true             -- Show absolute line number
vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.termguicolors = true      -- Enable true color support
vim.opt.signcolumn = "yes"        -- Prevent text shifting
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.ignorecase = true         -- Search ignores case
vim.opt.smartcase = true          -- Smart case-sensitive search
vim.opt.hlsearch = false          -- Don't keep searches highlighted
vim.opt.tabstop = 4               -- Tab = 4 spaces
vim.opt.shiftwidth = 4            -- Indent = 4 spaces
vim.opt.expandtab = true          -- Convert tabs to spaces


-- =========================================
-- 3. INSTALL & CONFIGURE PLUGINS
-- =========================================
require("lazy").setup({
  -- Install the Dracula theme
  {
    "Mofiqul/dracula.nvim",
    lazy = false,    -- Make sure it loads immediately on startup
    priority = 1000, -- Force it to load before other UI plugins
    config = function()
      -- Configure Dracula for transparency
      require("dracula").setup({
        transparent_bg = true,
      })
      -- Turn the theme on!
      vim.cmd([[colorscheme dracula]])
    end,
  },
})
