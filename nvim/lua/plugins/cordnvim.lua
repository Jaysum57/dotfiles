return {
    {
	'vyfor/cord.nvim',
	---@type CordConfig
	opts = function()
	    return {
		display = {
		    theme = 'default',
		    flavor = 'dark',
		},
		idle = {
		    -- change default idle icon to keyboard
		    icon = require('cord.api.icon').get('keyboard'),
		    -- or use another theme's idle icon
		    icon = require('cord.api.icon').get('idle', 'atom'),
		    -- or use another theme's idle icon from a different flavor
		    icon = require('cord.api.icon').get('idle', 'atom', 'light'),
		}
	    }
	end
    }
}
