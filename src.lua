-- Nive Blade Ball Ultimate Cosmic Script (Xeno compatible)
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
    -- Main
    AutoLoad = false,
    AntiAFK = true,
    -- Combat
    AutoParry = false,
    AutoBlock = false,
    AutoDodge = false,
    ParryRadius = 30,
    -- Visual
    Theme = "Cosmic",
    Speed = 16,
    InfJump = false,
    Flight = false,
    NoClip = false,
    ESP = false,
    BallTrajectory = false,
    -- Defense
    GodMode = false,
    AntiBan = true,
    -- Teleport
    CustomX = 0, CustomY = 0, CustomZ = 0,
    -- Fun
    SuperJump = false,
    FlySpeed = 50,
    -- Server
    ServerHop = false,
    -- Settings
    MenuOpen = true,
    LastAction = 0,
    ActionDelay = 0.3,
    -- Stats
    Parries = 0,
    Blocks = 0
}

-- ==================== BLACK HOLE INTRO ====================
spawn(function()
    local bg = Instance.new("ScreenGui", CoreGui)
    local f = Instance.new("Frame", bg)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Color3.new(0,0,0)
    f.BackgroundTransparency = 1
    TweenService:Create(f, TweenInfo.new(1.5), {BackgroundTransparency = 0.2}):Play()
    for _=1,30 do
        local p = Instance.new("Frame", bg)
        p.Size = UDim2.new(0,4,0,4)
        p.BackgroundColor3 = Color3.new(1,1,1)
        p.Position = UDim2.new(0.5, math.random(-200,200), 0.5, math.random(-200,200))
        p.AnchorPoint = Vector2.new(0.5,0.5)
        local t = TweenService:Create(p, TweenInfo.new(2, Enum.EasingStyle.InQuad), {
            Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0,0,0,0),
            BackgroundTransparency = 1
        })
        t:Play()
        task.delay(2.5, function() p:Destroy() end)
    end
    local logo = Instance.new("TextLabel", bg)
    logo.Size = UDim2.new(0,200,0,50)
    logo.Position = UDim2.new(0.5,-100,0.4,-25)
    logo.Text = "NIVE"
    logo.TextColor3 = Color3.fromRGB(180,100,255)
    logo.Font = Enum.Font.SciFi
    logo.TextSize = 24
    logo.BackgroundTransparency = 1
    logo.TextTransparency = 1
    TweenService:Create(logo, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    wait(2.5)
    bg:Destroy()
end)

-- ==================== GUI ====================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NiveBladeBall"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,360,0,460)
main.Position = UDim2.new(0,20,0,20)
main.BackgroundColor3 = Color3.fromRGB(15,10,30)
main.BorderSizePixel = 1
main.BorderColor3 = Color3.fromRGB(160,80,255)
main.Visible = Settings.MenuOpen

-- Пульсирующая рамка
spawn(function()
    while main and main.Parent do
        local r = math.sin(tick() * 5) * 0.3 + 0.7
        main.BorderColor3 = Color3.fromRGB(160*r, 80*r, 255)
        wait()
    end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🌌 NIVE BLADE BALL"
title.BackgroundColor3 = Color3.fromRGB(20,10,40)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SciFi
title.TextSize = 16
title.BorderSizePixel = 0

-- Tab bar (20 tabs)
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1,0,0,28)
tabFrame.Position = UDim2.new(0,0,0,32)
tabFrame.BackgroundTransparency = 1

local tabNames = {
    "Main","Combat","Visual","Defense","Teleport","Fun","Server","Settings","Stats","Credits",
    "AutoCollect","SpeedMod","ESP2","FlyMod","AntiStun","InstantRespawn","ChatBypass","EmoteSpam","ServerLock","CustomTheme"
}
local tabBtns = {}
local contents = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1/#tabNames, -1, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabNames, 1, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(100,50,150) or Color3.fromRGB(50,40,80)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 8
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(120,100,180)
    table.insert(tabBtns, btn)

    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1,0,1,-66)
    content.Position = UDim2.new(0,0,0,64)
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.ScrollBarThickness = 4
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Visible = i == 1
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0,6)
    table.insert(contents, content)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(50,40,80) end
        btn.BackgroundColor3 = Color3.fromRGB(100,50,150)
        for _, c in ipairs(contents) do c.Visible = false end
        content.Visible = true
    end)
