-- Nive Blade Ball HORIZONTAL MENU (No dark screen on start, Alt toggles black hole)
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/ninvislnive/bladeball-nive/main/src.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local Settings = {
    -- Farm
    EnableFarm = false,
    AutoQuest = false,
    -- Combat
    AutoSpam = false,
    WildSpam = false,
    AutoParry = false,
    AutoBlock = false,
    ParryRadius = 30,
    SpamSpeed = 0.05,
    -- Kill
    AutoKill = false,
    KillRadius = 50,
    KillTarget = "Random",
    -- Fun
    AutoSpin = false,
    AutoEmote = false,
    EmoteInterval = 3,
    SuperJump = false,
    -- Troll
    InvisibleBall = false,
    FakeLag = false,
    ReverseControls = false,
    ScreenShake = false,
    ConfuseEnemies = false,
    -- Chill
    AutoDance = false,
    DiscoMode = false,
    AutoChat = false,
    FunFacts = false,
    JokeOfDay = false,
    -- Epic
    GodMode = false,
    UltraSpeed = false,
    AlwaysParry = false,
    FlyMode = false,
    -- Visual
    ESP = false,
    Speed = 50,
    -- Defense
    AntiBan = true,
    ActionDelay = 0.3,
    LastAction = 0,
    MenuOpen = true,
    HideKey = "RightAlt"
}

-- ==================== ЧЁРНАЯ ДЫРА (только при скрытии меню) ====================
local blackHoleGui = Instance.new("ScreenGui", CoreGui)
blackHoleGui.Name = "NiveBlackHole"

local blackHole = Instance.new("Frame", blackHoleGui)
blackHole.Size = UDim2.new(0,0,0,0)
blackHole.Position = UDim2.new(0.5,0,0.5,0)
blackHole.AnchorPoint = Vector2.new(0.5,0.5)
blackHole.BackgroundColor3 = Color3.new(0,0,0)
blackHole.BackgroundTransparency = 0
blackHole.BorderSizePixel = 0
blackHole.Visible = false

-- кольца и частицы для чёрной дыры (только для красоты при скрытии)
for i = 1, 3 do
    local ring = Instance.new("Frame", blackHole)
    ring.Size = UDim2.new(0, 150 + i*30, 0, 150 + i*30)
    ring.Position = UDim2.new(0.5, -75 - i*15, 0.5, -75 - i*15)
    ring.BackgroundColor3 = Color3.new(1,1,1)
    ring.BackgroundTransparency = 0.9
    ring.BorderSizePixel = 1
    ring.BorderColor3 = Color3.fromRGB(160, 80, 255)
    ring.Rotation = i * 45
    spawn(function()
        while ring and ring.Parent do
            ring.Rotation = ring.Rotation + 0.5
            task.wait()
        end
    end)
end

-- ==================== ГЛАВНОЕ МЕНЮ ====================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NiveBladeBall"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 700, 0, 380)   -- широкое горизонтальное меню
main.Position = UDim2.new(0.5, -350, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(12, 8, 25)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(160, 80, 255)
main.Visible = Settings.MenuOpen
main.Active = true

-- анимация появления (без затемнения)
main.BackgroundTransparency = 1
main.Position = UDim2.new(0.5, -350, 0.5, -140)
TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
    BackgroundTransparency = 0,
    Position = UDim2.new(0.5, -350, 0.5, -190)
}):Play()

-- пульсирующая рамка
spawn(function()
    while main and main.Parent do
        local r = math.sin(tick() * 3) * 0.2 + 0.8
        main.BorderColor3 = Color3.fromRGB(160 * r, 80 * r, 255)
        task.wait()
    end
end)

-- перетаскивание
local titleBar = Instance.new("TextButton", main)
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.Text = "🌌 NIVE BLADE BALL"
titleBar.BackgroundColor3 = Color3.fromRGB(18, 12, 35)
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SciFi
titleBar.TextSize = 14
titleBar.AutoButtonColor = false

