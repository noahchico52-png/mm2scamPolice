-- MM2 Scam Police - Main Loader
if not game:IsLoaded() then game.Loaded:Wait() end

local env = getgenv()

-- Create folders for settings
if not isfolder("MM2ScamPolice") then makefolder("MM2ScamPolice") end

-- IMPORTANT: This makes import() work!
function env.import(id)
    return game:GetObjects(id)[1]
end

-- Where to find your UI file
function env.getgitpath(where)
    local mainBuild = "https://raw.githubusercontent.com/noahchico52-png/mm2scamPolice/refs/heads/main/"
    if where == "src" then
        return mainBuild .. "src/"
    end
    return mainBuild
end

-- Load your UI
loadstring(game:HttpGet(getgitpath("src").."ui.lua"))()

-- Auto-reload on teleport
if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/noahchico52-png/mm2scamPolice/refs/heads/main/src/init.lua"))()')
end
