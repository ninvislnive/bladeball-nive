-- Nive Blade Ball FULL REAL FUNCTIONS (No Fake)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local TextChatService = game:GetService("TextChatService")

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
    EmoteInterval = 3,   -- секунд между эмоциями
    NoCooldownEmotes = false,
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
    MenuOpen = true
}

-- ==================== АНИМИРОВАННАЯ ЧЁРНАЯ ДЫРА ====================
local blackHoleGui = Instance.new("ScreenGui", CoreGui)
blackHoleGui.Name = "NiveBlackHole"

local blackHole = Instance.new("Frame", blackHoleGui)
blackHole.Size = UDim2.new(0, 400, 0, 400)
blackHole.Position = UDim2.new(0.5, -200, 0.5, -200)
blackHole.BackgroundColor3 = Color3.new(0, 0, 0)
blackHole.BackgroundTransparency = 0.8
blackHole.BorderSizePixel = 0
blackHole.Visible = false

for i = 1, 5 do
    local ring = Instance.new("Frame", blackHole)
    ring.Size = UDim2.new(0, 200 + i * 40, 0, 200 + i * 40)
    ring.Position = UDim2.new(0.5, -100 - i * 20, 0.5, -100 - i * 20)
    ring.BackgroundColor3 = Color3.new(1, 1, 1)
    ring.BackgroundTransparency = 0.9 - i * 0.15
    ring.BorderSizePixel = 1
    ring.BorderColor3 = Color3.fromRGB(160, 80, 255 / i)
    ring.Rotation = i * 30
    spawn(function()
        while ring and ring.Parent do
            ring.Rotation = ring.Rotation + 0.2 * i
            task.wait()
        end
    end)
end

for i = 1, 20 do
    local particle = Instance.new("Frame", blackHole)
    particle.Size = UDim2.new(0, 4, 0, 4)
    particle.Position = UDim2.new(0.5, math.random(-150, 150), 0.5, math.random(-150, 150))
    particle.BackgroundColor3 = Color3.new(1, 1, 1)
    particle.BorderSizePixel = 0
    spawn(function()
        while particle and particle.Parent do
            TweenService:Create(particle, TweenInfo.new(2, Enum.EasingStyle.Linear), {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            task.wait(2)
            particle.Position = UDim2.new(0.5, math.random(-150, 150), 0.5, math.random(-150, 150))
            particle.Size = UDim2.new(0, 4, 0, 4)
            particle.BackgroundTransparency = 0
        end
    end)
end

-- ==================== ГЛАВНОЕ МЕНЮ ====================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NiveBladeBall"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 380, 0, 380)
main.Position = UDim2.new(0.5, -190, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(12, 8, 25)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(160, 80, 255)
main.Visible = Settings.MenuOpen
main.Active = true

main.BackgroundTransparency = 1
main.Position = UDim2.new(0.5, -190, 0.5, -140)
TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    BackgroundTransparency = 0,
    Position = UDim2.new(0.5, -190, 0.5, -190)
}):Play()

spawn(function()
    while main and main.Parent do
        local r = math.sin(tick() * 3) * 0.2 + 0.8
        main.BorderColor3 = Color3.fromRGB(160 * r, 80 * r, 255)
        task.wait()
    end
end)

local titleBar = Instance.new("TextButton", main)
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.Text = "🌌 NIVE BLADE BALL REAL"
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

local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, 0, 0, 24)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundTransparency = 1

local tabs = {"Farm", "Combat", "Kill", "Fun", "Troll", "Chill", "Epic", "Visual", "Defense"}
local contents = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1/#tabs, -2, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabs, 1, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(100, 50, 150) or Color3.fromRGB(40, 30, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 10
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(120,100,180)
    btn.AutoButtonColor = false

    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, 0, 1, -56)
    content.Position = UDim2.new(0, 0, 0, 56)
    content.CanvasSize = UDim2.new(0, 0, 0, 320)
    content.ScrollBarThickness = 3
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = i == 1
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 4)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabFrame:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(40,30,70) end end
        btn.BackgroundColor3 = Color3.fromRGB(100,50,150)
        for _, c in ipairs(contents) do c.Visible = false end
        content.Visible = true
    end)
end

local function addToggle(content, text, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -4, 0, 30)
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
    content.CanvasSize += UDim2.new(0,0,0,34)
end

local function addSlider(content, text, key, min, max)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, -4, 0, 52)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Text = text .. ": " .. Settings[key]
    label.TextColor3 = Color3.new(0.8,0.8,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1, 0, 0, 24)
    input.Position = UDim2.new(0, 0, 0, 20)
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
    content.CanvasSize += UDim2.new(0,0,0,56)
end

