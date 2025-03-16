vim.opt_local.formatoptions:remove{"c", "r", "o"}
-- vim.opt_local.formatoptions:append("cro") 

-- see : h vim.opt 
-- see :h vim.opt:append()

-- c: Autowrap text using textwidth
-- r: Automaticall insert the current comment leader after hitting <Enter> in Insert mode
-- o: Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode. In case comment is 
--    unwanted  in a specific place use CTRL-U to quickly delete it
