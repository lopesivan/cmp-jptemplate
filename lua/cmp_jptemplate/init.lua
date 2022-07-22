local cmp = require('cmp')
local util = require('vim.lsp.util')
--local cmp_snippets = require("cmp_nvim_ultisnips.snippets")

local source = {}
source.new = function()
	return setmetatable({}, { __index = source })
end

source.get_keyword_pattern = function()
	return '\\%([^[:alnum:][:blank:]]\\|\\w\\+\\)'
end

function source:get_debug_name()
	return 'jptemplate'
end

function source:complete(_, callback)

	local path = string.format(
		"%s/%s",
		vim.fn.expand('~/.config/nvim/jptemplate/'),
		vim.bo.filetype)

	local paths = vim.fn.globpath(path, "*", true, true)

	local snippets = {}
	for _, file in ipairs(paths) do
		local snippet = vim.fn.fnamemodify(file, ":t:r")
		table.insert(snippets, snippet)
	end

	local items = {}
	for _, value in pairs(snippets) do
		local item = {
			word = value,
			label = value,
			user_data = value,
			kind = cmp.lsp.CompletionItemKind.Snippet,
		}
		items[#items + 1] = item
	end

	callback(items)
end

function source:execute(completion_item, callback)
	vim.call('JptemplateExpandSnippet')
	callback(completion_item)
end

function source:is_available()
	-- if UltiSnips is installed then this variable should be defined
	return true
end

return source
