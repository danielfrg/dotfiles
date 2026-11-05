-- Run by the palette's detached helper on the Mac; API discovery may be remote.
local home = os.getenv("HOME")
local cache_dir = (os.getenv("XDG_CACHE_HOME") or home .. "/.cache") .. "/rex"
local ok, err = pcall(function()
  require("palette").refresh(home, cache_dir, rex.args)
end)
if not ok then
  local log = io.open(cache_dir .. "/palette-refresh.log", "a")
  if log then
    log:write(os.date("%Y-%m-%d %H:%M:%S"), " ", tostring(err), "\n")
    log:close()
  end
  error(err, 0)
end