end

-- Helper functions with visual effects
local function addToggle(content, text, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1,-4,0,30)
    btn.Text = "  " .. text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40,30,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80,60,120)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
        -- Эффект всплеска
        spawnEffect(btn.AbsolutePosition + btn.AbsoluteSize/2)
    end)
    content.CanvasSize += UDim2.new(0,0,0,36)
    return btn
end

local function addButton(content, text, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1,-4,0,30)
    btn.Text = "  " .. text
    btn.BackgroundColor3 = Color3.fromRGB(40,30,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80,60,120)
    btn.MouseButton1Click:Connect(callback)
    content.CanvasSize += UDim2.new(0,0,0,36)
    return btn
end

-- Частицы при активации
function spawnEffect(position)
    for _=1,8 do
        local particle = Instance.new("Frame", gui)
        particle.Size = UDim2.new(0,6,0,6)
        particle.Position = UDim2.new(0, position.X, 0, position.Y)
        particle.BackgroundColor3 = Color3.fromRGB(255,100,255)
        particle.BorderSizePixel = 0
        local destX = position.X + math.random(-50,50)
        local destY = position.Y + math.random(-50,50)
        TweenService:Create(particle, TweenInfo.new(0.3), {
            Position = UDim2.new(0, destX, 0, destY),
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,0)
        }):Play()
        task.delay(0.3, function() particle:Destroy() end)
    end
end

-- ================== POPULATE TABS ==================
-- Main
addButton(contents[1], "Enable All Functions", function()
    for k,v in pairs(Settings) do
        if type(v) == "boolean" and k ~= "MenuOpen" then Settings[k] = true end
    end
    print("All functions enabled.")
end)
addButton(contents[1], "Disable All Functions", function()
    for k,v in pairs(Settings) do
        if type(v) == "boolean" and k ~= "MenuOpen" then Settings[k] = false end
    end
    print("All functions disabled.")
end)
addToggle(contents[1], "Anti AFK", "AntiAFK")

-- Combat
addToggle(contents[2], "Auto Parry", "AutoParry")
addToggle(contents[2], "Auto Block", "AutoBlock")
addToggle(contents[2], "Auto Dodge", "AutoDodge")
local radiusLabel = Instance.new("TextLabel", contents[2])
radiusLabel.Size = UDim2.new(1,0,0,20)
radiusLabel.Text = "Parry Radius: " .. Settings.ParryRadius
radiusLabel.TextColor3 = Color3.new(1,1,1)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Font = Enum.Font.SourceSans
radiusLabel.TextSize = 13
contents[2].CanvasSize += UDim2.new(0,0,0,26)
local radiusInput = Instance.new("TextBox", contents[2])
radiusInput.Size = UDim2.new(1,-4,0,28)
radiusInput.Text = tostring(Settings.ParryRadius)
radiusInput.BackgroundColor3 = Color3.fromRGB(40,30,60)
radiusInput.TextColor3 = Color3.new(1,1,1)
radiusInput.Font = Enum.Font.SourceSans
radiusInput.PlaceholderText = "Radius"
radiusInput.BorderSizePixel = 1
radiusInput.BorderColor3 = Color3.fromRGB(80,60,120)
radiusInput.FocusLost:Connect(function()
    local num = tonumber(radiusInput.Text)
    if num then Settings.ParryRadius = num; radiusLabel.Text = "Parry Radius: " .. num end
end)
contents[2].CanvasSize += UDim2.new(0,0,0,36)

