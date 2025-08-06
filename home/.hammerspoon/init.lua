--------------------------------------------------------------------------------
-- Gmail/Google Drive opener

local Gdrive = hs.hotkey.modal.new({ 'ctrl', 'shift', 'alt', 'cmd' }, 'd')

function Gdrive:entered()
    -- Optional: Show some UI feedback that you're in the modal
    -- hs.alert.show('Google Drive Select Mode')
end

Gdrive:bind('', 'escape', function()
    Gdrive:exit()
end)

Gdrive:bind('', '1', function()
    hs.application.launchOrFocus("Chromium")
    hs.execute('open "https://drive.google.com/drive/u/0/my-drive"')
    Gdrive:exit()
end)

Gdrive:bind('', '2', function()
    hs.application.launchOrFocus("Chromium")
    hs.execute('open "https://drive.google.com/drive/u/1/my-drive"')
    Gdrive:exit()
end)

Gdrive:bind('', '3', function()
    hs.application.launchOrFocus("Chromium")
    hs.execute('open "https://drive.google.com/drive/u/2/my-drive"')
    Gdrive:exit()
end)

local Gmail = hs.hotkey.modal.new({ 'ctrl', 'shift', 'alt', 'cmd' }, 's')

function Gmail:entered()
    -- Optional: Show some UI feedback that you're in the modal
    -- hs.alert.show('Gmail Select Mode')
end

Gmail:bind('', 'escape', function()
    Gmail:exit()
end)

Gmail:bind('', '1', function()
    hs.application.launchOrFocus("Chromium")
    hs.execute('open "https://mail.google.com/mail/u/0/#inbox"')
    Gmail:exit()
end)

Gmail:bind('', '2', function()
    hs.application.launchOrFocus("Chromium")
    hs.execute('open "https://mail.google.com/mail/u/2/#inbox"')
    Gmail:exit()
end)

--------------------------------------------------------------------------------
-- CMD+[]

hs.hotkey.bind({ "cmd" }, "[", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Chromium" then
        hs.eventtap.keyStroke({ "cmd", "alt" }, "left")
    end
end)

hs.hotkey.bind({ "cmd" }, "]", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Chromium" then
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
