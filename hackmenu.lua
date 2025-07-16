--// ✅ CẤU HÌNH
_G.HeadSize = 50
_G.Disabled = true
local SavedSpeed = 16
local SavedJump = 50

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--// ✅ CHAT KHI EXEC
local function SafeChat(msg)
    pcall(function()
        if TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral") then
            TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(msg)
        else
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = msg,
                Color = Color3.fromRGB(255, 255, 0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end
    end)
end
SafeChat("👑 Nhà Vua Đã Tới | The King Has Arrived 👑")

--// ✅ THÔNG BÁO EXEC
StarterGui:SetCore("SendNotification", {
    Title = "🚀 KOIHXZ HUB ĐANG KHỞI ĐỘNG...",
    Text = "Chuẩn bị quét toàn bộ server",
    Duration = 3
})

task.delay(3.2, function()
    StarterGui:SetCore("SendNotification", {
        Title = "🛡️ KOIHXZ HUB THỐNG TRỊ SERVER",
        Text = "Hitbox auto toàn server. Người mới cũng dính.",
        Icon = "rbxassetid://7489181066",
        Duration = 6
    })
end)

task.delay(6.5, function()
    StarterGui:SetCore("SendNotification", {
        Title = "⭐ TUỲ CHỌN NÂNG CẤP ⭐",
        Text = "Gõ /vip để mở chế độ PRO: ESP, Silent, Antiban,...",
        Duration = 8
    })
end)

--// ✅ TĂNG HITBOX TOÀN SERVER + GIỮ TỐC ĐỘ + NHẢY
RunService.RenderStepped:Connect(function()
    if _G.Disabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Players.LocalPlayer then
                pcall(function()
                    local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really blue")
                        hrp.Material = "Neon"
                        hrp.CanCollide = false
                    end
                end)
            end
        end
    end

    -- Giữ nguyên tốc độ và nhảy
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed ~= SavedSpeed then
            humanoid.WalkSpeed = SavedSpeed
        end
        if humanoid.JumpPower ~= SavedJump then
            humanoid.JumpPower = SavedJump
        end
    end
end)

--// ✅ ÁP DỤNG HITBOX CHO NGƯỜI MỚI VÀO
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        wait(1)
        if _G.Disabled then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
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

--// ✅ ESP – HIỆN TÊN THU NHỎ TRÊN ĐẦU
function createESP(player)
    if player == Players.LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        repeat wait() until char:FindFirstChild("Head")
        local billboard = Instance.new("BillboardGui", char.Head)
        billboard.Name = "KOIHXZ_ESP"
        billboard.Size = UDim2.new(0, 60, 0, 20)
        billboard.Adornee = char.Head
        billboard.AlwaysOnTop = true

        local text = Instance.new("TextLabel", billboard)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = player.Name
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.GothamBold
    end)
end
for _, p in pairs(Players:GetPlayers()) do
    if p ~= Players.LocalPlayer then
        createESP(p)
    end
end
Players.PlayerAdded:Connect(createESP)

--// ✅ UI GỌN GÀNG – KOIHXZ CONTROL 👑
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "KOIHXZ_UI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("TextButton")
mainFrame.Size = UDim2.new(0, 180, 0, 30)
mainFrame.Position = UDim2.new(0, 20, 0, 140)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Text = "👑 KOIHXZ CONTROL 👑"
mainFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Font = Enum.Font.GothamBold
mainFrame.TextScaled = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local expandFrame = Instance.new("Frame", mainFrame)
expandFrame.Size = UDim2.new(0, 180, 0, 100)
expandFrame.Position = UDim2.new(0, 0, 1, 0)
expandFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
expandFrame.Visible = false

local toggle = false
mainFrame.MouseButton1Click:Connect(function()
    toggle = not toggle
    expandFrame.Visible = toggle
end)

-- WalkSpeed Box
local wsBox = Instance.new("TextBox", expandFrame)
wsBox.PlaceholderText = "WalkSpeed (default 16)"
wsBox.Size = UDim2.new(1, -10, 0, 30)
wsBox.Position = UDim2.new(0, 5, 0, 5)
wsBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
wsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBox.ClearTextOnFocus = false
wsBox.Font = Enum.Font.Gotham
wsBox.TextScaled = true
wsBox.FocusLost:Connect(function()
	local val = tonumber(wsBox.Text)
	if val then
		SavedSpeed = val
		player.Character.Humanoid.WalkSpeed = val
	end
end)

-- JumpPower Box
local jpBox = Instance.new("TextBox", expandFrame)
jpBox.PlaceholderText = "JumpPower (default 50)"
jpBox.Size = UDim2.new(1, -10, 0, 30)
jpBox.Position = UDim2.new(0, 5, 0, 40)
jpBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
jpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jpBox.ClearTextOnFocus = false
jpBox.Font = Enum.Font.Gotham
jpBox.TextScaled = true
jpBox.FocusLost:Connect(function()
	local val = tonumber(jpBox.Text)
	if val then
		SavedJump = val
		player.Character.Humanoid.JumpPower = val
	end
end)
--// ✅ CLICK TELEPORT CHO CẢ MOBILE & PC
local teleportEnabled = false
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Nút bật tắt TP
local tpButton = Instance.new("TextButton")
tpButton.Name = "TeleportToggle"
tpButton.Size = UDim2.new(0, 140, 0, 35)
tpButton.Position = UDim2.new(0, 20, 0, 100)
tpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpButton.Text = "🛸 INVITE (Click TP: OFF)"
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextScaled = true
tpButton.Parent = player:WaitForChild("PlayerGui"):WaitForChild("KOIHXZ_UI")

tpButton.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    tpButton.Text = teleportEnabled and "🛸 INVITE (Click TP: ON)" or "🛸 INVITE (Click TP: OFF)"
    tpButton.BackgroundColor3 = teleportEnabled and Color3.fromRGB(30, 150, 80) or Color3.fromRGB(60, 60, 60)
end)

-- ✅ Hỗ trợ cả PC (chuột) và Mobile (chạm)
local function teleportToPosition(pos)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- PC: click chuột
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not teleportEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = mouse.Hit and mouse.Hit.Position
        if pos then
            teleportToPosition(pos)
        end
    end
end)

-- Mobile: chạm màn hình
UIS.TouchTap:Connect(function(touchPositions, isProcessed)
    if not teleportEnabled or isProcessed then return end
    local pos = mouse.Hit and mouse.Hit.Position
    if pos then
        teleportToPosition(pos)
    end
end)