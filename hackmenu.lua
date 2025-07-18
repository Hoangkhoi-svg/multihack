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

-- Tạo các tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- ==== TAB COMBAT ====
local CombatTab = Window:CreateTab("⚔️ Combat", 6023426912)

-- Aimbot Toggle
CombatTab:CreateToggle({
    Name = "🎯 Aimbot",
    CurrentValue = _G.AimbotEnabled or false,
    Flag = "Aimbot",
    Callback = function(val)
        _G.AimbotEnabled = val
        -- Logic aimbot sẽ cần thêm raycasting và xử lý camera, đây là placeholder
        if val then
            StarterGui:SetCore("SendNotification", {Title = "Aimbot", Text = "Aimbot đã bật!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Aimbot", Text = "Aimbot đã tắt!", Duration = 3})
        end
    end,
})

-- Triggerbot Toggle
CombatTab:CreateToggle({
    Name = "🔫 Triggerbot",
    CurrentValue = _G.TriggerbotEnabled or false,
    Flag = "Triggerbot",
    Callback = function(val)
        _G.TriggerbotEnabled = val
        -- Logic triggerbot cần thêm kiểm tra raycast đến đối thủ
        if val then
            StarterGui:SetCore("SendNotification", {Title = "Triggerbot", Text = "Triggerbot đã bật!", Duration = 3})
isuus
        else
            StarterGui:SetCore("SendNotification", {Title = "Triggerbot", Text = "Triggerbot đã tắt!", Duration = 3})
        end
    end,
})

-- Damage Multiplier Slider
CombatTab:CreateSlider({
    Name = "💥 Damage Multiplier",
    Range = {1, 10},
    Increment = 0.5,
    CurrentValue = _G.DamageMultiplier or 1,
    Flag = "DamageMultiplier",
    Callback = function(val)
        _G.DamageMultiplier = val
        StarterGui:SetCore("SendNotification", {Title = "Damage Multiplier", Text = "Hệ số sát thương: " .. val, Duration = 3})
    end,
})

-- Auto-heal Toggle
CombatTab:CreateToggle({
    Name = "❤️ Auto-heal",
    CurrentValue = _G.AutoHealEnabled or false,
    Flag = "AutoHeal",
    Callback = function(val)
        _G.AutoHealEnabled = val
        if val then
            spawn(function()
                while _G.AutoHealEnabled do
                    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health < hum.MaxHealth * 0.5 then
                        hum.Health = hum.MaxHealth
                        StarterGui:SetCore("SendNotification", {Title = "Auto-heal", Text = "Đã hồi máu!", Duration = 2})
                    end
                    wait(1)
                end
            end)
        end
    end,
})

-- Stun on Hit Toggle
CombatTab:CreateToggle({
    Name = "⚡ Stun on Hit",
    CurrentValue = _G.StunOnHitEnabled or false,
    Flag = "StunOnHit",
    Callback = function(val)
        _G.StunOnHitEnabled = val
        -- Logic stun cần thêm xử lý sự kiện tấn công
        if val then
            StarterGui:SetCore("SendNotification", {Title = "Stun on Hit", Text = "Làm choáng đã bật!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Stun on Hit", Text = "Làm choáng đã tắt!", Duration = 3})
        end
    end,
})

-- Stun Duration Slider
CombatTab:CreateSlider({
    Name = "⏱️ Stun Duration",
    Range = {1, 10},
    Increment = 0.5,
    CurrentValue = _G.StunDuration or 2,
    Flag = "StunDuration",
    Callback = function(val)
        _G.StunDuration = val
        StarterGui:SetCore("SendNotification", {Title = "Stun Duration", Text = "Thời gian làm choáng: " .. val .. " giây", Duration = 3})
    end,
})

-- ==== TAB PLAYER ====
local PlayerTab = Window:CreateTab("🕹️ Player", 6026568198)

