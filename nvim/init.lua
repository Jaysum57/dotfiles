-- A. Set a colorscheme (Optional, but recommended to ensure syntax colors are loaded)
-- Replace 'tokyonight' with your preferred colorscheme if you have one installed.
-- If you don't use a colorscheme, Neovim will use terminal colors by default.

-- B. Define a function to set the background to NONE for essential groups
local function set_transparency()
    -- Normal: The main editor background
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })

    -- NormalNC: The background of non-current (inactive) windows/splits
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
    
    -- NormalFloat: Background of floating windows (like LSP hover or Telescope)
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

    -- FloatBorder: The border around floating windows
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

    -- SignColumn: The column on the left where signs (like Git diffs) are placed
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

    -- Note: This is an old Vimscript way, but some themes rely on it
    vim.cmd [[ highlight EndOfBuffer guibg=none ]]
end

-- C. Apply the function on startup
set_transparency()

-- D. Re-apply the function every time the colorscheme is changed
-- This is crucial because loading a colorscheme often resets the background.
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = set_transparency,
    desc = 'Ensure background remains transparent after colorscheme change',
})

-- If you are using a plugin manager to install your colorscheme, ensure the 
-- transparency code runs *after* the colorscheme is loaded.

-- Sync all yanks (y), deletes (d), and pastes (p) to system clipboard
vim.opt.clipboard = "unnamedplus"


