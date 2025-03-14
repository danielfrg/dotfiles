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
    hs.execute('open "https://drive.google.com/drive/u/1/my-drive"')
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
-- MSTeams Cleanup

local teamsFolder = os.getenv("HOME") .. "/Downloads/MSTeams"

function deleteTeamsFolder()
    local exists = hs.fs.attributes(teamsFolder)

    if exists then
        local success, output, errorOutput = hs.execute("rm -rf '" .. teamsFolder .. "'")

        if success then
            print("Successfully deleted " .. teamsFolder)
        else
            print("Failed to delete " .. teamsFolder .. ": " .. (errorOutput or "Unknown error"))
        end
    else
        print("MS Teams folder not found, nothing to delete")
    end
end

-- Timer that runs every hour
local cleanupTimer = hs.timer.new(3600, deleteTeamsFolder)

-- Start timer
cleanupTimer:start()

-- Run once on config load
deleteTeamsFolder()

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
