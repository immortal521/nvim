local wk = require 'which-key'
local Snacks = require 'snacks'
local map = vim.keymap.set

local term_normal = {
    'jk',
    function()
        vim.cmd 'stopinsert'
    end,
    mode = 't',
    expr = false,
    desc = 'Single escape to normal mode',
}

local win = {
    position = 'float',
    border = 'rounded',
    keys = {
        term_normal = term_normal,
    },
}

map('n', '<leader>tf', function()
    Snacks.terminal(nil, { win = win })
end, { desc = 'Terminal Float' })

map('n', '<leader>tm', function()
    Snacks.terminal('music-player', { win = win })
end, { desc = 'Music Player', silent = true, noremap = true })

map('n', '<leader>ts', function()
    Snacks.picker.buffers {
        hidden = true,
        filter = {
            filter = function(item, filter)
                if filter(item) and item.file:sub(1, 4) == 'term' then
                    return true
                end
                return false
            end,
        },
    }
end, { desc = 'terminal find' })

map('i', 'jk', '<esc>')

wk.add {
    { '<leader>a', mode = 'nxv', group = 'Ai', icon = '' },
}
