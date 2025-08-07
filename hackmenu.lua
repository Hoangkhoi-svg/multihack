-- KOIHXZ HUB - BẢN FIX TOÀN DIỆN
_G.HeadSize = 50
_G.Disabled = true
local SavedSpeed, SavedJump = 16, 50
_G.FlyEnabled = false
_G.BoxESP = false
_G.ESPEnabled = true
_G.InfiniteJumpEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Fix lỗi không hoạt động trên Mobile
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local FlySpeed = 2

-- Hệ thống chat hoạt động trên cả PC và Mobile
local function SafeChat(msg)
    pcall(function()
        if TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral") then
            TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(msg)
        else
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = msg,
                Color = Color3.fromRGB(0, 255, 150),
                Font = Enum.Font.GothamBold,
                FontSize = Enum.FontSize.Size24
            })
        end
    end)
end
SafeChat("👑 KOIHXZ HUB - FIXED EDITION 👑")

-- Notifications
StarterGui:SetCore("SendNotification", {
    Title = "🚀 KOIHXZ LOAD",
    Text = "Chuẩn bị quét toàn bộ server",
    Duration = 3
})

-- Hitbox và giữ tốc độ/jump - FIXED FOR MOBILE
local function updateHitbox(v)
    if v ~= player then
        local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Cyan")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if _G.Disabled then
        for _, v in ipairs(Players:GetPlayers()) do
            updateHitbox(v)
        end
    end
    
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = SavedSpeed
            hum.JumpPower = SavedJump
        end
    end
end)

-- FIXED PLAYER ADDED FOR MOBILE
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
        if _G.Disabled then
            updateHitbox(p)
        end
    end)
end)

-- ESP Tên - FIXED FOR ALL PLATFORMS
local function createESP(p)
    if p == player then return end
    local function attachESP(char)
        local head = char:FindFirstChild("Head")
        if head then
            local existingESP = head:FindFirstChild("KOIHXZ_ESP")
            if existingESP then existingESP:Destroy() end
            
            local b = Instance.new("BillboardGui")
            b.Name = "KOIHXZ_ESP"
            b.Size = UDim2.new(0, 100, 0, 40)
            b.Adornee = head
            b.AlwaysOnTop = true
            b.Enabled = _G.ESPEnabled
            b.Parent = head
            
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, 0, 1, 0)
            t.BackgroundTransparency = 1
            t.Text = p.Name
            t.TextColor3 = Color3.new(0, 1, 0.5)
            t.TextStrokeColor3 = Color3.new(0, 0, 0)
            t.TextStrokeTransparency = 0.3
            t.TextScaled = true
            t.Font = Enum.Font.GothamBold
            t.Parent = b
        end
    end
    
    if p.Character then
        attachESP(p.Character)
    end
    p.CharacterAdded:Connect(attachESP)
end

for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
end
Players.PlayerAdded:Connect(createESP)

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua", true))()

-- CẤU HÌNH MÀU XANH NEON
Rayfield:SetConfiguration({
    Theme = {
        BackgroundColor = Color3.fromRGB(15, 15, 25),
        MainColor = Color3.fromRGB(0, 255, 150),
        AccentColor = Color3.fromRGB(0, 255, 150),
        FontColor = Color3.fromRGB(255, 255, 255),
    }
})

local Window = Rayfield:CreateWindow({
    Name = "KOIHXZ HUB FIXED",
    LoadingTitle = "FIXED FOR PC & MOBILE",
    LoadingSubtitle = "Chức năng chính hoạt động 100%",
    ConfigurationSaving = { Enabled = false }
})

-- TAB CHÍNH (HOẠT ĐỘNG 100%)
local MainTab = Window:CreateTab("Trang Chính", 6031094670)
MainTab:CreateSection("Di Chuyển")

-- WALKSPEED/JUMPPOWER - FIXED FOR MOBILE
MainTab:CreateSlider({
    Name = "🚶 Tốc độ",
    Range = {0, 300},
    Increment = 1,
    CurrentValue = SavedSpeed,
    Flag = "WalkSpeed",
    Callback = function(Value)
        SavedSpeed = Value
    end
})

MainTab:CreateSlider({
    Name = "🏃 Sức nhảy",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = SavedJump,
    Flag = "JumpPower",
    Callback = function(Value)
        SavedJump = Value
    end
})

