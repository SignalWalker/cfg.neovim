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

local home_dir = vim.env.HOME or "/home/ash"
local projects_dir = vim.env.XDG_PROJECTS_DIR or (home_dir .. "/projects")
-- TODO :: make this less brittle
local sys_flake_path = projects_dir .. "/nix/sys/desktop"
local sys_flake_expr = '(builtins.getFlake "' .. sys_flake_path .. '")'
local sys_nixos_expr = sys_flake_expr .. ".nixosConfigurations." .. vim.fn.hostname()

local lsp_cfgs = {
	-- default config for all language servers
	["*"] = {
		root_markers = { ".jj", ".git", "flake.nix" },
	},
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
	["qmlls"] = {
		cmd = { "qmlls", "-E" },
	},
	["nixd"] = {
		settings = {
			formatting = {
				command = "nix fmt",
			},
			nixpkgs = {
				expr = "import " .. sys_flake_expr .. ".inputs.nixpkgs {}",
			},
			options = {
				nixos = {
					expr = sys_nixos_expr .. ".options",
				},
				["home-manager"] = {
					expr = sys_nixos_expr .. ".options.home-manager.users.type.getSubOptions []",
				},
			},
		},
	},
}

for srv, cfg in pairs(lsp_cfgs) do
	vim.lsp.config(srv, cfg)
	if srv ~= "*" then
		vim.lsp.enable(srv)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("ashvim.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local kopts = get_kopts(args.buf) -- common keymap options

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

		local Snacks = require("snacks")

		-- TODO :: make these conditional on LSP method support
		vim.keymap.set("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, kopts("go to definition"))
		vim.keymap.set("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, kopts("go to declaration"))
		vim.keymap.set("n", "gR", function()
			Snacks.picker.lsp_references()
		end, kopts("go to references", true))
		vim.keymap.set("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, kopts("go to type definition"))

		vim.keymap.set("n", "<Leader>fls", function()
			Snacks.picker.lsp_symbols()
		end, kopts("find LSP symbol"))
		vim.keymap.set("n", "<Leader>flS", function()
			Snacks.picker.lsp_workspace_symbols()
		end, kopts("find LSP workspace symbol"))

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

		if client:supports_method("textDocument/implementation") then
			vim.keymap.set("n", "gI", function()
				Snacks.picker.lsp_implementations()
			end, kopts("go to implementation"))
		end

		-- Enable auto-completion.
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		-- TODO :: better dap

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

		-- language-specific
		-- -- rust
		if vim.bo.filetype == "rust" then
			vim.keymap.set("n", "grd", "<cmd>RustLsp relatedDiagnostics<cr>", kopts("related diagnostics"))
			vim.keymap.set("n", "glp", "<cmd>RustLsp parentModule<cr>", kopts("go to parent module"))
			vim.keymap.set("n", "gsD", "<cmd>RustLsp openDocs<cr>", kopts("open docs.rs for current symbol"))

			vim.keymap.set({ "n", "v" }, "<Leader>llj", "<cmd>RustLsp joinLines<cr>", kopts("join lines"))

			vim.keymap.set({ "n", "v" }, "<Leader>lrs", function()
				vim.cmd.RustLsp("ssr", "<query>")
			end, kopts("structural search replace"))

			vim.keymap.set("n", "<Leader>lex", "<cmd>RustLsp explainError current<cr>", kopts("explain error"))
			vim.keymap.set("n", "<Leader>leX", "<cmd>RustLsp explainError cycle<cr>", kopts("explain next error"))
			vim.keymap.set("n", "<Leader>led", "<cmd>RustLsp renderDiagnostic current<cr>", kopts("view diagnostic"))
			vim.keymap.set("n", "<Leader>leD", "<cmd>RustLsp renderDiagnostic cycle<cr>", kopts("view next diagnostic"))

			vim.keymap.set("n", "<Leader>lpc", "<cmd>RustLsp openCargo<cr>", kopts("open cargo.toml"))
			vim.keymap.set("n", "<Leader>lmx", "<cmd>RustLsp expandMacro<cr>", kopts("view expanded macro"))

			vim.keymap.set("n", "<Leader>rr", "<cmd>RustLsp runnables<cr>", kopts("run runnable"))
			vim.keymap.set("n", "<Leader>rR", "<cmd>RustLsp runnables!<cr>", kopts("run last runnable"))

			vim.keymap.set("n", "<Leader>dr", "<cmd>RustLsp debuggables<cr>", kopts("run debuggable"))
			vim.keymap.set("n", "<Leader>dR", "<cmd>RustLsp! debuggables<cr>", kopts("run last debuggable"))

			vim.keymap.set("n", "<Leader>ltt", "<cmd>RustLsp! testables<cr>", kopts("run last testable"))
			vim.keymap.set("n", "<Leader>ltT", "<cmd>RustLsp testables<cr>", kopts("run testable"))
		end

		-- NOTE :: this should be handled by conform

		-- -- Auto-format ("lint") on save.
		-- -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		-- if
		-- 	not client:supports_method("textDocument/willSaveWaitUntil")
		-- 	and client:supports_method("textDocument/formatting")
		-- then
		-- 	vim.api.nvim_create_autocmd("BufWritePre", {
		-- 		group = vim.api.nvim_create_augroup("ashvim.lsp", { clear = false }),
		-- 		buffer = args.buf,
		-- 		callback = function()
		-- 			vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
		-- 		end,
		-- 	})
		-- end
	end,
})
