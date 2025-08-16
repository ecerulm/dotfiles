import vim

def fn_underscores(filename):
	return filename.replace(".","_").upper()

def expand(snip):
	if snip.tabstop != 1:
		return
	vim.eval('feedkeys("\<C-R>=UltiSnips#ExpandSnippet()\<CR>")')