local function addDropdown(content, text, key, options)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, -4, 0, 80)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Text = text .. ": " .. Settings[key]
    label.TextColor3 = Color3.new(0.8,0.8,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12

    local btnFrame = Instance.new("Frame", frame)
    btnFrame.Size = UDim2.new(1, 0, 0, 28)
    btnFrame.Position = UDim2.new(0, 0, 0, 22)
    btnFrame.BackgroundTransparency = 1

    local btn1 = Instance.new("TextButton", btnFrame)
    btn1.Size = UDim2.new(0.5, -2, 1, 0)
    btn1.Text = options[1]
    btn1.BackgroundColor3 = Settings[key] == options[1] and Color3.fromRGB(100,50,150) or Color3.fromRGB(35,25,55)
    btn1.TextColor3 = Color3.new(1,1,1)
    btn1.Font = Enum.Font.SourceSans
    btn1.TextSize = 12
    btn1.BorderSizePixel = 1
    btn1.BorderColor3 = Color3.fromRGB(80,60,120)
    btn1.AutoButtonColor = false
    btn1.MouseButton1Click:Connect(function()
        Settings[key] = options[1]
        label.Text = text .. ": " .. options[1]
        btn1.BackgroundColor3 = Color3.fromRGB(100,50,150)
        btn2.BackgroundColor3 = Color3.fromRGB(35,25,55)
    end)

    local btn2 = Instance.new("TextButton", btnFrame)
    btn2.Size = UDim2.new(0.5, -2, 1, 0)
    btn2.Position = UDim2.new(0.5, 2, 0, 0)
    btn2.Text = options[2]
    btn2.BackgroundColor3 = Settings[key] == options[2] and Color3.fromRGB(100,50,150) or Color3.fromRGB(35,25,55)
    btn2.TextColor3 = Color3.new(1,1,1)
    btn2.Font = Enum.Font.SourceSans
    btn2.TextSize = 12
    btn2.BorderSizePixel = 1
    btn2.BorderColor3 = Color3.fromRGB(80,60,120)
    btn2.AutoButtonColor = false
    btn2.MouseButton1Click:Connect(function()
        Settings[key] = options[2]
        label.Text = text .. ": " .. options[2]
        btn2.BackgroundColor3 = Color3.fromRGB(100,50,150)
        btn1.BackgroundColor3 = Color3.fromRGB(35,25,55)
    end)

    content.CanvasSize += UDim2.new(0,0,0,84)
end

-- Заполняем вкладки (все функции реальны)
addToggle(contents[1], "Enable Farm", "EnableFarm")
addToggle(contents[1], "Auto Quest", "AutoQuest")

addToggle(contents[2], "Auto Spam", "AutoSpam")
addToggle(contents[2], "WILD SPAM", "WildSpam")
addSlider(contents[2], "Spam Speed", "SpamSpeed", 0.001, 0.5)
addToggle(contents[2], "Auto Parry", "AutoParry")
addSlider(contents[2], "Parry Radius", "ParryRadius", 10, 100)
addToggle(contents[2], "Auto Block", "AutoBlock")

addToggle(contents[3], "Auto Kill", "AutoKill")
addSlider(contents[3], "Kill Radius", "KillRadius", 20, 200)
addDropdown(contents[3], "Target Mode", "KillTarget", {"Random", "Nearest"})

addToggle(contents[4], "Auto Spin", "AutoSpin")
addToggle(contents[4], "Auto Emote", "AutoEmote")
addSlider(contents[4], "Emote Interval", "EmoteInterval", 1, 10)
addToggle(contents[4], "No Cooldown Emotes", "NoCooldownEmotes")
addToggle(contents[4], "Super Jump", "SuperJump")

addToggle(contents[5], "Invisible Ball", "InvisibleBall")
addToggle(contents[5], "Fake Lag", "FakeLag")
addToggle(contents[5], "Reverse Controls", "ReverseControls")
addToggle(contents[5], "Screen Shake", "ScreenShake")
addToggle(contents[5], "Confuse Enemies", "ConfuseEnemies")

addToggle(contents[6], "Auto Dance", "AutoDance")
addToggle(contents[6], "Disco Mode", "DiscoMode")
addToggle(contents[6], "Auto Chat", "AutoChat")
addToggle(contents[6], "Fun Facts", "FunFacts")
addToggle(contents[6], "Joke of Day", "JokeOfDay")

addToggle(contents[7], "God Mode", "GodMode")
addToggle(contents[7], "Ultra Speed", "UltraSpeed")
addToggle(contents[7], "Always Parry", "AlwaysParry")
addToggle(contents[7], "Fly Mode", "FlyMode")

addToggle(contents[8], "ESP", "ESP")
addSlider(contents[8], "Walk Speed", "Speed", 16, 200)

addToggle(contents[9], "Anti-Ban System", "AntiBan")
addSlider(contents[9], "Action Delay", "ActionDelay", 0.1, 2.0)

-- ==================== РЕАЛЬНЫЕ ФУНКЦИИ ====================
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

local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end

-- AutoKill (реальный)
local lastKill = 0
local function autoKill()
    if not Settings.AutoKill then return end
    local ball = getBall() if not ball then return end
    local root = getRoot() if not root then return end
    local dist = (root.Position - ball.Position).Magnitude
    if dist > Settings.KillRadius then return end
    if tick() - lastKill < 1.5 then return end
    local target
    if Settings.KillTarget == "Nearest" then
        local nearest, ndist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < ndist then ndist = d; nearest = p.Character.HumanoidRootPart end
            end
        end
        target = nearest
    else
        local candidates = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(candidates, p.Character.HumanoidRootPart)
            end
        end
        if #candidates > 0 then target = candidates[math.random(#candidates)] end
    end
    if not target then return end
    lastKill = tick()
    local dir = (target.Position - ball.Position).Unit
    root.CFrame = CFrame.new(target.Position - dir * 5, target.Position)
    VIM:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
    task.wait(0.01)
    VIM:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
end

-- AutoSpam / WildSpam
local function wildSpam()
    if not Settings.WildSpam then return end
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local lastSpam = 0
local function autoSpam()
    if not Settings.AutoSpam or Settings.WildSpam then return end
    if tick() - lastSpam < Settings.SpamSpeed then return end
    lastSpam = tick()
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- AutoParry / AlwaysParry
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

-- AutoBlock
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
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local h = p.Character.Head
            local b = Instance.new("BillboardGui", h)
            b.Name = "ESP_Tag"
            b.Adornee = h
            b.Size = UDim2.new(0, 100, 0, 20)
            b.AlwaysOnTop = true
            local t = Instance.new("TextLabel", b)
            t.Size = UDim2.new(1,0,1,0)
            t.BackgroundTransparency = 1
            t.Text = p.Name
            t.TextColor3 = Color3.new(1,0.5,0)
            t.Font = Enum.Font.SourceSansBold
            t.TextSize = 12
        end
    end
    local ball = getBall()
    if ball then
        local b = Instance.new("BillboardGui", ball)
        b.Name = "ESP_Tag"
        b.Adornee = ball
        b.Size = UDim2.new(0, 100, 0, 20)
        b.AlwaysOnTop = true
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1,0,1,0)
        t.BackgroundTransparency = 1
        t.Text = "BALL"
        t.TextColor3 = Color3.new(0,1,1)
        t.Font = Enum.Font.SourceSansBold
        t.TextSize = 12
    end
