return function()

	local tlib = require'signal.lib.theme'

	local alpha = require'alpha'

	local header = {[[im gay]]}
	local header_width = 6
	local header_layout = {
		type = "text",
		val = header,
		opts = {
			position = "center",
			hl = "Type"
		}
	}

	local function mk_button(icon, label, on_press, shortcut)
		return {
			type = "button",
			val = icon .. "	" .. label,
			on_press = on_press,
			opts = {
				position = "center",
				width = 48,
				shortcut = shortcut,
				align_shortcut = "right",
				hl_shortcut = "Keyword"
			}
		}
	end

	local layout = {
		{ type = "padding", val = 2 },
		header_layout,
		{ type = "padding", val = 2 },
		mk_button("", "Load session", function() vim.cmd('SessionManager load_session') end, ";vsls"),
		mk_button("", "Recent projects", function() require('telescope').extensions.projects.projects() end, ";ffp"),
		mk_button("", "Refresh logo", function()
			local h_str, h_width = tlib.get_header()
			header_layout.val = h_str
			header_width = h_width
			alpha.redraw()
		end, ""),
		mk_button("⎋", "Quit", function() vim.cmd('quit') end, ':q')
	}

	local theme = {
		header = header_layout,
		header_width = header_width,
		config = {
			layout = layout,
			opts = {
				margin = 0,
				setup = function()
					local h_str, h_width = tlib.get_header()
					header_layout.val = h_str
					header_width = h_width
					-- vim.api.nvim_create_autocmd('DirChanged', {
					-- 	pattern = '*',
					-- 	callback = alpha.redraw
					-- })
				end
			}
		}
	}

	theme.header.val = header

	alpha.setup(theme.config)

	-- local db = require("dashboard")
	--
	-- db.session_directory = cache .. "/sessions"
	--
	-- db.preview_command = "cat | sed '$d'"
	-- db.preview_file_width = 0
	-- db.preview_file_height = 0
	-- db.preview_file_path = function() select_header({headers_dir}) end
	-- db.custom_center = {
 --      { icon = '', desc = '	Most Recent Session', action ='SessionLoad' },
 --   }

end
