vim.opt.formatoptions:remove{'c','r','o'} -- has to be in after/ftplugin to run after the system ftplugin/java.vim which sets formatoptions
-- see :help vim.opt
-- see :help vim.opt:append() -- remember that formatoptions is a string-style option
-- see :help formatoptions, defautl "tcqj"ho
-- see :help fo-options
-- c: auto-wrap comments using 'textwidth', inserting the current comment leader automatically
-- r: automatically insert the current comment leader after hitting <Enter> in Insert Mode
-- o: Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode. In case comment is unwanted use CTRL-U to quickly delete it.

-- indent related options are set on ~/.config/nvim/indent.java
