-- Formatters come from the project's node_modules/.bin only, never a global install.
-- Python (ruff) and Go (gopls) format through their language servers.

--- Override a conform formatter to use the project-local binary
local function local_bin(name)
	return {
		command = function(_, ctx)
			local dir = Utils.lsp.find_bin(ctx.dirname, "node_modules/.bin/" .. name)
			return dir and (dir .. "/node_modules/.bin/" .. name) or name
		end,
		condition = function(_, ctx)
			return Utils.lsp.find_bin(ctx.dirname, "node_modules/.bin/" .. name) ~= nil
		end,
	}
end

-- First one the project has wins
local web = { "oxfmt", "biome", "prettier", stop_after_first = true }

require("conform").setup({
	formatters_by_ft = {
		javascript = web,
		javascriptreact = web,
		typescript = web,
		typescriptreact = web,
		svelte = web,
		astro = web,
		json = web,
		jsonc = web,
		css = web,
		scss = web,
		html = web,
		markdown = web,
		yaml = web,
	},
	formatters = {
		oxfmt = local_bin("oxfmt"),
		biome = local_bin("biome"),
		prettier = local_bin("prettier"),
	},
	default_format_opts = {
		lsp_format = "fallback",
		-- Only these servers format; ts_ls and friends never do
		filter = function(client)
			return client.name == "ruff" or client.name == "gopls"
		end,
	},
	format_on_save = { timeout_ms = 1000 },
	-- Projects without a formatter just save as-is; :ConformInfo shows what's available
	notify_no_formatters = false,
})
