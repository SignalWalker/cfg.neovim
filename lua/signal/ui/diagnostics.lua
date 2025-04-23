vim.diagnostic.config({
	severity_sort = true,
	virtual_text = {
		source = "if_many",
	},
	float = {
		scope = "line",
		severity_sort = true,
		source = "if_many",
		border = "double",
	},
})
