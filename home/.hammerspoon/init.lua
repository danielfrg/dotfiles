--------------------------------------------------------------------------------
-- Google Drive opener
local googleModal = hs.hotkey.modal.new({ 'ctrl', 'shift', 'alt', 'cmd' }, 'd')

function googleModal:entered()
    -- Optional: Show some UI feedback that you're in the modal
    -- hs.alert.show('Google Drive Select Mode')
end

googleModal:bind('', 'escape', function()
    googleModal:exit()
end)

googleModal:bind('', '1', function()
    hs.application.launchOrFocus("Chromium")
    hs.execute('open "https://drive.google.com/drive/u/0/my-drive"')
    googleModal:exit()
end)

googleModal:bind('', '2', function()
    hs.application.launchOrFocus("Chromium")
    hs.execute('open "https://drive.google.com/drive/u/2/my-drive"')
    googleModal:exit()
end)

--------------------------------------------------------------------------------
-- CMD+[]
hs.hotkey.bind({ "cmd" }, "[", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Google Chrome" then
        hs.eventtap.keyStroke({ "cmd", "alt" }, "left")
    end
end)

hs.hotkey.bind({ "cmd" }, "]", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Google Chrome" then
        hs.eventtap.keyStroke({ "cmd", "alt" }, "right")
    end
end)

--------------------------------------------------------------------------------
-- Teams stupid shit

-- local downloadsPath = os.getenv("HOME") .. "/Downloads"

-- function checkAndRemoveTeams()
--     local teamsFolder = downloadsPath .. "/MSTeams"

--     -- Check if folder exists using hs.fs.attributes
--     local attributes = hs.fs.attributes(teamsFolder)
--     if attributes and attributes.mode == "directory" then
--         -- Folder exists, try to remove it
--         -- Use hs.execute instead of os.execute for better error handling
--         local output, status, type, rc = hs.execute("rm -rf '" .. teamsFolder .. "'")

--         if rc == 0 then
--             hs.notify.new({
--                 title = "Hammerspoon",
--                 informativeText = "MSTeams folder removed from Downloads"
--             }):send()
--         else
--             hs.notify.new({
--                 title = "Hammerspoon",
--                 informativeText = "Error removing MSTeams folder: " .. (output or "unknown error")
--             }):send()
--         end
--     end
-- end

-- local watcher = hs.pathwatcher.new(downloadsPath, function(files)
--     checkAndRemoveTeams()
-- end):start()

-- -- Initial check when the script loads
-- checkAndRemoveTeams()

--------------------------------------------------------------------------------
-- Auto reload config
function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
