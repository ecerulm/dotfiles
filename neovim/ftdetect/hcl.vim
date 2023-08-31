" There is no filetype hcp, it's terraform 
" we tell treesitter to use hcl parser for terraform filetype 
" in after/plugins/treesitter.lua 
"
"

" au! BufNewFile,BufRead *.tf set filetype=hcl
" au! BufNewFile,BufRead *.tf :setfiletype hcl