-- Invisibility Toggle
PlayerTab:CreateToggle({
    Name = "👻 Invisibility",
    CurrentValue = _G.InvisibilityEnabled or false,
    Flag = "Invisibility",
    Callback = function(val)
        _G.InvisibilityEnabled = val
        if val then
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.Transparency = 1
                    end
                end
                StarterGui:SetCore("SendNotification", {Title = "Invisibility", Text = "Đã vô hình!", Duration = 3})
            end
        else
            local char = player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.Transparency = 0
                    end
                end
                StarterGui:SetCore("SendNotification", {Title = "Invisibility", Text = "Hết vô hình!", Duration = 3})
            end
        end
    end,
})

-- No Clip Toggle
PlayerTab:CreateToggle({
    Name = "🚪 No Clip",
    CurrentValue = _G.NoClipEnabled or false,
    Flag = "NoClip",
    Callback = function(val)
        _G.NoClipEnabled = val
        if val then
            RunService.Stepped:Connect(function()
                if _G.NoClipEnabled and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            StarterGui:SetCore("SendNotification", {Title = "No Clip", Text = "Đi xuyên tường đã bật!", Duration = 3})
        else
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
                StarterGui:SetCore("SendNotification", {Title = "No Clip", Text = "Đi xuyên tường đã tắt!", Duration = 3})
            end
        end
    end,
})

-- Teleport to Player Button
PlayerTab:CreateButton({
    Name = "🧑‍🚀 Teleport to Player",
    Callback = function()
        local players = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                table.insert(players, p.Name)
            end
        end
        Rayfield:Prompt({
            Title = "Chọn người chơi",
            Content = "Chọn người chơi để teleport tới",
            Options = players,
            Callback = function(selected)
                local target = Players:FindFirstChild(selected)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = target.Character.HumanoidRootPart.CFrame
                        StarterGui:SetCore("SendNotification", {Title = "Teleport", Text = "Đã teleport tới " .. selected, Duration = 3})
                    end
                end
            end,
        })
    end,
})

-- Bring Player to Me Button
PlayerTab:CreateButton({
    Name = "📍 Bring Player to Me",
    Callback = function()
        local players = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                table.insert(players, p.Name)
            end
        end
        Rayfield:Prompt({
            Title = "Chọn người chơi",
            Content = "Chọn người chơi để kéo tới bạn",
            Options = players,
            Callback = function(selected)
                local target = Players:FindFirstChild(selected)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        target.Character.HumanoidRootPart.CFrame = hrp.CFrame
                        StarterGui:SetCore("SendNotification", {Title = "Bring Player", Text = "Đã kéo " .. selected .. " tới bạn", Duration = 3})
                    end
                end
            end,
        })
    end,
})

-- Speed Boost Toggle
PlayerTab:CreateToggle({
    Name = "⚡ Speed Boost",
    CurrentValue = _G.SpeedBoostEnabled or false,
    Flag = "SpeedBoost",
    Callback = function(val)
        _G.SpeedBoostEnabled = val
        if val then
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = hum.WalkSpeed * 2
                StarterGui:SetCore("SendNotification", {Title = "Speed Boost", Text = "Tăng tốc độ x2!", Duration = 3})
            end
        else
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = SavedSpeed
                StarterGui:SetCore("SendNotification", {Title = "Speed Boost", Text = "Tốc độ trở lại bình thường!", Duration = 3})
            end
        end
    end,
})

-- ==== TAB VISUAL ====
local VisualTab = Window:CreateTab("🎨 Visual", 6034567821)

-- Chams Toggle
VisualTab:CreateToggle({
    Name = "🌟 Chams",
    CurrentValue = _G.ChamsEnabled or false,
    Flag = "Chams",
    Callback = function(val)
        _G.ChamsEnabled = val
        if val then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            local highlight = Instance.new("Highlight", part)
                            highlight.FillColor = _G.ChamsColor or Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                        end
                    end
                end
            end
            StarterGui:SetCore("SendNotification", {Title = "Chams", Text = "Chams đã bật!", Duration = 3})
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            local highlight = part:FindFirstChildOfClass("Highlight")
                            if highlight then highlight:Destroy() end
                        end
                    end
                end
            end
            StarterGui:SetCore("SendNotification", {Title = "Chams", Text = "Chams đã tắt!", Duration = 3})
        end
    end,
})

-- Tracers Toggle
VisualTab:CreateToggle({
    Name = "➡️ Tracers",
    CurrentValue = _G.TracersEnabled or false,
    Flag = "Tracers",
    Callback = function(val)
        _G.TracersEnabled = val
        if val then
            spawn(function()
                while _G.TracersEnabled do
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local line = Drawing.new("Line")
                            line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                            line.To = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                            line.Color = _G.ChamsColor or Color3.fromRGB(255, 0, 0)
                            line.Thickness = 2
                            line.Transparency = 1
                            game:GetService("RunService").RenderStepped:Wait()
                            line:Remove()
                        end
                    end
                end
            end)
            StarterGui:SetCore("SendNotification", {Title = "Tracers", Text = "Tracers đã bật!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Tracers", Text = "Tracers đã tắt!", Duration = 3})
        end
    end,
})

-- Chams Color Picker
VisualTab:CreateColorPicker({
    Name = "🎨 Chams Color",
    Color = _G.ChamsColor or Color3.fromRGB(255, 0, 0),
    Flag = "ChamsColor",
    Callback = function(val)
        _G.ChamsColor = val
        if _G.ChamsEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            local highlight = part:FindFirstChildOfClass("Highlight")
                            if highlight then highlight.FillColor = val end
                        end
                    end
                end
            end
            StarterGui:SetCore("SendNotification", {Title = "Chams Color", Text = "Đã thay đổi màu chams!", Duration = 3})
        end
    end,
})

-- FOV Circle Slider
VisualTab:CreateSlider({
    Name = "🔲 FOV Circle",
    Range = {50, 200},
    Increment = 5,
    CurrentValue = _G.FOVCircle or 100,
    Flag = "FOVCircle",
    Callback = function(val)
        _G.FOVCircle = val
        local circle = Drawing.new("Circle")
        circle.Radius = val
        circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        circle.Color = Color3.fromRGB(255, 255, 255)
        circle.Thickness = 1
        circle.Transparency = 0.5
        circle.Visible = true
        game:GetService("RunService").RenderStepped:Wait()
        circle:Remove()
        StarterGui:SetCore("SendNotification", {Title = "FOV Circle", Text = "Kích thước FOV: " .. val, Duration = 3})
    end,
})

-- Crosshair Toggle
VisualTab:CreateToggle({
    Name = "🎯 Crosshair",
    CurrentValue = _G.CrosshairEnabled or false,
    Flag = "Crosshair",
    Callback = function(val)
        _G.CrosshairEnabled = val
        if val then
            local crosshair = Drawing.new("Line")
            crosshair.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2 - 10, workspace.CurrentCamera.ViewportSize.Y / 2)
            crosshair.To = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2 + 10, workspace.CurrentCamera.ViewportSize.Y / 2)
            crosshair.Color = Color3.fromRGB(255, 255, 255)
            crosshair.Thickness = 2
            crosshair.Transparency = 1
            crosshair.Visible = true
            local crosshair2 = Drawing.new("Line")
            crosshair2.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2 - 10)
            crosshair2.To = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2 + 10)
            crosshair2.Color = Color3.fromRGB(255, 255, 255)
            crosshair2.Thickness = 2
            crosshair2.Transparency = 1
            crosshair2.Visible = true
            StarterGui:SetCore("SendNotification", {Title = "Crosshair", Text = "Crosshair đã bật!", Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Crosshair", Text = "Crosshair đã tắt!", Dur