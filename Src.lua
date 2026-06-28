-- Nive Blade Ball Simple Working Script (Xeno compatible)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local Settings = {
    AutoParry = false,
    AutoBlock = false,
    ESP = false,
    Flight = false,
    NoClip = false,
    InfJump = false,
    Speed = 16,
    MenuOpen = true
}

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 350)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(15,10,30)
main.BorderSizePixel = 1
main.BorderColor3 = Color3.fromRGB(160,80,255)
main.Visible = Settings.MenuOpen

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "NIVE BLADE BALL"
title.BackgroundColor3 = Color3.fromRGB(20,10,40)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SciFi
title.TextSize = 16

local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1,0,0,28)
tabFrame.Position = UDim2.new(0,0,0,32)
tabFrame.BackgroundTransparency = 1

local tabs = {"Combat", "Visual", "Defense", "Teleport", "Fun", "Server", "Settings", "Stats", "Credits"}
local tabBtns = {}
local contents = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(1/#tabs, -1, 1, 0)
    btn.Position = UDim2.new((i-1)/#tabs, 1, 0, 0)
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

local function addToggle(content, text, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1,-4,0,30)
    btn.Text = "  " .. text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40,30,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80,60,120)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "  " .. text .. ": " .. (Settings[key] and "ON" or "OFF")
    end)
    content.CanvasSize += UDim2.new(0,0,0,36)
end

-- Заполняем вкладки
addToggle(contents[1], "Auto Parry", "AutoParry")
addToggle(contents[1], "Auto Block", "AutoBlock")

addToggle(contents[2], "ESP", "ESP")
addToggle(contents[2], "Flight", "Flight")
addToggle(contents[2], "NoClip", "NoClip")
addToggle(contents[2], "Inf Jump", "InfJump")
-- Speed
local speedLabel = Instance.new("TextLabel", contents[2])
speedLabel.Size = UDim2.new(1,0,0,20)
speedLabel.Text = "Speed: " .. Settings.Speed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 13
contents[2].CanvasSize += UDim2.new(0,0,0,26)
local speedInput = Instance.new("TextBox", contents[2])
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
contents[2].CanvasSize += UDim2.new(0,0,0,36)

-- Функции
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHum() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end
local function findBall()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Ball" or obj.Name:lower():find("ball")) then return obj end
    end
    return nil
end

local function autoParry()
    if not Settings.AutoParry then return end
    local root = getRoot() if not root then return end
    local ball = findBall() if not ball then return end
    if (root.Position - ball.Position).Magnitude < 30 then
        VIM:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
    end
end

local function autoBlock()
    if not Settings.AutoBlock then return end
    VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
    wait(0.1)
    VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
end

local function flight()
    if not Settings.Flight then return end
    local root = getRoot() local hum = getHum() if not root or not hum then return end
    hum.PlatformStand = true
    local bf = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
    bf.Name = "FlyVel"; bf.MaxForce = Vector3.new(1e5,1e5,1e5)
    local dir = Vector3.new() local cam = Workspace.CurrentCamera
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir += Vector3.new(0,-1,0) end
    bf.Velocity = dir * 50
end

local function noclip()
    if not Settings.NoClip then return end
    local char = LocalPlayer.Character if not char then return end
    for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
end

local function esp()
    if not Settings.ESP then
        for _, v in ipairs(Workspace:GetDescendants()) do if v.Name=="ESP_Tag" and v:IsA("BillboardGui") then v:Destroy() end end
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head and not head:FindFirstChild("ESP_Tag") then
                local bb = Instance.new("BillboardGui", head); bb.Name="ESP_Tag"; bb.Adornee=head; bb.Size=UDim2.new(0,100,0,20); bb.AlwaysOnTop=true
                local tl = Instance.new("TextLabel", bb); tl.Size=UDim2.new(1,0,1,0); tl.BackgroundTransparency=1; tl.Text=player.Name; tl.TextColor3=Color3.new(1,0.5,0); tl.Font=Enum.Font.SourceSansBold; tl.TextSize=12
            end
        end
    end
    local ball = findBall()
    if ball and not ball:FindFirstChild("ESP_Tag") then
        local bb = Instance.new("BillboardGui", ball); bb.Name="ESP_Tag"; bb.Adornee=ball; bb.Size=UDim2.new(0,100,0,20); bb.AlwaysOnTop=true
        local tl = Instance.new("TextLabel", bb); tl.Size=UDim2.new(1,0,1,0); tl.BackgroundTransparency=1; tl.Text="BALL"; tl.TextColor3=Color3.new(0,1,1); tl.Font=Enum.Font.SourceSansBold; tl.TextSize=12
    end
end

-- Main loop
RunService.Heartbeat:Connect(function()
    pcall(autoParry) pcall(autoBlock) pcall(flight) pcall(noclip) pcall(esp)
    if Settings.InfJump then local hum = getHum() if hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then hum.Jump = true end end
    local hum = getHum() if hum then hum.WalkSpeed = Settings.Speed end
end)

print("Nive Blade Ball Simple loaded!")