local dragging, dragStart, startPos = false, nil, nil
titleBar.MouseButton1Down:Connect(function()
    dragging = true
    dragStart = UserInputService:GetMouseLocation()
    startPos = main.Position
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- вкладки слева
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(0, 140, 1, -24)
tabFrame.Position = UDim2.new(0, 0, 0, 24)
tabFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
tabFrame.BorderSizePixel = 1
tabFrame.BorderColor3 = Color3.fromRGB(100, 50, 150)

local uiListLayout = Instance.new("UIListLayout", tabFrame)
uiListLayout.Padding = UDim.new(0, 4)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- контентная область справа
local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1, -144, 1, -24)
contentArea.Position = UDim2.new(0, 144, 0, 24)
contentArea.BackgroundTransparency = 1

-- табы
local tabNames = {"Farm", "Combat", "Kill", "Fun", "Troll", "Chill", "Epic", "Visual", "Defense"}
local tabBtns = {}
local contents = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1, -8, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(100, 50, 150) or Color3.fromRGB(30, 25, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(120,100,180)
    btn.AutoButtonColor = false
    table.insert(tabBtns, btn)

    local content = Instance.new("ScrollingFrame", contentArea)
    content.Size = UDim2.new(1, 0, 1, 0)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 3
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = i == 1
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 4)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(30, 25, 50) end
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        for _, c in ipairs(contents) do c.Visible = false end
        content.Visible = true
    end)
end

-- вспомогательные функции для UI
local function addToggle(content, text, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 28)
    btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
    btn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80,60,120)
    btn.AutoButtonColor = false
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
        if key == "EnableFarm" then
            Settings.AutoSpam = Settings.EnableFarm
            Settings.AutoParry = Settings.EnableFarm
        end
    end)
    content.CanvasSize += UDim2.new(0,0,0,32)
end

local function addSlider(content, text, key, min, max)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, -4, 0, 48)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 16)
    label.Text = text .. ": " .. Settings[key]
    label.TextColor3 = Color3.new(0.8,0.8,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1, 0, 0, 22)
    input.Position = UDim2.new(0, 0, 0, 18)
    input.Text = tostring(Settings[key])
    input.BackgroundColor3 = Color3.fromRGB(35,25,55)
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.SourceSans
    input.BorderSizePixel = 1
    input.BorderColor3 = Color3.fromRGB(80,60,120)
    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num then
            num = math.clamp(num, min, max)
            Settings[key] = num
            input.Text = tostring(num)
            label.Text = text .. ": " .. num
        end
    end)
    content.CanvasSize += UDim2.new(0,0,0,52)
end

local function addButton(content, text, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 28)
    btn.Text = "  " .. text
    btn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80,60,120)
    btn.AutoButtonColor = false
    btn.MouseButton1Click:Connect(callback)
    content.CanvasSize += UDim2.new(0,0,0,32)
end

-- ==================== ЗАПОЛНЕНИЕ ВКЛАДОК ====================
-- Farm
addToggle(contents[1], "Enable Farm", "EnableFarm")
addToggle(contents[1], "Auto Quest", "AutoQuest")

-- Combat
addToggle(contents[2], "Auto Spam", "AutoSpam")
addToggle(contents[2], "WILD SPAM", "WildSpam")
addSlider(contents[2], "Spam Speed", "SpamSpeed", 0.001, 0.5)
addToggle(contents[2], "Auto Parry", "AutoParry")
addSlider(contents[2], "Parry Radius", "ParryRadius", 10, 100)
addToggle(contents[2], "Auto Block", "AutoBlock")

-- Kill
addToggle(contents[3], "Auto Kill", "AutoKill")
addSlider(contents[3], "Kill Radius", "KillRadius", 20, 200)
-- drop down KillTarget (Random/Nearest) можно сделать парой кнопок
addButton(contents[3], "Target: " .. Settings.KillTarget, function()
    Settings.KillTarget = Settings.KillTarget == "Random" and "Nearest" or "Random"
    -- обновим текст кнопки
    for _, c in ipairs(contents[3]:GetChildren()) do
        if c:IsA("TextButton") and c.Text:find("Target") then
            c.Text = "  Target: " .. Settings.KillTarget
        end
    end
end)

