Plugins
=======

-	nvim-lspconfig
	-	lua, python, golant
-	nvim-tresitter (syntax highlighting + conceal, folds, context)
	-	nvim-tresitter-context, provides context.scm for many languages, 
        that enables to pin lines at the top that provide context
-	conform.nvim for formatting / format on save
-	snacks.nvim for picker / fzf / search files / buffers / etc
-	switch.vim for cycle between enable/disable, true/false, etc

TODO
====

-	Add indentation settings for python filetype, terraform
-	add snippets manager / luasnip
-	vim-fugitive (do we need this or it's better to use lazygit for this kind of stuff)
-	EasyAlign / vim-lion / mini.nvim

DONE
====

-	cycle words
-	add skeleton file
-   Copy github url  / snacks.nvim has gitbrowse, but is there a url copy? Yes you can
    use Snacks.gitbrowse(open=function(url) end) to copy to the clipboard / pasteboard
-	Remember the last position in file
-	Add nvim-treesitter-context
