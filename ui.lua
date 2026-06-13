-- MM2 Scam Police UI - Complete Working Version
-- No imports needed! Works in any executor

local hui = gethui or get_hidden_gui
local getexec = identifyexecutor or function() return "Unknown" end
local coregui = game:GetService("CoreGui")
local userinputservice = game:GetService("UserInputService")
local tweenservice = game:GetService("TweenService")
local runservice = game:GetService("RunService")
local players = game:GetService("Players")
local lp = players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2ScamPolice"
screenGui.Parent = hui and hui() or coregui
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999999

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Frame"
MainFrame.Parent = screenGui
MainFrame.Size = UDim2.new(0, 500, 0, 420)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(80, 76, 165)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(53, 50, 106)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 Scam Police"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local HideButton = Instance.new("TextButton")
HideButton.Name = "hidebtn"
HideButton.Parent = TopBar
HideButton.Size = UDim2.new(0, 70, 1, 0)
HideButton.Position = UDim2.new(1, -80, 0, 0)
HideButton.BackgroundTransparency = 1
HideButton.Text = "Hide UI"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.Font = Enum.Font.Gotham
HideButton.TextSize = 14

-- Tab List
local TabList = Instance.new("Frame")
TabList.Name = "tablist"
TabList.Parent = MainFrame
TabList.Size = UDim2.new(0, 120, 1, -40)
TabList.Position = UDim2.new(0, 0, 0, 40)
TabList.BackgroundColor3 = Color3.fromRGB(53, 50, 106)
TabList.BorderSizePixel = 0

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = TabList
tabLayout.Padding = UDim.new(0, 5)

-- Section Containers
local SectionContainers = Instance.new("Frame")
SectionContainers.Name = "sectionContainers"
SectionContainers.Parent = MainFrame
SectionContainers.Size = UDim2.new(1, -135, 1, -55)
SectionContainers.Position = UDim2.new(0, 125, 0, 45)
SectionContainers.BackgroundColor3 = Color3.fromRGB(30, 28, 60)
SectionContainers.BorderSizePixel = 0

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 6)
containerCorner.Parent = SectionContainers

-- Toggle Button
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "togglebtn"
ToggleButton.Parent = screenGui
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 10, 1, -80)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 76, 165)
ToggleButton.BackgroundTransparency = 0
ToggleButton.Visible = false
ToggleButton.Image = "rbxassetid://75346413848603"
ToggleButton.ScaleType = Enum.ScaleType.Fit

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = ToggleButton

-- Create sections
local sections = {}

local function createSection(name)
    local section = Instance.new("ScrollingFrame")
    section.Name = name
    section.Parent = SectionContainers
    section.Size = UDim2.new(1, 0, 1, 0)
    section.BackgroundTransparency = 1
    section.ScrollBarThickness = 0
    section.CanvasSize = UDim2.new(0, 0, 0, 0)
    section.AutomaticCanvasSize = Enum.AutomaticSize.Y
    section.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = section
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 20)
    padding.Parent = section
    
    return section
end

local homeSection = createSection("homeframe")
local gameSection = createSection("gameFrame")
local gamesListSection = createSection("gamelistFrame")
local settingsSection = createSection("settingsFrame")
local creditsSection = createSection("creditsFrame")

-- Create tab buttons
local function createTabButton(name, order)
    local button = Instance.new("ImageButton")
    button.Name = name .. "Tab"
    button.Parent = TabList
    button.Size = UDim2.new(1, -20, 0, 45)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(53, 50, 106)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.LayoutOrder = order
    button.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = button
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    
    return button
end

local tabs = {
    Home = { btn = createTabButton("Home", 1), section = homeSection },
    Game = { btn = createTabButton("Game", 2), section = gameSection },
    GamesList = { btn = createTabButton("Games List", 3), section = gamesListSection },
    Settings = { btn = createTabButton("Settings", 4), section = settingsSection },
    Credits = { btn = createTabButton("Credits", 5), section = creditsSection }
}

-- Tab switching
local currentSection = homeSection
local currentTab = tabs.Home

for name, tab in pairs(tabs) do
    tab.btn.MouseButton1Click:Connect(function()
        if currentSection == tab.section then return end
        currentSection.Visible = false
        currentTab.btn.BackgroundTransparency = 1
        tab.section.Visible = true
        tab.btn.BackgroundTransparency = 0.9
        currentSection = tab.section
        currentTab = tab
    end)
end

homeSection.Visible = true
tabs.Home.btn.BackgroundTransparency = 0.9

-- Hide/Show
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)

-- Dragging
local dragging = false
local dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

userinputservice.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- UI Element Creation Functions
local function CreateButton(text, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 40)
    button.BackgroundColor3 = color or Color3.fromRGB(156, 39, 176)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        tweenservice:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
    end)
    button.MouseLeave:Connect(function()
        tweenservice:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end)
    
    return button
end

local function CreateLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 250, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    return label
end

local function CreateToggle(text, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 40)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0, 180, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(150, 150, 150)
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    
    local toggled = defaultValue
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(150, 150, 150)
        toggleBtn.Text = toggled and "ON" or "OFF"
        callback(toggled)
    end)
    
    return frame
end

-- ============================================
-- SETUP YOUR UI SECTIONS (EDIT THIS PART!)
-- ============================================

-- HOME SECTION
CreateLabel("Welcome to MM2 Scam Police!").Parent = homeSection
CreateLabel("Executor: " .. getexec()).Parent = homeSection
CreateLabel("Version: 1.0").Parent = homeSection
CreateLabel(" ").Parent = homeSection
CreateLabel("Join discord.gg/vaehz for support!").Parent = homeSection

-- GAME SECTION (ADD YOUR BUTTONS HERE)
CreateLabel("Game Features").Parent = gameSection

CreateButton("Test Button", Color3.fromRGB(156, 39, 176), function()
    print("Test button clicked!")
    warn("Hello from MM2 Scam Police!")
end).Parent = gameSection

CreateButton("Get Player Info", Color3.fromRGB(33, 150, 243), function()
    print("Player Name: " .. lp.Name)
    print("Player ID: " .. lp.UserId)
end).Parent = gameSection

CreateButton("Print Game ID", Color3.fromRGB(76, 175, 80), function()
    print("Game Place ID: " .. game.PlaceId)
end).Parent = gameSection

-- GAMES LIST SECTION
CreateLabel("Supported Games").Parent = gamesListSection

-- SETTINGS SECTION
CreateToggle("Disable 3D Rendering", false, function(v)
    runservice:Set3dRenderingEnabled(not v)
end).Parent = settingsSection

CreateToggle("Auto Rejoin (when kicked)", false, function(v)
    getgenv().autorjjjj = v
end).Parent = settingsSection

-- CREDITS SECTION
CreateLabel("MM2 Scam Police").Parent = creditsSection
CreateLabel("Created by: noahchico52").Parent = creditsSection
CreateLabel("Discord: discord.gg/vaehz").Parent = creditsSection

print("MM2 Scam Police UI Loaded Successfully!")
