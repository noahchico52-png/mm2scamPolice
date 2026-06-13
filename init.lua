-- MM2 Scam Police - Main Loader
if not game:IsLoaded() then game.Loaded:Wait() end

local env = getgenv()

-- Create folders for settings
if not isfolder("MM2ScamPolice") then makefolder("MM2ScamPolice") end

-- IMPORTANT: This makes import() work!
function env.import(id)
    return game:GetObjects(id)[1]
end

-- Load your UI (directly from root, not src folder)
loadstring(game:HttpGet("https://raw.githubusercontent.com/noahchico52-png/mm2scamPolice/refs/heads/main/ui.lua"))()

-- Auto-reload on teleport
if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/noahchico52-png/mm2scamPolice/refs/heads/main/init.lua"))()')
end
