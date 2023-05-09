local encoding = function()
    local ret,_ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
end

local fileformat = function()
    local ret,_ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
end

require('lualine').setup {
    options = {
        component_separators = '',
        section_separators = { left = '', right = '' }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename', 'filesize' },
        lualine_x = { encoding, fileformat, 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}
