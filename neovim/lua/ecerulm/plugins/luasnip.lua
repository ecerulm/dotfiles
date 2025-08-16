return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")
		local fmt = require("luasnip.extras.fmt").fmt
		local s = ls.snippet
		local i = ls.insert_node

		ls.add_snippets("tex", {
      s("test1", fmt("This uses {first} and {second}",{first=i(1,"first"),second=i(2,"second")})),
      s(
        "tikz",
        fmt(
          [[
          \documentclass[tikz,convert={svg,command=\unexpanded{{inkscape\space --pdf-poppler\space --export-type="svg"\space --pages=1\space -o\space \outfile\space \infile}}}]{standalone}
          \begin{document}
          \begin{tikzpicture}
          <>
          \end{tikzpicture}
          \end{document}
          ]],
          {i(1)},
          {delimiters='<>'}
        )
      ),
		}) -- add_snippets
	end,
}
