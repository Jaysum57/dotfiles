vim.opt.number = true
--vim.cmd.colorscheme('retrobox')

--[[
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
]]



vim.opt.fillchars:append({ eob = ' ' })

vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4

--faster cursor hold
vim.opt.updatetime = 20

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.opt.scrolloff = 10
vim.opt.wrap = false -- wrap lines
vim.opt.sidescrolloff = 8

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Visual settings
vim.opt.termguicolors = true
--vim.opt.signcolumn = 'yes' 
vim.opt.colorcolumn = '100' 
vim.opt.showmatch = true 
vim.opt.matchtime = 2 
vim.opt.matchtime = 2 

--File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 300 
vim.opt.timeoutlen = 500 
vim.opt.ttimeoutlen = 0 
vim.opt.autoread = true
vim.opt.autowrite = false
