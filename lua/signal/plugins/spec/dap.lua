return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {},
		event = "LspAttach",
		config = function(_, _)
			local dap = require("dap")
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "LspAttach",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		opts = {},
		config = function(plugin, opts)
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup(opts)

			dap.listeners.before.attach.dapui_config = function()
				require("nvim-tree.api").tree.close()
				require("trouble").close()
				dapui.open()
			end

			dap.listeners.before.launch.dapui_config = function()
				require("nvim-tree.api").tree.close()
				require("trouble").close()
				dapui.open()
			end

			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end

			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