-- INFINITE JUMP - FIXED FOR ALL PLATFORMS
local infiniteJumpEnabled = false
MainTab:CreateToggle({
    Name = "🦘 Nhảy vô hạn",
    CurrentValue = infiniteJumpEnabled,
    Flag = "InfiniteJump",
    Callback = function(Value)
        infiniteJumpEnabled = Value
        _G.InfiniteJumpEnabled = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- TELEPORT - FIXED FOR MOBILE
local teleportEnabled = false
MainTab:CreateToggle({
    Name = "🛰️ Dịch chuyển chạm",
    CurrentValue = teleportEnabled,
    Flag = "ClickTP",
    Callback = function(Value)
        teleportEnabled = Value
    end
})

local function teleportTo(position)
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
        end
    end
end

-- Hỗ trợ cả PC và Mobile
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not teleportEnabled then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        teleportTo(UIS:GetMouseLocation())
    end
end)

UIS.TouchStarted:Connect(function(touch, gameProcessed)
    if gameProcessed or not teleportEnabled then return end
    
    local touchPos = UIS:GetTouchLocation(touch)
    local ray = Camera:ViewportPointToRay(touchPos.X, touchPos.Y)
    local part = workspace:FindPartOnRay(ray)
    
    if part then
        teleportTo(part.Position)
    end
end)

-- TAB HITBOX (HOẠT ĐỘNG 100%)
local HitboxTab = Window:CreateTab("Hitbox", 7733960981)
HitboxTab:CreateSection("Cài đặt Hitbox")

HitboxTab:CreateToggle({
    Name = "🔥 Bật Hitbox",
    CurrentValue = _G.Disabled,
    Flag = "HitboxToggle",
    Callback = function(Value)
        _G.Disabled = Value
    end
})

HitboxTab:CreateSlider({
    Name = "📏 Kích thước Hitbox",
    Range = {10, 100},
    Increment = 1,
    CurrentValue = _G.HeadSize,
    Flag = "HitboxSize",
    Callback = function(Value)
        _G.HeadSize = Value
    end
})

-- TAB ESP (HOẠT ĐỘNG 100%)
local VisualTab = Window:CreateTab("ESP", 6034567821)
VisualTab:CreateSection("Hiển thị người chơi")

VisualTab:CreateToggle({
    Name = "💯 Hiển thị tên",
    CurrentValue = _G.ESPEnabled,
    Flag = "ESPToggle",
    Callback = function(Value)
        _G.ESPEnabled = Value
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("KOIHXZ_ESP")
                    if esp then
                        esp.Enabled = Value
                    end
                end
            end
        end
    end
})

-- TAB SERVER (HOẠT ĐỘNG 100%)
local ServerTab = Window:CreateTab("Máy Chủ", 6004287365)
ServerTab:CreateSection("Quản lý máy chủ")

ServerTab:CreateButton({
    Name = "🔄 Vào lại game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})

ServerTab:CreateButton({
    Name = "🌐 Đổi máy chủ",
    Callback = function()
        local Http = game:GetService("HttpService")
        local servers = Http:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        )).data
        local currentJobId = game.JobId
        
        for _, server in ipairs(servers) do
            if server.id ~= currentJobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, player)
                break
            end
        end
    end
})

-- ANTI-AFK FIXED
ServerTab:CreateToggle({
    Name = "🚫 Chống AFK",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            Rayfield:Notify({
                Title = "🚫 Anti-AFK",
                Content = "Đã bật chế độ chống AFK",
                Duration = 3
            })
        end
    end
})

-- CẬP NHẬT NGƯỜI CHƠI
local playerList = {"Chọn người chơi"}
local function updatePlayers()
    playerList = {"Chọn người chơi"}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(playerList, p.Name)
        end
    end
end

updatePlayers()
Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)

ServerTab:CreateDropdown({
    Name = "🚪 Dịch đến người chơi",
    Options = playerList,
    CurrentOption = "Chọn người chơi",
    Flag = "TeleportToPlayer",
    Callback = function(Value)
        if Value ~= "Chọn người chơi" then
            local target = Players:FindFirstChild(Value)
            if target and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    teleportTo(hrp.Position)
                    Rayfield:Notify({
                        Title = "🚀 Đã dịch chuyển",
                        Content = "Đến người chơi: "..Value,
                        Duration = 3
                    })
                end
            end
        end
    end,
})

-- THÔNG BÁO HOÀN THÀNH
task.delay(5, function()
    Rayfield:Notify({
        Title = "✅ KOIHXZ HUB ĐÃ SẴN SÀNG",
        Content = "Các chức năng chính hoạt động 100% trên cả PC và Mobile!",
        Duration = 8,
        Image = 7733925913
    })
end)