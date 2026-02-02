-- Debugging Support
return {
	-- https://github.com/rcarriga/nvim-dap-ui
	"rcarriga/nvim-dap-ui",
	enabled = true,
	lazy = false,
	-- event = 'VeryLazy',
	dependencies = {
		-- https://github.com/mfussenegger/nvim-dap
		"mfussenegger/nvim-dap",
		-- "nvim-telescope/telescope-dap.nvim", -- telescope integration with dap
		"nvim-neotest/nvim-nio",

		-- https://github.com/theHamsta/nvim-dap-virtual-text
		-- "theHamsta/nvim-dap-virtual-text", -- inline variable text while debugging
	},
	-- opts = {
	-- 	controls = {
	-- 		element = "repl",
	-- 		enabled = false,
	-- 		icons = {
	-- 			disconnect = "",
	-- 			pause = "",
	-- 			play = "",
	-- 			run_last = "",
	-- 			step_back = "",
	-- 			step_into = "",
	-- 			step_out = "",
	-- 			step_over = "",
	-- 			terminate = "",
	-- 		},
	-- 	},
	-- 	element_mappings = {},
	-- 	expand_lines = true,
	-- 	floating = {
	-- 		border = "single",
	-- 		mappings = {
	-- 			close = { "q", "<Esc>" },
	-- 		},
	-- 	},
	-- 	force_buffers = true,
	-- 	icons = {
	-- 		collapsed = "",
	-- 		current_frame = "",
	-- 		expanded = "",
	-- 	},
	-- 	layouts = {
	-- 		{
	-- 			elements = {
	-- 				{
	-- 					id = "scopes",
	-- 					size = 0.50,
	-- 				},
	-- 				{
	-- 					id = "stacks",
	-- 					size = 0.30,
	-- 				},
	-- 				{
	-- 					id = "watches",
	-- 					size = 0.10,
	-- 				},
	-- 				{
	-- 					id = "breakpoints",
	-- 					size = 0.10,
	-- 				},
	-- 			},
	-- 			size = 40,
	-- 			position = "left", -- Can be "left" or "right"
	-- 		},
	-- 		{
	-- 			elements = {
	-- 				"repl",
	-- 				"console",
	-- 			},
	-- 			size = 10,
	-- 			position = "bottom", -- Can be "bottom" or "top"
	-- 		},
	-- 	},
	-- 	mappings = {
	-- 		edit = "e",
	-- 		expand = { "<CR>", "<2-LeftMouse>" },
	-- 		open = "o",
	-- 		remove = "d",
	-- 		repl = "r",
	-- 		toggle = "t",
	-- 	},
	-- 	render = {
	-- 		indent = 1,
	-- 		max_value_lines = 100,
	-- 	},
	-- },
	config = function(_, opts)
		local dap, dapui = require("dap"), require("dapui")
		require("dapui").setup(opts)
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			-- dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			-- dapui.close()
		end
	end,
}