-- Visual
addToggle(contents[3], "Inf Jump", "InfJump")
addToggle(contents[3], "Flight", "Flight")
addToggle(contents[3], "NoClip", "NoClip")
addToggle(contents[3], "ESP", "ESP")
addToggle(contents[3], "Ball Trajectory", "BallTrajectory")
local speedLabel = Instance.new("TextLabel", contents[3])
speedLabel.Size = UDim2.new(1,0,0,20)
speedLabel.Text = "Speed: " .. Settings.Speed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 13
contents[3].CanvasSize += UDim2.new(0,0,0,26)
local speedInput = Instance.new("TextBox", contents[3])
speedInput.Size = UDim2.new(1,-4,0,28)
speedInput.Text = tostring(Settings.Speed)
speedInput.BackgroundColor3 = Color3.fromRGB(40,30,60)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.SourceSans
speedInput.PlaceholderText = "Speed"
speedInput.BorderSizePixel = 1
speedInput.BorderColor3 = Color3.fromRGB(80,60,120)
speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then Settings.Speed = num; speedLabel.Text = "Speed: " .. num; local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid"); if hum then hum.WalkSpeed = num end end
end)
contents[3].CanvasSize += UDim2.new(0,0,0,36)

-- Defense
addToggle(contents[4], "God Mode", "GodMode")
addToggle(contents[4], "Anti Ban", "AntiBan")

-- Teleport
addButton(contents[5], "Teleport to Ball", function()
    local root = getRoot()
    if not root then return end
    local ball = findBall()
    if ball then root.CFrame = CFrame.new(ball.Position + Vector3.new(0,3,0)) end
end)
addButton(contents[5], "Teleport to Nearest Player", function()
    local root = getRoot()
    if not root then return end
    local nearest = findNearestPlayer()
    if nearest then root.CFrame = CFrame.new(nearest.Position + Vector3.new(0,3,0)) end
end)
addButton(contents[5], "Teleport to Center", function()
    local root = getRoot()
    if root then root.CFrame = CFrame.new(0, 10, 0) end
end)

-- Fun
addToggle(contents[6], "Super Jump", "SuperJump")

-- Server
addButton(contents[7], "Server Hop", function()
    local servers, cursor = {}, ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100&cursor=" .. cursor
        local ok, data = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if ok then
            for _, s in ipairs(data.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
            cursor = data.nextPageCursor or ""
        else break end
    until cursor == "" or #servers >= 10
    if #servers > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer) end
end)

-- Settings
addToggle(contents[8], "Auto Load on Start", "AutoLoad")
addButton(contents[8], "Reset All Settings", function()
    for k in pairs(Settings) do
        if type(Settings[k]) == "boolean" then Settings[k] = false end
    end
    Settings.Speed = 16
    Settings.Theme = "Cosmic"
    print("Settings reset.")
end)

-- Stats
local statsLabel = Instance.new("TextLabel", contents[9])
statsLabel.Size = UDim2.new(1,0,0,40)
statsLabel.Text = "Parries: " .. Settings.Parries .. "\nBlocks: " .. Settings.Blocks
statsLabel.TextColor3 = Color3.new(1,1,1)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.SourceSans
statsLabel.TextSize = 13
contents[9].CanvasSize += UDim2.new(0,0,0,40)

-- Credits
local cred = Instance.new("TextLabel", contents[10])
cred.Size = UDim2.new(1,0,0,60)
cred.Text = "Nive Blade Ball Ultimate\nCreated by Nive\nSupport: donationalerts.com/r/nive"
cred.TextColor3 = Color3.new(0.8,0.6,1); cred.BackgroundTransparency = 1
cred.Font = Enum.Font.SourceSans; cred.TextSize = 13; cred.TextWrapped = true
contents[10].CanvasSize += UDim2.new(0,0,0,60)

-- ==================== ANIMATED RIGHT ALT TOGGLE WITH BLACK HOLE ====================
local bh = Instance.new("Frame", gui)
bh.Size = UDim2.new(0,0,0,0)
bh.Position = UDim2.new(0.5,0,0.5,0)
bh.AnchorPoint = Vector2.new(0.5,0.5)
bh.BackgroundColor3 = Color3.new(0,0,0)
bh.BorderSizePixel = 0
bh.Visible = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        Settings.MenuOpen = not Settings.MenuOpen
        
        if Settings.MenuOpen then
            main.Visible = true
            main.BackgroundTransparency = 1
            main.Position = UDim2.new(0,20,0,70)
            TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                BackgroundTransparency = 0,
                Position = UDim2.new(0,20,0,20)
            }):Play()
        else
            bh.Size = UDim2.new(0,0,0,0)
            bh.BackgroundTransparency = 0
            bh.Visible = true
            local expand = TweenService:Create(bh, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0,300,0,300)
            })
            expand:Play()
            expand.Completed:Connect(function()
                local shrink = TweenService:Create(bh, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0,0,0,0)
                })
                shrink:Play()
                shrink.Completed:Connect(function()
                    bh.Visible = false
                end)
            end)
            TweenService:Create(main, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0,20,0,50)
            }):Play()
            wait(0.2)
            main.Visible = false
        end
    end
