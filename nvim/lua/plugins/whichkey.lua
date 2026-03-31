return {
    "folke/which-key.nvim",
    dependencies = {
	'nvim-lua/plenary.nvim',
	-- optional but recommended
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    event = "VeryLazy",
    opts = {
	-- your configuration comes here },
    },
    keys = {
	{
	    "<leader>?",
	    function()
		require("which-key").show({ global = false })
	    end,
	    desc = "Buffer Local Keymaps (which-key)",
	},
    },
}


