return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter').setup {
            install_dir = vim.fn.stdpath('data') .. '/site',
        }
        require('nvim-treesitter').install({
            'lua', 'tsx', 'c', 'python',
            'typescript', 'html', 'css', 'php',
        }):wait(300000)
    end
}