end

-- AutoQuest
local lastQuest = 0
local function autoQuest()
    if not Settings.AutoQuest then return end
    if tick() - lastQuest < 5 then return end
    lastQuest = tick()
    local gui = LocalPlayer:WaitForChild("PlayerGui")
    local btn = gui:FindFirstChild("MainGui") and gui.MainGui:FindFirstChild("QuestsButton")
    if not btn then return end
    fireclickdetector(btn)
    task.wait(0.3)
    local frame = gui:FindFirstChild("QuestsFrame") or gui:FindFirstChild("QuestGui")
    if frame then
        for _, c in ipairs(frame:GetDescendants()) do
            if c:IsA("TextButton") or c:IsA("ImageButton") then
                local attr = c:GetAttribute("Text") or c.Name
                if attr and (attr:lower():find("claim") or attr:lower():find("complete")) then
                    fireclickdetector(c)
                end
            end
        end
    end
    fireclickdetector(btn)
end

-- ==================== ВЕСЁЛЫЕ ФУНКЦИИ (РЕАЛЬНЫЕ) ====================
-- AutoSpin
local function autoSpin()
    if not Settings.AutoSpin then return end
    local root = getRoot()
    if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(10), 0) end
end

-- AutoEmote (реально шлёт эмоции)
local lastEmote = 0
local emoteKeys = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five}
local function autoEmote()
    if not Settings.AutoEmote then return end
    if tick() - lastEmote < Settings.EmoteInterval then return end
    lastEmote = tick()
    local key = emoteKeys[math.random(#emoteKeys)]
    if Settings.NoCooldownEmotes then
        -- имитируем быстрое переключение
        for _ = 1, 3 do
            VIM:SendKeyEvent(true, key, false, nil)
            VIM:SendKeyEvent(false, key, false, nil)
            task.wait(0.05)
        end
    else
        VIM:SendKeyEvent(true, key, false, nil)
        VIM:SendKeyEvent(false, key, false, nil)
    end
end

-- SuperJump
local function superJump()
