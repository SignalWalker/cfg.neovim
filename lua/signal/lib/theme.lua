local M = {}

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

		return headers[math.random(1, #headers)]
	end

	local headers_dir = vim.fn.stdpath("config") .. "/assets/headers"

	return select_header_path({ headers_dir .. "/wide", headers_dir .. "/terminal" })
end

function M.read_header(header_path)
	local header = ""
	local width = 0
	for line in io.lines(header_path) do
		if line ~= nil and #line > width then
			width = #line
		end
		table.insert(header, line)
	end

	if #header == 0 then
		vim.notify("Failed to read header from " .. header_path, vim.log.levels.error)
		header = { [[im gay]] }
	end

	return header, width
end

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
		header = { [[im gay]] }
	end

	return header, width
end

return M