end)

-- ==================== UTILITY FUNCTIONS ====================
function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
function getRoot() return getChar() and getChar():FindFirstChild("HumanoidRootPart") end
function getHum() return getChar() and getChar():FindFirstChild("Humanoid") end
function canAct()
    if not Settings.AntiBan then return true end
    if tick() - Settings.LastAction >= Settings.ActionDelay then
        Settings.LastAction = tick()
        return true
    end
    return false
end

function findBall()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name:lower():find("ball")) then
            return obj
        end
    end
    return nil
end

function findNearestPlayer()
    local root = getRoot()
    if not root then return nil end
    local nearest, ndist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < ndist then ndist = dist; nearest = hrp end
            end
        end
    end
    return nearest
end

-- ==================== FEATURE FUNCTIONS ====================
local function autoParry()
    if not Settings.AutoParry or not canAct() then return end
    local root = getRoot()
    if not root then return end
    local ball = findBall()
    if not ball then return end
    local dist = (root.Position - ball.Position).Magnitude
    if dist < Settings.ParryRadius then
        VIM:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
        Settings.Parries = Settings.Parries + 1
        Settings.LastAction = tick()
    end
end

local function autoBlock()
    if not Settings.AutoBlock or not canAct() then return end
    VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    wait(0.1)
    VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    Settings.Blocks = Settings.Blocks + 1
    Settings.LastAction = tick()
end

local function autoDodge()
    if not Settings.AutoDodge or not canAct() then return end
    local root = getRoot()
    if not root then return end
    local ball = findBall()
    if not ball then return end
    local dist = (root.Position - ball.Position).Magnitude
    if dist < Settings.ParryRadius * 1.5 then
        local dir = Vector3.new(math.random(-1,1), 0, math.random(-1,1)).Unit * 50
        local bv = root:FindFirstChild("DodgeVel") or Instance.new("BodyVelocity", root)
        bv.Name = "DodgeVel"
        bv.Velocity = dir
        bv.MaxForce = Vector3.new(1e5,0,1e5)
        task.delay(0.2, function() bv:Destroy() end)
        Settings.LastAction = tick()
    end
end

local function flight()
    if not Settings.Flight then return end
    local root = getRoot()
    local hum = getHum()
    if not root or not hum then return end
    hum.PlatformStand = true
    local bf = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
    bf.Name = "FlyVel"
    bf.MaxForce = Vector3.new(1e5,1e5,1e5)
    local dir = Vector3.new()
    local cam = Workspace.CurrentCamera
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir += Vector3.new(0,-1,0) end
    bf.Velocity = dir * Settings.FlySpeed
end

local function godMode()
    if not Settings.GodMode then return end
    local char = getChar()
    if not char then return end
    local hum = getHum()
    if hum then
        hum.Health = hum.MaxHealth
        hum.MaxHealth = 1e9
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
end

local function noclip()
    if not Settings.NoClip then return end
    local char = getChar()
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end

local function esp()
    if not Settings.ESP then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "ESP_Tag" and v:IsA("BillboardGui") then v:Destroy() end
        end
        return
    end
    -- ESP для игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("ESP_Tag") then
     
