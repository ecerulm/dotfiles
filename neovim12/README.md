



Plugins
=======

Update the plugins by running `:lua vim.pack.update()`

-	nvim-lspconfig
	-	lua, python, golang
-	nvim-tresitter (syntax highlighting + conceal, folds, context)
	-	nvim-tresitter-context, provides context.scm for many languages, that enables to pin lines at the top that provide context
-	conform.nvim for formatting / format on save
-	snacks.nvim for picker / fzf / search files / buffers / etc
-	switch.vim for cycle between enable/disable, true/false, etc
-	nvim-surround
-   mini.align
-   mini.comment
-   mini.ai , improved text objects
-   mini.move, use alt + hjkl
-   mini.snippets / friendly-snippets / ~/.config/nvim/snippets/<filetype>.json


# Keymaps

## Search / find / pickers

`<leader>fb`: search for open buffers
`<leader>ff`: Search for files
`<leader>fg`: search for git tracked files only
`<leader>fp`: search for projects
`<leader>fr`: search for recently opened files only
`<leader>sh`: search for vim help pages
`<leader>ss`: search for vim diagnostics



## Other

`saiw"`: surround a word with "
`sd"`: delete surrounding "
`sr)"`: replace surrounding ) with"
`<leader>gc`: copy github remote link
`gqae`: format entire file
:Format
`<leader>gg` : Open lazygit
`gs`: sort mini.operators
`gr`: replace with clipboard / mini.operators
`gx`: exchange text / mini.operators
`gm`: multiply selected text / mini.operators
`gc`: comment / mini.comment
`i_<c-j>`: trigger snippet completion / mini.snippets 
`<c-h>`: previous tabstop (in mini.snippets expanded text)
`<c-l>`: nex tabstop (in mini.snippets expanded text)
`gS`: splitjoin / mini.splitjoin 
`gs`: cycle between word alternatives / switch.nvim



TODO
====

-	Add indentation settings for python filetype, terraform
-	add snippets manager / LuaSnip
-	vim-fugitive (do we need this or it's better to use lazygit for this kind of stuff)
-   completion engine / nvim-cmp / mini.completion
-   nvim-cmp / blink.cmp
-   Check [Oil.nvim](https://github.com/stevearc/oil.nvim)
-   Replace switch.nvim with mini.cycle


TODO
====

-	Add indentation settings for python filetype, terraform
-	add snippets manager / LuaSnip


TODO
====

-	Add indentation settings for python filetype, terraform
-	add snippets manager / LuaSnip
-	vim-fugitive (do we need this or it's better to use lazygit for this kind of stuff)
-   completion engine / nvim-cmp / mini.completion
-   nvim-cmp / blink.cmp
-   Check [Oil.nvim](https://github.com/stevearc/oil.nvim)
-   Replace switch.nvim with mini.cycle

-	vim-fugitive (do we need this or it's better to use lazygit for this kind of stuff)
-   completion engine / nvim-cmp / mini.completion
-   nvim-cmp / blink.cmp
-   Check [Oil.nvim](https://github.com/stevearc/oil.nvim)
-   Replace switch.nvim with mini.cycle (not implemented yet)


DONE
====

-	cycle words / with  switch.vim
-	add skeleton file
-	Copy github url / snacks.nvim has gitbrowse, but is there a url copy? Yes you can use Snacks.gitbrowse(open=function(url) end) to copy to the clipboard / pasteboard
-	Remember the last position in file
-	Add nvim-treesitter-context
-	Remember the last position in file
-	Add indentation settings for python filetype, terraform
-	add snippets
-	vim-fugitive
-	cycle words
-	add skeleton file
-	EasyAlign / vim-lion / mini.align
-   mini.comment / gcc
-   mini

