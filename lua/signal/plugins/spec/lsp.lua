local set_lsp_keymaps = function(_, bufnr)
	local kopts_base = { noremap = true, silent = true, buffer = bufnr }
	local kopts = function(desc)
		if desc == nil then
			return kopts_base
		else
			return {
				noremap = kopts_base["noremap"],
				silent = kopts_base["silent"],
				buffer = kopts_base["buffer"],
				desc = desc,
			}
		end
	end

	vim.keymap.set("n", "]D", vim.lsp.buf.declaration, kopts("lsp :: goto declaration"))
	vim.keymap.set("n", "]d", vim.lsp.buf.definition, kopts("lsp :: goto definition"))
	vim.keymap.set("n", "<Leader>li", vim.lsp.buf.implementation, kopts("lsp :: goto implementation"))
	vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.references, kopts("lsp :: references"))
	vim.keymap.set("n", "<Leader>ls", vim.lsp.buf.signature_help, kopts("lsp :: signature help"))
	vim.keymap.set("n", "<Leader>la", vim.lsp.buf.code_action, kopts("lsp :: actions"))
	vim.keymap.set("n", "<Leader>'", vim.lsp.buf.hover, kopts("lsp :: hover"))

	-- -- telescope
	local ts = require("telescope")
	local tsb = require("telescope.builtin")
	vim.keymap.set("n", "<Leader>fla", function()
		tsb.lsp_code_actions()
	end, kopts("telescope :: lsp :: actions"))
	vim.keymap.set("n", "<Leader>flr", function()
		tsb.lsp_references()
	end, kopts("telescope :: lsp :: references"))
	vim.keymap.set("n", "<Leader>fld", function()
		tsb.lsp_definitions()
	end, kopts("telescope :: lsp :: definitions"))
	vim.keymap.set("n", "<Leader>flt", function()
		tsb.lsp_type_definitions()
	end, kopts("telescope :: lsp :: type definitions"))
	vim.keymap.set("n", "<Leader>fli", function()
		tsb.lsp_implementations()
	end, kopts("telescope :: lsp :: implementations"))
	vim.keymap.set("n", "<Leader>flci", function()
		tsb.lsp_incoming_calls()
	end, kopts("telescope :: lsp :: calls (incoming)"))
	vim.keymap.set("n", "<Leader>flco", function()
		tsb.lsp_outgoing_calls()
	end, kopts("telescope :: lsp :: calls (outgoing)"))
	vim.keymap.set("n", "<Leader>flsd", function()
		tsb.lsp_document_symbols()
	end, kopts("telescope :: lsp :: symbols (document)"))
	vim.keymap.set("n", "<Leader>flsw", function()
		tsb.lsp_workspace_symbols()
	end, kopts("telescope :: lsp :: symbols (workspace)"))
	vim.keymap.set("n", "<Leader>flx", function()
		tsb.diagnostics()
	end, kopts("telescope :: diagnostics"))

	-- -- trouble
	local trouble = require("trouble")
	local function toggle_trouble(mode, opts)
		local desc = {
			mode = mode,
			focus = false,
			win = {
				position = "left",
			},
		}
		if opts ~= nil then
			for k, v in pairs(opts) do
				desc[k] = v
			end
		end
		return function()
			trouble.toggle(desc)
		end
	end
	vim.keymap.set(
		"n",
		"<Leader>xs",
		toggle_trouble("lsp_document_symbols", {
			focus = true,
			-- win = {
			-- 	type = "float",
			-- 	relative = "editor",
			-- 	border = "rounded",
			-- 	-- position = { 0, -2 },
			-- 	size = { width = 0.3, height = 0.3 },
			-- },
			-- keys = {
			-- 	["<esc>"] = "close",
			-- },
		}),
		kopts("toggle lsp symbols")
	)
	vim.keymap.set("n", "<Leader>xlr", toggle_trouble("lsp_references"), kopts("toggle lsp references"))
	vim.keymap.set("n", "<Leader>xld", toggle_trouble("lsp_definitions"), kopts("toggle lsp definitions"))
	vim.keymap.set("n", "<Leader>xlt", toggle_trouble("lsp_type_definitions"), kopts("toggle lsp type definitions"))
	vim.keymap.set("n", "<Leader>xll", toggle_trouble("lsp"), kopts("toggle LSP definitions, references, etc."))

	-- -- dap
	local dap = require("dap")
	local dapui = require("dapui")
	local tsdap = ts.extensions.dap
	vim.keymap.set("n", "<Leader>du", dapui.toggle, kopts("dap :: toggle dapui"))
	vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, kopts("dap :: toggle breakpoint"))

	vim.keymap.set("n", "<F5>", dap.continue, kopts("dap :: continue"))
	vim.keymap.set("n", "<S-<F5>>", dap.restart, kopts("dap :: restart"))
	vim.keymap.set("n", "<C-S-<F5>>", dap.run_last, kopts("dap :: run last"))
	vim.keymap.set("n", "<F10>", dap.step_over, kopts("dap :: step over"))
	vim.keymap.set("n", "<F11>", dap.step_into, kopts("dap :: step into"))
	vim.keymap.set("n", "<S-<F11>>", dap.step_out, kopts("dap :: step out"))
	vim.keymap.set("n", "<Leader>dsi", dap.step_into, kopts("dap :: step into"))
	vim.keymap.set("n", "<Leader>dxx", function()
		dap.terminate({}, { terminateDebuggee = true }, dap.close)
	end, kopts("dap :: terminate"))
	vim.keymap.set("n", "<Leader>dxr", dap.restart, kopts("dap :: restart"))
	vim.keymap.set("n", "<Leader>ddc", dap.continue, kopts("dap :: continue"))
	vim.keymap.set("n", "<Leader>ddr", dap.run_last, kopts("dap :: run last"))

	vim.keymap.set("n", "<Leader>fdc", tsdap.commands, kopts("dap :: commands"))
	vim.keymap.set("n", "<Leader>fdo", tsdap.configurations, kopts("dap :: configurations"))
	vim.keymap.set("n", "<Leader>fdb", tsdap.list_breakpoints, kopts("dap :: breakpoints"))
	vim.keymap.set("n", "<Leader>fdv", tsdap.variables, kopts("dap :: variables"))
	vim.keymap.set("n", "<Leader>fdf", tsdap.frames, kopts("dap :: frames"))

	dap.listeners.before.attach.keymap_reminder = function()
		print(
			"DAP Keymaps: \n<F5>: Continue\n<S-<F5>>: Restart\n<C-S-<F5>>: Run Last\n<F10>: Step Over\n<F11>: Step Into\n<S-<F11>>: Step Out"
		)
	end
	dap.listeners.before.launch.keymap_reminder = function()
		print(
			"DAP Keymaps: \n<F5>: Continue\n<S-<F5>>: Restart\n<C-S-<F5>>: Run Last\n<F10>: Step Over\n<F11>: Step Into\n<S-<F11>>: Step Out"
		)
	end

	return kopts
