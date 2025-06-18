local get_kopts = function(bufnr)
	local kopts_base = { noremap = true, silent = true, buffer = bufnr }
	return function(desc, nowait)
		if desc == nil then
			return kopts_base
		else
			return {
				noremap = kopts_base["noremap"],
				silent = kopts_base["silent"],
				buffer = kopts_base["buffer"],
				desc = desc,
				nowait = nowait or false,
			}
		end
	end
end
local set_lsp_keymaps = function(on_attach)
	return function(client, bufnr)
		local kopts = get_kopts(bufnr)

		vim.keymap.set("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, kopts("go to definition"))
		vim.keymap.set("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, kopts("go to declaration"))
		vim.keymap.set("n", "gR", function()
			Snacks.picker.lsp_references()
		end, kopts("go to references", true))
		vim.keymap.set("n", "gI", function()
			Snacks.picker.lsp_implementations()
		end, kopts("go to implementation"))
		vim.keymap.set("n", "gy", function()
			Snacks.picker.lsp_implementations()
		end, kopts("go to type definition"))

		vim.keymap.set("n", "<Leader>fls", function()
			Snacks.picker.lsp_symbols()
		end, kopts("find LSP symbol"))
		vim.keymap.set("n", "<Leader>flS", function()
			Snacks.picker.lsp_workspace_symbols()
		end, kopts("find LSP workspace symbol"))

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
		local ts = require("telescope")
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

		if on_attach ~= nil then
			on_attach(client, bufnr)
		end
	end
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
		dependencies = {},
		event = { "BufRead Cargo.toml" },
		opts = {
			lsp = {
				enabled = true,
				on_attach = set_lsp_keymaps(nil),
				actions = true,
				completion = true,
				hover = true,
			},
			neoconf = {
				enabled = true,
				namespace = "crates",
			},
		},
	},
	-- {
	-- 	"cordx56/rustowl",
	-- 	version = "*",
	-- 	build = "cd rustowl && cargo install --path . --locked",
	-- 	lazy = false,
	-- 	opts = {
	-- 		client = {
	-- 			on_attach = function(_, bufnr)
	-- 				local kopts = get_kopts(bufnr)
	-- 				vim.keymap.set("n", "<Leader>lro", function()
	-- 					require("rustowl").toggle(bufnr)
	-- 				end, kopts("toggle rustowl"))
	-- 			end,
	-- 		},
	-- 	},
	-- },
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
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
					code_actions = {
						ui_select_fallback = true,
					},
					test_executor = "background",
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
						set_lsp_keymaps(nil)(client, bufnr)
						local kopts = get_kopts(bufnr)
						-- vim.keymap.set("n", "gra", "<cmd>RustLsp codeAction<cr>", kopts("code action"))
						vim.keymap.set("n", "grd", "<cmd>RustLsp relatedDiagnostics<cr>", kopts("related diagnostics"))
						vim.keymap.set("n", "glp", "<cmd>RustLsp parentModule<cr>", kopts("go to parent module"))
						vim.keymap.set(
							"n",
							"gsD",
							"<cmd>RustLsp openDocs<cr>",
							kopts("open docs.rs for current symbol")
						)

						vim.keymap.set({ "n", "v" }, "<Leader>llj", "<cmd>RustLsp joinLines<cr>", kopts("join lines"))

						vim.keymap.set({ "n", "v" }, "<Leader>lrs", function()
							vim.cmd.RustLsp("ssr", "<query>")
						end, kopts("structural search replace"))

						vim.keymap.set(
							"n",
							"<Leader>lex",
							"<cmd>RustLsp explainError current<cr>",
							kopts("explain error")
						)
						vim.keymap.set(
							"n",
							"<Leader>leX",
							"<cmd>RustLsp explainError cycle<cr>",
							kopts("explain next error")
						)
						vim.keymap.set(
							"n",
							"<Leader>led",
							"<cmd>RustLsp renderDiagnostic current<cr>",
							kopts("view diagnostic")
						)
						vim.keymap.set(
							"n",
							"<Leader>leD",
							"<cmd>RustLsp renderDiagnostic cycle<cr>",
							kopts("view next diagnostic")
						)

						vim.keymap.set("n", "<Leader>lpc", "<cmd>RustLsp openCargo<cr>", kopts("open cargo.toml"))
						vim.keymap.set("n", "<Leader>lmx", "<cmd>RustLsp expandMacro<cr>", kopts("view expanded macro"))

						vim.keymap.set("n", "<Leader>rr", "<cmd>RustLsp runnables<cr>", kopts("run runnable"))
						vim.keymap.set("n", "<Leader>rR", "<cmd>RustLsp runnables!<cr>", kopts("run last runnable"))

						vim.keymap.set("n", "<Leader>dr", "<cmd>RustLsp debuggables<cr>", kopts("run debuggable"))
						vim.keymap.set("n", "<Leader>dR", "<cmd>RustLsp! debuggables<cr>", kopts("run last debuggable"))

						vim.keymap.set("n", "<Leader>ltt", "<cmd>RustLsp! testables<cr>", kopts("run last testable"))
						vim.keymap.set("n", "<Leader>ltT", "<cmd>RustLsp testables<cr>", kopts("run testable"))
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
				"<Leader>sr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "rename lsp symbol",
				expr = true,
			},
		},
		opts = {},
	},
	{
		"slint-ui/vim-slint",
		enabled = false,
	},
	-- {
	-- 	"dgagn/diagflow.nvim",
	-- 	enabled = true,
	-- 	event = { "LspAttach" },
	-- 	opts = {
	-- 		scope = "line",
	-- 		show_borders = true,
	-- 		show_sign = false,
	-- 	},
	-- },
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
			-- "hrsh7th/nvim-cmp",
			-- "ms-jpq/coq_nvim",
			"saghen/blink.cmp",
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
			["gdscript"] = {},
			["gdshader_lsp"] = {},
			["csharp_ls"] = {},
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

			for srv, cfg in pairs(opts) do
				cfg.on_attach = set_lsp_keymaps(cfg.on_attach)
				cfg.capabilities = require("blink.cmp").get_lsp_capabilities(cfg.capabilities)
				vim.lsp.config(srv, cfg)
				vim.lsp.enable(srv)
			end
		end,
	},
}
