
local function set_transparent()
    local groups = { "Normal", "NormalNC", "EndOfBuffer", "SignColumn" }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = 'none', ctermbg = 'none' })
    end
end

return {
    {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	-- Optional; default configuration will be used if setup isn't called.
	config = function()
	    require("everforest").setup({
		set_transparent()
	    })
	end,
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	opts = { 
	    theme = 'seoul256',
	}
    },
}

