--// ✅ KOIHXZ HUB - UI NÚT TRÒN MỞ MENU GIỮA MÀN HÌNH (ĐÃ FIX)
-- Gồm: Walk, Jump, Hitbox Toggle, ClickTP, ESP, Auto Hitbox, Chat Exec

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

--// ✅ THÔNG BÁO EXEC
StarterGui:SetCore("SendNotification", {Title="🚀KOIHXZ HUB ĐANG KHỞI ĐỘNG...", Text="Chuẩn bị quét toàn bộ server", Duration=3})
task.delay(3.2, function()
    StarterGui:SetCore("SendNotification", {Title="🛡️KOIHXZ HUB THỐNG TRỊ SERVER", Text="Hitbox auto toàn server. Người mới cũng dính.", Icon="rbxassetid://7489181066", Duration=6})
end)
task.delay(6.5, function()
    StarterGui:SetCore("SendNotification", {Title="⭐ HAHAAHAHAH ⭐", Text=" ĐỊT MẸ TỤI MÀY ", Duration=8})
end)

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

--// ✅ UI TRÒN + MENU
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KOIHXZ_MAIN"
gui.ResetOnSpawn = false

local mainBtn = Instance.new("ImageButton", gui)
mainBtn.Name = "MainToggle"
mainBtn.Size = UDim2.new(0, 60, 0, 60)
mainBtn.Position = UDim2.new(0, 20, 0.8, 0)
mainBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainBtn.Image = "rbxassetid://160408646"
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

-- Walk Input
local walkBox = Instance.new("TextBox", menu)
walkBox.PlaceholderText = "WalkSpeed (16)"
walkBox.Size = UDim2.new(1, -20, 0, 40)
walkBox.Position = UDim2.new(0, 10, 0, 10)
walkBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
walkBox.TextColor3 = Color3.new(1,1,1)
walkBox.Font = Enum.Font.Gotham
walkBox.TextScaled = true
walkBox.ClearTextOnFocus = false
Instance.new("UICorner", walkBox)
walkBox.FocusLost:Connect(function()
    local val = tonumber(walkBox.Text)
    if val then SavedSpeed = val end
end)

-- Jump Input
local jumpBox = Instance.new("TextBox", menu)
jumpBox.PlaceholderText = "JumpPower (50)"
jumpBox.Size = UDim2.new(1, -20, 0, 40)
jumpBox.Position = UDim2.new(0, 10, 0, 60)
jumpBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextScaled = true
jumpBox.ClearTextOnFocus = false
Instance.new("UICorner", jumpBox)
jumpBox.FocusLost:Connect(function()
    local val = tonumber(jumpBox.Text)
    if val then SavedJump = val end
end)

-- HITBOX TOGGLE
local hitboxToggle = Instance.new("TextButton", menu)
hitboxToggle.Size = UDim2.new(1, -20, 0, 40)
hitboxToggle.Position = UDim2.new(0, 10, 0, 110)
hitboxToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hitboxToggle.TextColor3 = Color3.new(1,1,1)
hitboxToggle.Font = Enum.Font.GothamBold
hitboxToggle.TextScaled = true
hitboxToggle.Text = "🎯 Hitbox: ON"
Instance.new("UICorner", hitboxToggle)

hitboxToggle.MouseButton1Click:Connect(function()
    _G.Disabled = not _G.Disabled
    hitboxToggle.Text = _G.Disabled and "🎯 Hitbox: ON" or "🎯 Hitbox: OFF"
    hitboxToggle.BackgroundColor3 = _G.Disabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(80, 80, 80)
    if not _G.Disabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player then
                pcall(function()
                    local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.BrickColor = BrickColor.new("Medium stone grey")
                        hrp.Material = Enum.Material.Plastic
                        hrp.CanCollide = true
                    end
                end)
            end
        end
    end
end)

-- CLICK TP TOGGLE
local teleportEnabled = false
local tpToggle = Instance.new("TextButton", menu)
tpToggle.Size = UDim2.new(1, -20, 0, 40)
tpToggle.Position = UDim2.new(0, 10, 0, 160)
tpToggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpToggle.TextColor3 = Color3.new(1,1,1)
tpToggle.Font = Enum.Font.GothamBold
tpToggle.TextScaled = true
tpToggle.Text = "🛸 Click TP: OFF"
Instance.new("UICorner", tpToggle)

tpToggle.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    tpToggle.Text = teleportEnabled and "🛸 Click TP: ON" or "🛸 Click TP: OFF"
    tpToggle.BackgroundColor3 = teleportEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
end)

-- TP support (Mobile + PC)
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

local function onPlayerDied(victim)
    if not victim or not victim.Character then return end
    local humanoid = victim.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.Died:Connect(function()
        local tag = humanoid:FindFirstChild("creator")
        if tag and tag.Value == player then
            SafeChat("💀 Bạn đã hạ gục: " .. victim.Name)
            StarterGui:SetCore("SendNotification", {
                Title = "💀 KILL!",
                Text = "Bạn đã tiễn " .. victim.Name .. " lên bảng!",
                Duration = 4
            })
        end
    end)
end

-- Theo dõi tất cả người chơi
for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then onPlayerDied(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= player then onPlayerDied(p) end
end)