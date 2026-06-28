-- Nive Blade Ball Light Edition (гарантированно работает в Xeno)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
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

-- Простое меню
local gui = Instance.new("ScreenGui", CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 250, 0, 230)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(15,10,30)
main.BorderSizePixel = 1
main.BorderColor3 = Color3.fromRGB(160,80,255)
main.Visible = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "NIVE BLADE BALL"
title.BackgroundColor3 = Color3.fromRGB(20,10,40)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SciFi
title.TextSize = 14

local list = Instance.new("UIListLayout", main)
list.Padding = UDim.new(0, 4)
list.Position = UDim2.new(0,0,0,34)

local function addToggle(text, key)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1,-8,0,28)
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
    end)
end

addToggle("Auto Parry", "AutoParry")
addToggle("Auto Block", "AutoBlock")
addToggle("ESP", "ESP")
addToggle("Flight", "Flight")
addToggle("NoClip", "NoClip")
addToggle("Inf Jump", "InfJump")

-- Speed
local speedFrame = Instance.new("Frame", main)
speedFrame.Size = UDim2.new(1,-8,0,28)
speedFrame.BackgroundTransparency = 1
local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0,80,1,0)
speedLabel.Text = "Speed: " .. Settings.Speed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 13
local speedInput = Instance.new("TextBox", speedFrame)
speedInput.Size = UDim2.new(1,-85,1,0)
speedInput.Position = UDim2.new(0,85,0,0)
speedInput.Text = tostring(Settings.Speed)
speedInput.BackgroundColor3 = Color3.fromRGB(40,30,60)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.SourceSans
speedInput.PlaceholderText = "Speed"
speedInput.BorderSizePixel = 1
speedInput.BorderColor3 = Color3.fromRGB(80,60,120)
speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then Settings.Speed = num; speedLabel.Text = "Speed: " .. num end
end)

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

print("Nive Blade Ball Light загружен!")
