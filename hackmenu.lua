-- KOIHXZ HUB - ĐÃ CHỈNH SỬA THEO YÊU CẦU
_G.HITBOXEnabled = true
_G.ESPEnabled = true
_G.HeadSize = 50
local SavedSpeed, SavedJump = 16, 50
local FlySpeed = 2

-- Dịch vụ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TS = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- Thông báo hệ thống
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

-- Thông báo tải
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

-- HITBOX
RunService.RenderStepped:Connect(function()
    if _G.HITBOXEnabled then
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

-- HITBOX cho người chơi mới
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        repeat wait() until p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        wait(1)
        if _G.HITBOXEnabled then
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

-- ESP
function attachESP(char, name)
    local head = char:FindFirstChild("Head")
    if head and not head:FindFirstChild("KOIHXZ_ESP") then
        local b = Instance.new("BillboardGui", head)
        b.Name = "KOIHXZ_ESP"
        b.Size = UDim2.new(0, 60, 0, 20)
        b.Adornee = head
        b.AlwaysOnTop = true
        b.Enabled = _G.ESPEnabled
        local t = Instance.new("TextLabel", b)
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.Text = name
        t.TextColor3 = Color3.new(1, 1, 1)
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

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua", true))()
local Window = Rayfield:CreateWindow({
    Name = "KOIHXZ HUB",
    LoadingTitle = "KOIHXZ HUB UI",
    LoadingSubtitle = "By KoiHxz",
    ConfigurationSaving = { Enabled = false }
})

-- Tab Visuals
local VisualTab = Window:CreateTab("🎨 Visuals", 6034567821)
VisualTab:CreateToggle({
    Name = "💯 ESP",
    CurrentValue = _G.ESPEnabled,
    Flag = "ESPToggle",
    Callback = function(Value)
        _G.ESPEnabled = Value
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                local esp = p.Character.Head:FindFirstChild("KOIHXZ_ESP")
                if esp then esp.Enabled = Value end
            end
        end
    end
})
VisualTab:CreateToggle({
    Name = "🧊 HITBOX",
    CurrentValue = _G.HITBOXEnabled,
    Flag = "HITBOXToggle",
    Callback = function(Value) _G.HITBOXEnabled = Value end
})
VisualTab:CreateSlider({
    Name = "📏 HITBOX Size",
    Range = {10, 100},
    Increment = 1,
    CurrentValue = _G.HeadSize,
    Flag = "HeadSize",
    Callback = function(Value) _G.HeadSize = Value end
})

-- Tab Movement
local PlayerTab = Window:CreateTab("🕹️ Movement", 6026568198)
local flyEnabled, flyConn, flyGyro, flyVel, upPressed, downPressed = false, nil, nil, nil, false, false

local function createMobileFlyButtons()
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "FlyButtons"
    gui.ResetOnSpawn = false
    local upBtn = Instance.new("TextButton", gui)
    upBtn.Name = "FlyUp"
    upBtn.Size = UDim2.new(0, 60, 0, 60)
    upBtn.Position = UDim2.new(1, -75, 0.7, 0)
    upBtn.Text = "↑"
    upBtn.TextSize = 40
    upBtn.BackgroundTransparency = 0.4
    upBtn.BackgroundColor3 = Color3.fromRGB(90, 200, 255)
    local downBtn = Instance.new("TextButton", gui)
    downBtn.Name = "FlyDown"
    downBtn.Size = UDim2.new(0, 60, 0, 60)
    downBtn.Position = UDim2.new(1, -75, 0.7, 70)
    downBtn.Text = "↓"
    downBtn.TextSize = 40
    downBtn.BackgroundTransparency = 0.4
    downBtn.BackgroundColor3 = Color3.fromRGB(90, 200, 255)
    upBtn.MouseButton1Down:Connect(function() upPressed = true end)
    upBtn.MouseButton1Up:Connect(function() upPressed = false end)
    downBtn.MouseButton1Down:Connect(function() downPressed = true end)
    downBtn.MouseButton1Up:Connect(function() downPressed = false end)
    return gui
end

local flyBtnGui = nil

function startFly()
    local char = player.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return end
    hum.PlatformStand = true
    flyGyro = Instance.new("BodyGyro", root)
    flyGyro.P = 9e4
    flyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.cframe = root.CFrame
    flyVel = Instance.new("BodyVelocity", root)
    flyVel.velocity = Vector3.new(0, 0.1, 0)
    flyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)
    if UIS.TouchEnabled then flyBtnGui = createMobileFlyButtons() end
    flyConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec + Vector3.new(0, -1, 0) end
        if hum.MoveDirection.Magnitude > 0 then moveVec = Vector3.new(hum.MoveDirection.X, moveVec.Y, hum.MoveDirection.Z) end
        if upPressed then moveVec = moveVec + Vector3.new(0, 1, 0) end
        if downPressed then moveVec = moveVec + Vector3.new(0, -1, 0) end
        if moveVec.Magnitude > 0 then
            flyVel.Velocity = moveVec.Unit * FlySpeed * 5
        else
            flyVel.Velocity = Vector3.new(0, 0.1, 0)
        end
        flyGyro.CFrame = cam.CFrame
    end)
