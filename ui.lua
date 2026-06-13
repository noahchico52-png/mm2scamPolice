local hui = gethui or get_hidden_gui
local getexec = identifyexecutor
local coregui = game:GetService("CoreGui")
local userinputservice = game:GetService("UserInputService")
local httpservice = game:GetService("HttpService")
local exservice = game:GetService("ExperienceService")
local tweenservice = game:GetService("TweenService")

local ui = import("rbxassetid://75281832304062")

ui.Parent = hui and hui() or coregui

local ToggleButton = ui.togglebtn
local MainFrame = ui.Frame

local Topbar = MainFrame.TopBar
local SectionContainers = MainFrame.sectionContainers
local TabList = MainFrame.tablist

local HideButton = Topbar.hidebtn

local Sections = {
    Home = {
        TabBtn = TabList.HomeTab,
        Container = SectionContainers.homeframe
    },

    Game = {
        TabBtn = TabList.GameTab,
        Container = SectionContainers.gameFrame
    },

    GamesList = {
        TabBtn = TabList.GameslistTab,
        Container = SectionContainers.gamelistFrame
    },

    Settings = {
        TabBtn = TabList.SettingsTab,
        Container = SectionContainers.settingsFrame
    },

    Credits = {
        TabBtn = TabList.CreditsTab,
        Container = SectionContainers.creditsFrame
    }
}

local CurSection

for _, sect in pairs(Sections) do
    sect.TabBtn.MouseEnter:Connect(function()
        for _, stroke in pairs(sect.TabBtn:GetChildren()) do
            if stroke.Name == "InnerShadow" then
                stroke.Transparency = 0.95
            end
        end
    end)

    sect.TabBtn.MouseLeave:Connect(function()
        for _, stroke in pairs(sect.TabBtn:GetChildren()) do
            if stroke.Name == "InnerShadow" then
                stroke.Transparency = 1
            end
        end
    end)

    sect.TabBtn.MouseButton1Click:Connect(function()
        if CurSection == sect then return end

        if CurSection then
            CurSection.TabBtn.BackgroundTransparency = 1
            CurSection.Container:TweenPosition(UDim2.new(0.5, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
        end

        sect.TabBtn.BackgroundTransparency = 0
        sect.Container:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
        sect.Container.Visible = true

        CurSection = sect
    end)
end

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)

local dragging = false
local dragInput, mousePos, framePos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userinputservice.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Update Home section text
Sections.Home.Container.bugsLabel.Text = Sections.Home.Container.bugsLabel.Text:gsub("redacted", "discord.gg/vaehz")
Sections.Home.Container.discan.Text = Sections.Home.Container.discan.Text:gsub("redacted", "discord.gg/vaehz")
Sections.Home.Container.ythead.Text = Sections.Home.Container.ythead.Text:gsub("redacted", "YouTube")
Sections.Home.Container.execLabel.Text = "Executor: " .. getexec()
Sections.Home.Container.versionLabel.Text = "Version: 0.21 BETA"

-- Clear and setup Game section
for _, child in pairs(Sections.Game.Container:GetChildren()) do
    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("Frame") then
        child:Destroy()
    end
end

-- Load elements system
local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()

-- Add unsupported message and buttons to Game section
elements:Label("This game is not supported!", Sections.Game.Container)
elements:Button("Suggest Game", Sections.Game.Container, function()
    print("Suggest Game clicked")
    setclipboard("discord.gg/vaehz")
    warn("Join discord.gg/vaehz to suggest games!")
end)
elements:Button("Check out the Games List", Sections.Game.Container, function()
    print("Check out Games List clicked")
    if CurSection then
        CurSection.TabBtn.BackgroundTransparency = 1
        CurSection.Container:TweenPosition(UDim2.new(0.5, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
    end
    Sections.GamesList.TabBtn.BackgroundTransparency = 0
    Sections.GamesList.Container:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
    Sections.GamesList.Container.Visible = true
    CurSection = Sections.GamesList
end)

-- ============ NEW BUTTON THAT PRINTS SOMETHING ============
elements:Button("Test Button", Sections.Game.Container, function()
    print("Hello from the Test Button!")
    print("Current game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).name)
    print("Executor: " .. getexec())
    warn("Test button was clicked! 🎉")
end)

-- You can also add more buttons that print different things:
elements:Button("Print Player Name", Sections.Game.Container, function()
    print("Player name: " .. game:GetService("Players").LocalPlayer.Name)
    print("Player UserId: " .. game:GetService("Players").LocalPlayer.UserId)
end)

elements:Button("Print Game Info", Sections.Game.Container, function()
    print("Game PlaceId: " .. game.PlaceId)
    print("Game JobId: " .. game.JobId)
    print("Game Time: " .. game:GetService("Workspace").DistributedGameTime)
end)

-- Clear and setup Settings section
for _, child in pairs(Sections.Settings.Container:GetChildren()) do
    if child:IsA("Frame") or (child:IsA("TextLabel") and child.Name ~= "settingsLabel") then
        child:Destroy()
    end
end

-- Add settings toggles
local dec1 = {}
pcall(function()
    dec1 = httpservice:JSONDecode(readfile("BrainrotPolice/Config.json"))
end)

if not dec1.settings then dec1.settings = {} end

elements:Toggle("Disable 3D Rendering", Sections.Settings.Container, dec1.settings.disable_3d_rendering or false, function(v)
    local dec = {}
    pcall(function()
        dec = httpservice:JSONDecode(readfile("BrainrotPolice/Config.json"))
    end)
    if not dec.settings then dec.settings = {} end
    dec.settings.disable_3d_rendering = v
    pcall(function()
        writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(dec))
    end)
    game:GetService("RunService"):Set3dRenderingEnabled(not v)
end)

elements:Toggle("Auto Rejoin (when kicked)", Sections.Settings.Container, dec1.settings.auto_rejoin_on_kick or false, function(v)
    local dec = {}
    pcall(function()
        dec = httpservice:JSONDecode(readfile("BrainrotPolice/Config.json"))
    end)
    if not dec.settings then dec.settings = {} end
    dec.settings.auto_rejoin_on_kick = v
    pcall(function()
        writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(dec))
    end)
    getgenv().autorjjjj = v
end)

-- Setup Games List section
local gameList = {}
pcall(function()
    gameList = httpservice:JSONDecode(game:HttpGet(getgitpath("src").. "gameslist.json"))
end)

for _, g in ipairs(gameList) do
    elements:Button(g.status .. " " .. g["game"], Sections.GamesList.Container, function()
        pcall(function()
            exservice:LaunchExperience({placeId = g.id})
        end)
    end)
end

-- Setup Credits section
local creditsList = {}
pcall(function()
    creditsList = httpservice:JSONDecode(game:HttpGet(getgitpath("src").. "credits.json"))
end)

for sect, c in pairs(creditsList) do
    elements:CredHead(Sections.Credits.Container, sect)
    for _, person in ipairs(c) do
        elements:CredPerson(Sections.Credits.Container, person)
    end
end

-- If no credits loaded, add default
if not next(creditsList) then
    elements:Label("Brainrot Police", Sections.Credits.Container)
    elements:Label("Developed by Vaehz", Sections.Credits.Container)
    elements:Label("Discord: discord.gg/vaehz", Sections.Credits.Container)
    elements:Label("YouTube: @Vaehz", Sections.Credits.Container)
end

-- Make sure Game section is visible first time
task.wait(0.5)
if CurSection == nil then
    Sections.Home.TabBtn.BackgroundTransparency = 0
    Sections.Home.Container.Visible = true
    CurSection = Sections.Home
end

print("Brainrot Police UI Loaded Successfully!")