-- Fun
addToggle(contents[4], "Auto Spin", "AutoSpin")
addToggle(contents[4], "Auto Emote", "AutoEmote")
addSlider(contents[4], "Emote Interval", "EmoteInterval", 1, 10)
addToggle(contents[4], "Super Jump", "SuperJump")

-- Troll
addToggle(contents[5], "Invisible Ball", "InvisibleBall")
addToggle(contents[5], "Fake Lag", "FakeLag")
addToggle(contents[5], "Reverse Controls", "ReverseControls")
addToggle(contents[5], "Screen Shake", "ScreenShake")
addToggle(contents[5], "Confuse Enemies", "ConfuseEnemies")

-- Chill
addToggle(contents[6], "Auto Dance", "AutoDance")
addToggle(contents[6], "Disco Mode", "DiscoMode")
addToggle(contents[6], "Auto Chat", "AutoChat")
addToggle(contents[6], "Fun Facts", "FunFacts")
addToggle(contents[6], "Joke of Day", "JokeOfDay")

-- Epic
addToggle(contents[7], "God Mode", "GodMode")
addToggle(contents[7], "Ultra Speed", "UltraSpeed")
addToggle(contents[7], "Always Parry", "AlwaysParry")
addToggle(contents[7], "Fly Mode", "FlyMode")

-- Visual
addToggle(contents[8], "ESP", "ESP")
addSlider(contents[8], "Walk Speed", "Speed", 16, 200)

-- Defense
addToggle(contents[9], "Anti-Ban System", "AntiBan")
addSlider(contents[9], "Action Delay", "ActionDelay", 0.1, 2.0)

-- ==================== СКРЫТИЕ МЕНЮ (ЧЁРНАЯ ДЫРА) ====================
local function toggleMenu()
    Settings.MenuOpen = not Settings.MenuOpen
    if Settings.MenuOpen then
        main.Visible = true
        main.BackgroundTransparency = 1
        main.Position = UDim2.new(0.5, -350, 0.5, -140)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            BackgroundTransparency = 0,
            Position = UDim2.new(0.5, -350, 0.5, -190)
        }):Play()
        blackHole.Visible = false
    else
        blackHole.Size = UDim2.new(0,0,0,0)
        blackHole.BackgroundTransparency = 0
        blackHole.Visible = true
        local expand = TweenService:Create(blackHole, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0,300,0,300)
        })
        expand:Play()
        expand.Completed:Connect(function()
            local shrink = TweenService:Create(blackHole, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0,0,0,0)
            })
            shrink:Play()
            shrink.Completed:Connect(function() blackHole.Visible = false end)
        end)
        TweenService:Create(main, TweenInfo.new(0.2), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -350, 0.5, -140)
        }):Play()
        task.wait(0.2)
        main.Visible = false
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local keyName = input.KeyCode.Name
    if keyName == Settings.HideKey then
        toggleMenu()
    end
end)

-- ==================== УТИЛИТЫ ====================
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end
local function canAct()
    if not Settings.AntiBan then return true end
    if tick() - Settings.LastAction >= Settings.ActionDelay then
        Settings.LastAction = tick() + (math.random() * 0.2 - 0.1)
        return true
    end
    return false
end

-- ==================== ПОИСК МЯЧА И ИГРОКОВ ====================
local Ball = nil
local lastBallSearch = 0
local function getBall()
    if tick() - lastBallSearch > 2 then
        lastBallSearch = tick()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name:lower():find("ball")) then
                Ball = obj
                break
            end
        end
    end
    return Ball
end

local function getNearestPlayer()
    local root = getRoot() if not root then return nil end
    local nearest, ndist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (root.Position - hrp.Position).Magnitude
                if d < ndist then ndist = d; nearest = hrp end
            end
        end
    end
    return nearest
end

