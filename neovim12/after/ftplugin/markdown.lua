require("nvim-surround").buffer_setup({
	surrounds = {
		["l"] = {
			add = function()
				local clipboard = vim.fn.getreg("+"):gsub("\n", "")
				return {
					{ "[" },
					{ "](" .. clipboard .. ")" },
				}
			end,
			find = "%b[]%b()",
			delete = "^(%[)().-(%]%b())()$",
			change = {
				target = "^()()%b[]%((.-)()%)$",
				replacement = function()
					local clipboard = vim.fn.getreg("+"):gsub("\n", "")
					return {
						{ "" },
						{ clipboard },
					}
				end,
			},
		},
	},
})
