return {
	"AndrewRadev/switch.vim",
	enabled = true,
	lazy = false,
	init = function()
		vim.g.switch_mapping = 'gs' -- the default mapping is gs
	end,
	config = function()
		vim.g.switch_custom_definitions = {
			{ 'Enabled', 'Disabled' },
			{ '==', '!=' },
		}
	end,
}
