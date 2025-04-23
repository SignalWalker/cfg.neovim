local M = {}

--- randomly select and return the path to a header file from the ones available
function M.choose_header_file()
	local function select_header_path(header_dirs)
		local headers = {}
		for _, dirname in ipairs(header_dirs) do
			for entryname, entrytype in vim.fs.dir(dirname) do
				if entrytype == "file" then
					table.insert(headers, dirname .. "/" .. entryname)
				end
			end
		end

		-- NOTE :: don't forget to run math.randomseed() before this
		return headers[math.random(1, #headers)]
	end

	local headers_dir = vim.fn.stdpath("config") .. "/assets/headers"
	if vim.opt.columns:get() >= 160 then
		return select_header_path({ headers_dir .. "/wide", headers_dir .. "/terminal" })
	else
		return select_header_path({ headers_dir .. "/terminal" })
	end
end

local function pad_str(input, width)
	local output = input

	while vim.fn.strwidth(output) < width do
		output = output .. " "
	end

	return output
end

--- randomly select a header file and read it to a string, with each line padded such that all lines are the same width
function M.choose_header_str()
	local hpath = M.choose_header_file()
	local hfile = io.open(hpath, "r")
	if hfile ~= nil then
		local lines = {}
		local width = 0
		for line in hfile:lines("*l") do
			if line == nil then
				goto continue
			end
			local llen = vim.fn.strwidth(line)
			if llen > width then
				width = llen
			end
			table.insert(lines, line)
			::continue::
		end
		hfile:close()
		local header = ""
		for _, line in ipairs(lines) do
			header = header .. pad_str(line, width) .. "\n"
		end
		return header
	else
		return [[ awawa ]]
	end
end

--- split header file into `(table of lines, width of longest line)`
-- @param header_path path to header file
function M.split_header(header_path)
	local header = {}
	local width = 0
	for line in io.lines(header_path) do
		if line ~= nil and #line > width then
			width = #line
		end
		table.insert(header, line)
	end

	if #header == 0 then
		vim.notify("Failed to read header from " .. header_path, vim.log.levels.error)
		header = { [[ awawa ]] }
		-- TODO :: is this the correct syntax...?
		width = #header[0]
	end

	return header, width
end

return M
