-- Tích hợp Rayfield UI vào script KOIHXZ HUB
_G.HeadSize = 50
_G.Disabled = true  -- Hitbox mặc định ON
local SavedSpeed, SavedJump = 16, 50

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Chat System Message
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

-- Notifications
StarterGui:SetCore("SendNotification", {
    Title = "🚀 KOIHXZ LOAD",
    Text = "Chuẩn bị quét toàn bộ server",
    Duration = 3
})
task.delay(3.2, function()
    StarterGui:SetCore("SendNotification", {
        Title = "🛡️ KOIHXZ HUB",
        Text = "Hitbox auto toàn server. Người mới cũng dính.",
        Icon = "rbxassetid://7489181066",
        Duration = 6
    })
end)
task.delay(6.5, function()
    StarterGui:SetCore("SendNotification", {
        Title = "⭐ HAHAAHAHAH ⭐",
        Text = " ĐỊT MẸ TỤI MÀY ",
        Duration = 8
    })
end)

-- Hitbox và giữ tốc độ/jump
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
                        hrp.Material = Enum.Material.Neon
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

-- Gắn hitbox cho người mới vào nếu đang bật
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
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end)
            end
        end
    end)
end)

-- ESP Tên
_G.ESPEnabled = true
function attachESP(char, name)
    local head = char:FindFirstChild("Head")
    if head and not head:FindFirstChild("KOIHXZ_ESP") then
        local b = Instance.new("BillboardGui", head)
        b.Name = "KOIHXZ_ESP"
        b.Size = UDim2.new(0,60,0,20)
        b.Adornee = head
        b.AlwaysOnTop = true
        b.Enabled = _G.ESPEnabled
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1,0,1,0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.new(1,1,1)
        t.TextStrokeTransparency = 0
        t.TextScaled = true
        t.Font = Enum.Font.GothamBold
    end
end
function createESP(p)
    if p == player then return end
    if p.Character then
        attachESP(p.Character, p.Name)
    end
    p.CharacterAdded:Connect(function(char)
        repeat wait() until char:FindFirstChild("Head")
        attachESP(char, p.Name)
    end)
end
for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
end
Players.PlayerAdded:Connect(function(p)
    createESP(p)
end)

-- ======= TẠO GIAO DIỆN RAYFIELD =======
-- Load thư viện Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua", true))()

-- Tạo cửa sổ chính
local Window = Rayfield:CreateWindow({
    Name = "KOIHXZ HUB",
    LoadingTitle = "KOIHXZ HUB UI",
    LoadingSubtitle = "By KoiHxz",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = ""
    }
})

-- Tạo các tab và mục
local MainTab = Window:CreateTab("Main", 4483362458)

-- ==== TAB COMBAT ====
local CombatTab = Window:CreateTab("⚔️ Combat", 6023426912)
CombatTab:CreateToggle({
    Name = "☠️ One Hit Mode",
    CurrentValue = _G.OneHit or false,
    Flag = "OneHit",
    Callback = function(val) _G.OneHit = val end,
})

-- ==== TAB PLAYER ====
local PlayerTab = Window:CreateTab("🕹️ Player", 6026568198)
PlayerTab:CreateToggle({
    Name = "🪂 Fly Mode",
    CurrentValue = _G.FlyEnabled or false,
    Flag = "FlyMode",
    Callback = function(val)
        _G.FlyEnabled = val
        if val then
            local plr = game:GetService("Players").LocalPlayer
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
            -- simple fly logic
            game:GetService("RunService").RenderStepped:Connect(function()
                if _G.FlyEnabled and plr.Character and hum then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    hrp.Velocity = Vector3.new(0, 50, 0)
                end
            end)
        else
            local plr = game:GetService("Players").LocalPlayer
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end,
})

-- ==== TAB VISUAL ====
local VisualTab = Window:CreateTab("🎨 Visual", 6034567821)
VisualTab:CreateToggle({
    Name = "🧊 Box ESP",
    CurrentValue = _G.BoxESP or false,
    Flag = "BoxESP",
    Callback = function(val) _G.BoxESP = val end,
})

-- ==== TAB SERVER ====
local ServerTab = Window:CreateTab("🔧 Server", 6004287365)
-- Rejoin
ServerTab:CreateButton({ Name = "🔄 Rejoin", Callback = function()
    local TS = game:GetService("TeleportService")
    TS:Teleport(game.PlaceId, game.Players.LocalPlayer)
end })

-- Server Hop
ServerTab:CreateButton({ Name = "🌐 Server Hop", Callback = function()
    local HttpService = game:GetService("HttpService")
    local TS = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local servers = HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId))).data
    local currentId = game.JobId
    for _,s in ipairs(servers) do
        if s.id~=currentId and s.playing<s.maxPlayers then
            TS:TeleportToPlaceInstance(placeId, s.id, game.Players.LocalPlayer)
            return
        end
    end
end })

-- Anti AFK
ServerTab:CreateToggle({ Name = "🚫 Anti AFK", CurrentValue = false, Callback = function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
end })

-- Anti Kick/Ban fallback
ServerTab:CreateToggle({ Name = "🛡️ Anti Kick", CurrentValue = false, Callback = function(state)
    if state then
        local plr = game.Players.LocalPlayer
        plr.Kicked:Connect(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
        end)
    end
end })

-- Phần Movement
MainTab:CreateSection("Movement")
-- WalkSpeed Slider
local walkSlider = MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 300},
    Increment = 1,
    CurrentValue = SavedSpeed,
    Flag = "WalkSpeed",
    Callback = function(Value)
        SavedSpeed = Value
    end
})
-- JumpPower Slider
local jumpSlider = MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = SavedJump,
    Flag = "JumpPower",
    Callback = function(Value)
        SavedJump = Value
    end
})
-- Phần Combat
MainTab:CreateSection("Combat")
-- Hitbox Toggle
local hitboxToggleUI = MainTab:CreateToggle({
    Name = "⭐Hitbox",
    CurrentValue = _G.Disabled,
    Flag = "HitboxToggle",
    Callback = function(Value)
        _G.Disabled = Value
        if not Value then
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
    end
})
-- ESP Toggle
local espToggleUI = MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = _G.ESPEnabled,
    Flag = "💯ESPToggle",
    Callback = function(Value)
        _G.ESPEnabled = Value
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                local esp = p.Character.Head:FindFirstChild("KOIHXZ_ESP")
                if esp then
                    esp.Enabled = Value
                end
            end
        end
    end
})

-- Click TP Toggle
local teleportEnabled = false
MainTab:CreateToggle({
    Name = "🛰️ Click TP",
    CurrentValue = teleportEnabled,
    Flag = "ClickTP",
    Callback = function(Value)
        teleportEnabled = Value
    end
})

-- TP (Click/Touch) handling
local mouse = player:GetMouse()
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not teleportEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = mouse.Hit and mouse.Hit.Position
        if pos then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
            end
        end
    end
end)
UIS.TouchTap:Connect(function(_, gameProcessed)
    if gameProcessed or not teleportEnabled then return end
    local pos = mouse.Hit and mouse.Hit.Position
    if pos then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
        end
    end
end)