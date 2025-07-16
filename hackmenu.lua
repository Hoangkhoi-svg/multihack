--// ✅ KOIHXZ HUB - UI NÚT TRÒN MỞ MENU GIỮA MÀN HÌNH
-- Phiên bản rebuild bởi ChatGPT theo yêu cầu UI mới
-- Gồm: Walk, Jump, Hitbox Toggle, ClickTP, ESP, Auto Hitbox, Chat Exec, AntiAFK

--// ✅ CONFIG
_G.HeadSize = 50
_G.Disabled = true
local SavedSpeed, SavedJump = 16, 50

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// ✅ CHAT EXEC
local function SafeChat(msg)
    pcall(function()
        if TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral") then
            TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(msg)
        else
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = msg,
                Color = Color3.fromRGB(255,255,0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end
    end)
end
SafeChat("👑 Nhà Vua Đã Tới | The King Has Arrived 👑")

--// ✅ NOTIFY EXEC
StarterGui:SetCore("SendNotification", {Title="🚀 KOIHXZ HUB", Text="Script đã kích hoạt!", Duration=3})

--// ✅ AUTO HITBOX + GIỮ SPEED/JUMP
RunService.RenderStepped:Connect(function()
    if _G.Disabled then
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= player then
                local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really blue")
                        hrp.Material = "Neon"
                        hrp.CanCollide = false
                    end)
                end
            end
        end
    end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = SavedSpeed
        hum.JumpPower = SavedJump
    end
end)

--// ✅ APPLY HITBOX NGƯỜI MỚI
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        repeat wait() until p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        wait(1)
        if _G.Disabled then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Really blue")
                    hrp.Material = "Neon"
                    hrp.CanCollide = false
                end)
            end
        end
    end)
end)

--// ✅ ESP TÊN
function createESP(p)
    if p == player then return end
    p.CharacterAdded:Connect(function(char)
        repeat wait() until char:FindFirstChild("Head")
        local b = Instance.new("BillboardGui", char.Head)
        b.Name = "KOIHXZ_ESP"
        b.Size = UDim2.new(0,60,0,20)
        b.Adornee = char.Head
        b.AlwaysOnTop = true
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1,0,1,0)
        t.BackgroundTransparency = 1
        t.Text = p.Name
        t.TextColor3 = Color3.new(1,1,1)
        t.TextStrokeTransparency = 0
        t.TextScaled = true
        t.Font = Enum.Font.GothamBold
    end)
end
for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then createESP(p) end
end
Players.PlayerAdded:Connect(createESP)

--// ✅ UI CHỦ ĐẠO - NÚT TRÒN BẬT MENU
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KOIHXZ_MAIN"
gui.ResetOnSpawn = false

local mainBtn = Instance.new("ImageButton", gui)
mainBtn.Name = "MainToggle"
mainBtn.Size = UDim2.new(0, 60, 0, 60)
mainBtn.Position = UDim2.new(0, 20, 0.8, 0)
mainBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainBtn.Image = "rbxassetid://160408646" -- Icon nút
mainBtn.AutoButtonColor = true

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 240, 0, 220)
menu.Position = UDim2.new(0.5, -120, 0.5, -110)
menu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

mainBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

local function createButton(name, yPos, callback)
    local btn = Instance.new("TextButton", menu)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextScaled = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- WALK
createButton("🚶 WalkSpeed", 10, function()
    local input = tonumber(game:GetService("Players").LocalPlayer:PromptInput("Điền tốc độ đi (VD: 16):"))
    if input then SavedSpeed = input end
end)

-- JUMP
createButton("🪂 JumpPower", 60, function()
    local input = tonumber(game:GetService("Players").LocalPlayer:PromptInput("Điền lực nhảy (VD: 50):"))
    if input then SavedJump = input end
end)

-- HITBOX TOGGLE
createButton("🎯 Toggle Hitbox", 110, function()
    _G.Disabled = not _G.Disabled
    SafeChat("🎯 Hitbox " .. (_G.Disabled and "BẬT" or "TẮT"))
end)

-- CLICK TP
local teleportEnabled = false
createButton("🛸 Click Teleport", 160, function()
    teleportEnabled = not teleportEnabled
    SafeChat("🛸 Click TP " .. (teleportEnabled and "BẬT" or "TẮT"))
end)

-- TP hỗ trợ
local mouse = player:GetMouse()
UIS.InputBegan:Connect(function(i, g)
    if g or not teleportEnabled then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = mouse.Hit and mouse.Hit.Position
        if pos then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0)) end
        end
    end
end)

UIS.TouchTap:Connect(function(_, g)
    if g or not teleportEnabled then return end
    local pos = mouse.Hit and mouse.Hit.Position
    if pos then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0)) end
    end
end)