end

function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
    if flyVel then flyVel:Destroy() flyVel = nil end
    if flyBtnGui then flyBtnGui:Destroy() flyBtnGui = nil end
    upPressed = false
    downPressed = false
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = false
    end
end

PlayerTab:CreateSlider({
    Name = "🚶 WalkSpeed",
    Range = {0, 300},
    Increment = 1,
    CurrentValue = SavedSpeed,
    Flag = "WalkSpeed",
    Callback = function(Value) SavedSpeed = Value end
})
PlayerTab:CreateSlider({
    Name = "🏃 JumpPower",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = SavedJump,
    Flag = "JumpPower",
    Callback = function(Value) SavedJump = Value end
})
PlayerTab:CreateToggle({
    Name = "🪂 Fly Mode",
    CurrentValue = flyEnabled,
    Flag = "FlyMode",
    Callback = function(Value)
        flyEnabled = Value
        if Value then startFly() else stopFly() end
    end
})

-- Tab Combat
local CombatTab = Window:CreateTab("⚔️ Combat", 6023426912)
local auraEnabled, auraRange = false, 15
local knockback = false
local instantRespawn = false

CombatTab:CreateToggle({
    Name = "👊 Kill Aura",
    CurrentValue = auraEnabled,
    Flag = "KillAura",
    Callback = function(val)
        auraEnabled = val
        if val then
            spawn(function()
                while auraEnabled do
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local target = v.Character.HumanoidRootPart
                            local plrHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if plrHrp and (target.Position - plrHrp.Position).Magnitude <= auraRange then
                                -- Thay thế bằng hàm đánh của game nếu có
                                -- Ví dụ: game.ReplicatedStorage.MeleeEvent:FireServer(v.Character.Humanoid)
                            end
                        end
                    end
                    wait(0.2)
                end
            end)
        end
    end
})
CombatTab:CreateToggle({
    Name = "🛡️ No Knockback",
    CurrentValue = knockback,
    Flag = "NoKnockback",
    Callback = function(val)
        knockback = val
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if val then
                char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            else
                char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
            end
        end
    end
})
CombatTab:CreateToggle({
    Name = "⚡ Instant Respawn (Anti Kick)",
    CurrentValue = instantRespawn,
    Flag = "InstantRespawn",
    Callback = function(val)
        instantRespawn = val
        if val then
            player.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid")
                hum.Health = hum.MaxHealth
            end)
        end
    end
})

-- Tab Server
local ServerTab = Window:CreateTab("🔧 Server", 6004287365)
ServerTab:CreateButton({
    Name = "🔄 Rejoin",
    Callback = function()
        TS:Teleport(game.PlaceId, player)
    end
})
ServerTab:CreateButton({
    Name = "🌐 Server Hop",
    Callback = function()
        local servers = HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))).data
        local currentId = game.JobId
        for _, s in ipairs(servers) do
            if s.id ~= currentId and s.playing < s.maxPlayers then
                TS:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                return
            end
        end
    end
})
ServerTab:CreateToggle({
    Name = "🚫 Anti AFK",
    CurrentValue = false,
    Callback = function(state)
        if state then
            local vu = game:GetService("VirtualUser")
            player.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})