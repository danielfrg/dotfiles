-- Project-local language servers: no Mason, no global installs.
-- Each server only starts when the project declares and installs it
-- (node_modules/.bin, .venv/bin, or a `tool` line in go.mod).
local M = {}

---@class ProjectServer
---@field tool string Name shown in notices (e.g. "ruff")
---@field markers string[] Files that mark a project of this kind (e.g. { "pyproject.toml" })
---@field bin? string Executable path relative to a project dir (e.g. ".venv/bin/ruff")
---@field args? string[] Arguments for `bin`
---@field go_tool? string Module path declared with `tool` in go.mod; runs `go tool <name>`
---@field wants? fun(root: string): boolean Only expect this server when it returns true
---@field install? fun(root: string, declared: boolean): string Hint shown when missing

---@type table<string, ProjectServer>
M.servers = {}

local notified = {}

local function read(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

--- Whether `file` (relative to `root`) mentions `text`
function M.mentions(root, file, text)
	local content = read(root .. "/" .. file)
	return content ~= nil and content:find(text, 1, true) ~= nil
end

--- Walk upward from `start` and return the first dir that has an executable `bin`
function M.find_bin(start, bin)
	for dir in vim.fs.parents(start .. "/_") do
		if vim.fn.executable(dir .. "/" .. bin) == 1 then
			return dir
		end
		if dir == vim.env.HOME then
			return nil
		end
	end
end

--- Resolve a server for a path (file or dir). Returns the root to start in, or nil.
--- `missing` is set when the project expects the server but it isn't installed.
local function resolve(spec, path)
	local root = vim.fs.root(path, spec.markers)
	if not root or (spec.wants and not spec.wants(root)) then
		return nil
	end
	if spec.go_tool then
		local declared = M.mentions(root, "go.mod", spec.go_tool)
		return declared and root or nil, not declared and root or nil
	end
	local found = M.find_bin(vim.fs.dirname(path .. "/_"), spec.bin)
	return found, not found and root or nil
end

--- Whether the project (or a parent, for monorepos) declares the tool
local function declared(spec, root)
	for dir in vim.fs.parents(root .. "/_") do
		local pyproject = read(dir .. "/pyproject.toml") or ""
		if
			M.mentions(dir, "package.json", '"' .. spec.tool .. '"')
			or pyproject:find('"' .. vim.pesc(spec.tool) .. '[%s<>=~!"%[]') ~= nil
		then
			return true
		end
		if dir == vim.env.HOME then
			return false
		end
	end
	return false
end

local function hint(spec, root)
	return spec.install and (" → " .. spec.install(root, declared(spec, root))) or ""
end

-- Missing servers are queued and shown together in one notice, once per tool and project
local queue = {}

local function flush()
	table.sort(queue, function(a, b)
		return a.spec.tool < b.spec.tool
	end)
	local lines = {}
	for _, e in ipairs(queue) do
		table.insert(lines, ("%s (%s)%s"):format(e.spec.tool, vim.fn.fnamemodify(e.root, ":~"), hint(e.spec, e.root)))
	end
	queue = {}
	if #lines > 0 then
		vim.notify("LSP not installed in project:\n" .. table.concat(lines, "\n"), vim.log.levels.WARN)
	end
end

local function notify_missing(spec, root)
	local key = spec.tool .. "@" .. root
	if notified[key] then
		return
	end
	notified[key] = true
	if #queue == 0 then
		vim.schedule(flush)
	end
	table.insert(queue, { spec = spec, root = root })
end

--- Build the root_dir/cmd part of a vim.lsp.config for a project-local server
---@param name string LSP config name
---@param spec ProjectServer
function M.server(name, spec)
	M.servers[name] = spec
	return {
		root_dir = function(bufnr, on_dir)
			local path = vim.api.nvim_buf_get_name(bufnr)
			if path == "" then
				return
			end
			local root, missing = resolve(spec, path)
			if root then
				on_dir(root)
			elseif missing then
				notify_missing(spec, missing)
			end
		end,
		cmd = function(dispatchers, config)
			local cmd = spec.go_tool and { "go", "tool", vim.fs.basename(spec.go_tool) }
				or vim.list_extend({ config.root_dir .. "/" .. spec.bin }, spec.args or {})
			return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
		end,
	}
end

--- On startup, check the project in cwd and list every server it expects but lacks
---@param names string[] Enabled LSP config names
function M.check_cwd(names)
	-- lsp/<name>.lua files load lazily; touch them so they register here
	for _, name in ipairs(names) do
		local _ = vim.lsp.config[name]
	end
	for _, spec in pairs(M.servers) do
		local _, missing = resolve(spec, vim.fn.getcwd())
		if missing then
			notify_missing(spec, missing)
		end
	end
end

return M