end

return {
	{
		"nvim-neotest/nvim-nio",
		lazy = true,
	},
	{
		"nvim-neotest/neotest",
		event = "LspAttach",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = function(_, _)
			return {
				adapters = {
					require("rustaceanvim.neotest"),
				},
			}
		end,
	},
	{
		"saecki/crates.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp",
			-- "ms-jpq/coq_nvim",
		},
		-- tag = "stable",
		event = { "BufRead Cargo.toml" },
		opts = {
			src = {
				cmp = {
					enabled = true,
				},
				coq = {
					enabled = false,
					name = "crates.nvim",
				},
			},
			lsp = {
				enabled = true,
				on_attach = set_lsp_keymaps,
				actions = true,
				completion = true,
				hover = true,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					local cmp = require("cmp")
					cmp.setup.buffer({
						sources = cmp.config.sources(
							{ { name = "crates" } },
							{ { name = "buffer" } },
							{ { name = "async_path" } }
						),
					})
				end,
			})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false, -- handles laziness itself, apparently
		ft = { "rust" },
		init = function()
			-- local uv = vim.loop
			-- local extension_path = uv.fs_realpath(vim.env.XDG_DATA_HOME .. "/vscode/extensions/vadimcn.vscode-lldb")
			-- local codelldb_path = uv.fs_realpath(extension_path .. "/adapter/codelldb")
			-- local liblldb_path = uv.fs_realpath(extension_path .. "/lldb/lib/liblldb.so")

			vim.g.rustaceanvim = {
				tools = {
					reload_workspace_from_cargo_toml = true,
					hover_actions = {
						replace_builtin_hover = true,
					},
				},
				dap = {
					-- adapter = rustcfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
				server = {
					standalone = false,
					default_settings = {
						["rust-analyzer"] = {
							imports = {
								prefix = "crate",
								granularity = {
									enforce = true,
									group = "crate",
								},
								merge = {
									glob = false,
								},
							},
							-- check = {
							-- 	command = "clippy",
							-- },
							diagnostics = {
								experimental = {
									enable = true,
								},
							},
						},
					},
					on_attach = function(client, bufnr)
						local kopts = set_lsp_keymaps(client, bufnr)
						vim.keymap.set(
							"n",
							"<Leader>lex",
							"<cmd>RustLsp explainError<cr>",
							kopts("rust :: explain error")
							-- { desc = "rust :: explain error", silent = true, noremap = true, buffer = bufnr }
						)
						vim.keymap.set(
							"n",
							"<Leader>led",
							"<cmd>RustLsp renderDiagnostic<cr>",
							kopts("rust :: view diagnostic")
						)
						vim.keymap.set(
							"n",
							"<Leader>lpc",
							"<cmd>RustLsp openCargo<cr>",
							kopts("rust :: open Cargo.toml")
						)
						vim.keymap.set(
							"n",
							"<Leader>lpr",
							"<cmd>RustLsp runnables<cr>",
							kopts("Rust :: list runnables")
						)
						vim.keymap.set(
							"n",
							"<Leader>rr",
							"<cmd>RustLsp runnables!<cr>",
							kopts("Rust :: run last used runnable")
						)

						vim.keymap.set("n", "glp", "<cmd>RustLsp parentModule<cr>", kopts("Go to parent module (rust)"))
						vim.keymap.set(
							"n",
							"<Leader>lmx",
							"<cmd>RustLsp expandMacro<cr>",
							kopts("rust :: expand macro")
						)

						vim.keymap.set(
							"n",
							"<C-S-<F5>>",
							"<cmd>RustLsp! debuggables<cr>",
							kopts("rust :: run last debuggable")
						)
						vim.keymap.set(
							"n",
							"<Leader>dr",
							"<cmd>RustLsp debuggables<cr>",
							kopts("rust :: run debuggable")
						)

						vim.keymap.set(
							"n",
							"<Leader>ltt",
							"<cmd>RustLsp! testables<cr>",
							kopts("rust :: run last testable")
						)
						vim.keymap.set("n", "<Leader>ltl", "<cmd>RustLsp testables<cr>", kopts("rust :: run testable"))
					end,
				},
			}
		end,
	},
	{
		"folke/neoconf.nvim",
		opts = {
			import = {
				vscode = false,
				coc = false,
				nlsp = false,
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"smjonas/inc-rename.nvim",
		event = { "LspAttach" },
		keys = {
			{
				"<Leader>rn",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "lsp :: rename",
				expr = true,
			},
		},
		opts = {},
	},
	{
		"slint-ui/vim-slint",
		enabled = false,
	},
	{
		"dgagn/diagflow.nvim",
		enabled = true,
		event = { "LspAttach" },
		opts = {
			scope = "line",
			show_borders = true,
			show_sign = false,
		},
	},
	{
		"RaafatTurki/corn.nvim",
		enabled = false,
		init = function()
			vim.diagnostic.config({ virtual_text = false })
		end,
		opts = {
			border_style = "double",
			on_toggle = function(is_hidden)
				vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
			end,
		},
	},
	{
		"https://gitlab.com/HiPhish/guile.vim",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"neoconf.nvim",
			"hrsh7th/nvim-cmp",
			-- "ms-jpq/coq_nvim",
		},
		opts = {
			["lua_ls"] = {},
			-- ["tailwindcss"] = {},
			["taplo"] = {},
			["jsonls"] = {},
			["slint_lsp"] = {},
			["guile_ls"] = {},
			["clangd"] = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--header-insertion-decorators",
				},
				init_options = {
					fallback_flags = {},
				},
			},
			["cssls"] = {},
			["eslint"] = {},
			["ts_ls"] = {},
		},
		config = function(_, opts)
			local lsp = require("lspconfig")

			opts["nixd"] = {
				root_dir = lsp.util.root_pattern(".nixd.json", "flake.nix"),
				settings = {
					["nixd"] = {
						formatting = {
							command = "nix fmt",
						},
					},
				},
			}

			local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- local cmp_capabilities = require("coq").lsp_ensure_capabilities()
			for srv, cfg in pairs(opts) do
				if cfg["on_attach"] == nil then
					cfg.on_attach = set_lsp_keymaps
				end
				if cfg["capabilities"] == nil then
					cfg.capabilities = cmp_capabilities
				end
				lsp[srv].setup(cfg)
			end
		end,
	},
}
