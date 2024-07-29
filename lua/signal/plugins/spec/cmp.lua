local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
	},
	{
		"ms-jpq/coq.artifacts",
		enabled = false,
		lazy = true,
		branch = "artifacts",
	},
	{
		"ms-jpq/coq.thirdparty",
		enabled = false,
		lazy = true,
		branch = "3p",
		opts = {
			{ src = "dap" },
		},
		config = function(_, opts)
			require("coq_3p")(opts)
		end,
	},
	{
		"ms-jpq/coq_nvim",
		enabled = false,
		branch = "coq",
		dependencies = {
			"ms-jpq/coq.artifacts",
			"ms-jpq/coq.thirdparty",
		},
		build = ":COQdeps",
		init = function()
			vim.g.coq_settings = {
				auto_start = "shut-up",
				xdg = true,
				clients = {
					tmux = {
						enabled = false,
					},
				},
			}
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		-- enabled = false,
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			-- "hrsh7th/cmp-path", -- superseded by cmp-async-path
			"hrsh7th/cmp-cmdline",
			{
				url = "https://codeberg.org/FelipeLema/cmp-async-path",
			},
		},
		event = { "InsertEnter", "CmdLineEnter" },
		config = function(_, _)
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources(
					{ { name = "nvim_lsp" } },
					{ { name = "buffer" } },
					{ { name = "async_path" } }
				),
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if not entry then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							else
								cmp.confirm()
							end
						else
							fallback()
						end
					end, { "i", "s", "c" }),
					-- ["<Tab>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_next_item()
					-- 	-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- 	-- that way you will only jump inside the snippet region
					-- 	elseif luasnip.expand_or_jumpable() then
					-- 		luasnip.expand_or_jump()
					-- 	elseif has_words_before() then
					-- 		cmp.complete()
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
					-- ["<S-Tab>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_prev_item()
					-- 	elseif luasnip.jumpable(-1) then
					-- 		luasnip.jump(-1)
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
					-- ["<CR>"] = cmp.mapping({
					-- 	i = function(fallback)
					-- 		if cmp.visible() and cmp.get_active_entry() then
					-- 			cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
					-- 		else
					-- 			fallback()
					-- 		end
					-- 	end,
					-- 	s = cmp.mapping.confirm({ select = true }),
					-- 	c = function(fallback)
					-- 		if cmp.visible() and cmp.get_active_entry() then
					-- 			cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
					-- 		else
					-- 			fallback()
					-- 		end
					-- 	end,
					-- }),
				}),
			})
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources(
					{ { name = "async_path" } },
					{ { name = "cmdline", option = {
						ignore_cmds = { "Man", "!" },
					} } }
				),
			})
		end,
	},
	{
		"PaterJason/cmp-conjure",
		dependencies = { "hrsh7th/nvim-cmp" },
		lazy = true,
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, { name = "conjure" })
			return cmp.setup(config)
		end,
	},
}
