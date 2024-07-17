local M = {}
function M.setup()
vim.api.nvim_create_user_command('Rename', function(opts)
    -- Rename current file to new name
    local current_name = vim.fn.expand('%')
    local new_name = opts.fargs[1]
    local new_name_in_path = vim.fn.expand('%:h') .. '/' .. new_name
    vim.fn.rename(current_name, new_name_in_path)
    vim.api.nvim_cmd({
      cmd='file',
      args={new_name_in_path},
    },{})
end, { nargs = 1 })
end
return M