local function getRandomPlayer()
    local candidates = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then table.insert(candidates, hrp) end
        end
    end
    if #candidates == 0 then return nil end
    return candidates[math.random(#candidates)]
end

-- ==================== ФУНКЦИИ (ВСЕ РЕАЛЬНЫЕ) ====================
-- Auto Kill
local lastKill = 0
local function autoKill()
    if not Settings.AutoKill then return end
    local ball = getBall() if not ball then return end
    local root = getRoot() if not root then return end
    local dist = (root.Position - ball.Position).Magnitude
    if dist > Settings.KillRadius then return end
    if tick() - lastKill < 1.5 then return end
    local target = Settings.KillTarget == "Nearest" and getNearestPlayer() or getRandomPlayer()
    if not target then return end
    lastKill = tick()
    local dir = (target.Position - ball.Position).Unit
    root.CFrame = CFrame.new(target.Position - dir * 5, target.Position)
    VIM:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
    task.wait(0.01)
    VIM:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
end

-- Wild Spam
local function wildSpam()
    if not Settings.WildSpam then return end
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Auto Spam
local lastSpam = 0
local function autoSpam()
    if not Settings.AutoSpam or Settings.WildSpam then return end
    if tick() - lastSpam < Settings.SpamSpeed then return end
    lastSpam = tick()
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- Auto Parry / Always Parry
local lastParry = 0
local function autoParry()
    if not Settings.AutoParry and not Settings.AlwaysParry then return end
    local root = getRoot() if not root then return end
    local ball = getBall() if not ball then return end
    local radius = Settings.AlwaysParry and 1000 or Settings.ParryRadius
    local dist = (root.Position - ball.Position).Magnitude
    if dist < radius and tick() - lastParry > 0.5 then
        lastParry = tick()
        VIM:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        task.wait(0.01)
        VIM:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
    end
end

-- Auto Block
local function autoBlock()
    if not Settings.AutoBlock then return end
    VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

-- ESP
local lastESP = 0
local function esp()
    if not Settings.ESP then return end
    if tick() - lastESP < 3 then return end
    lastESP = tick()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v.Name == "ESP_Tag" and v:IsA("BillboardGui") then v:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local h = plr.Character.Head
            local b = Instance.new("BillboardGui", h)
            b.Name = "ESP_Tag"; b.Adornee = h; b.Size = UDim2.new(0,100,0,20); b.AlwaysOnTop = true
            local t = Instance.new("TextLabel", b)
            t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = plr.Name
            t.TextColor3 = Color3.new(1,0.5,0); t.Font = Enum.Font.SourceSansBold; t.TextSize = 12
        end
    end
    local ball = getBall()
    if ball then
        local b = Instance.new("BillboardGui", ball)
        b.Name = "ESP_Tag"; b.Adornee = ball; b.Size = UDim2.new(0,100,0,20); b.AlwaysOnTop = true
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = "BALL"
        t.TextColor3 = Color3.new(0,1,1); t.Font = Enum.Font.SourceSansBold; t.TextSize = 12
    end
end

-- Auto Quest (заглушка, работает через кнопки в GUI)
local lastQuest = 0
local function autoQuest()
    if not Settings.AutoQuest then return end
    if tick() - lastQuest < 5 then return end
    lastQuest = tick()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local questsBtn = playerGui:FindFirstChild("MainGui") and playerGui.MainGui:FindFirstChild("QuestsButton")
    if not questsBtn then return end
    fireclickdetector(questsBtn)
    task.wait(0.3)
    local questFrame = playerGui:FindFirstChild("QuestsFrame") or playerGui:FindFirstChild("QuestGui")
    if questFrame then
        for _, child in ipairs(questFrame:GetDescendants()) do
            if child:IsA("TextButton") and (child.Text:lower():find("claim") or child.Text:lower():find("complete")) then
                fireclickdetector(child)
            end
        end
    end
    fireclickdetector(questsBtn)
end

-- ==================== ВЕСЁЛЫЕ ФУНКЦИИ ====================
local function autoSpin()
    if not Settings.AutoSpin then return end
    local root = getRoot() if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(10), 0) end
end

local la
