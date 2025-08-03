-- KOIHXZ HUB - Cập nhật với Orion UI
_G.HeadSize = 50
_G.Disabled = false -- Đổi tên để rõ ràng hơn, false nghĩa là hitbox tắt
_G.ESPEnabled = true
_G.BoxESP = false
_G.InfiniteJumpEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local FlySpeed = 2 -- Tốc độ bay mặc định
local auraEnabled = false
local auraRange = 15
local flyEnabled = false
local upPressed, downPressed = false, false
local flyConn, flyGyro, flyVel
local flyBtnGui = nil

-- Chat System Message
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

-- Hitbox và giữ tốc độ/nhảy
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
        hum.WalkSpeed = _G.SavedSpeed or 16
        hum.JumpPower = _G.SavedJump or 50
    end
end)

-- Hitbox cho người chơi mới
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

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled then
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

-- Fly Mode cho Mobile
local function createMobileFlyButtons()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlyButtons"
    gui.Parent = player.PlayerGui
    gui.ResetOnSpawn = false

    local upBtn = Instance.new("TextButton")
    upBtn.Name = "FlyUp"
    upBtn.Size = UDim2.new(0, 60, 0, 60)
    upBtn.Position = UDim2.new(1, -75, 0.7, 0)
    upBtn.Text = "↑"
    upBtn.TextSize = 40
    upBtn.BackgroundTransparency = 0.4
    upBtn.BackgroundColor3 = Color3.fromRGB(90, 200, 255)
    upBtn.Parent = gui

    local downBtn = Instance.new("TextButton")
    downBtn.Name = "FlyDown"
    downBtn.Size = UDim2.new(0, 60, 0, 60)
    downBtn.Position = UDim2.new(1, -75, 0.7, 70)
    downBtn.Text = "↓"
    downBtn.TextSize = 40
    downBtn.BackgroundTransparency = 0.4
    downBtn.BackgroundColor3 = Color3.fromRGB(90, 200, 255)
    downBtn.Parent = gui

    upBtn.MouseButton1Down:Connect(function() upPressed = true end)
    upBtn.MouseButton1Up:Connect(function() upPressed = false end)
    downBtn.MouseButton1Down:Connect(function() downPressed = true end)
    downBtn.MouseButton1Up:Connect(function() downPressed = false end)
    return gui
end

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

    if UIS.TouchEnabled then
        flyBtnGui = createMobileFlyButtons()
    end

    flyConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec + Vector3.new(0, -1, 0) end

        if hum.MoveDirection.Magnitude > 0 then
            moveVec = Vector3.new(hum.MoveDirection.X, moveVec.Y, hum.MoveDirection.Z)
        end
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

-- Load Orion UI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo cửa sổ chính
local Window = OrionLib:MakeWindow({
    Name = "KOIHXZ HUB",
    IntroText = "KOIHXZ HUB UI",
    IntroIcon = "rbxassetid://7489181066",
    HidePremium = true,
    SaveConfig = false
})

-- Tab Main
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483362458", PremiumOnly = false})
MainTab:AddSection({Name = "Movement & Hitbox"})

local teleportEnabled = false
MainTab:AddToggle({
    Name = "🛰️ Click TP",
    Default = false,
    Callback = function(Value)
        teleportEnabled = Value
    end
})

MainTab:AddToggle({
    Name = "🦘 Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.InfiniteJumpEnabled = Value
    end
})

MainTab:AddToggle({
    Name = "🔲 Expand Hitbox",
    Default = false,
    Callback = function(Value)
        _G.Disabled = Value
    end
})

-- Tab Player
local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://6026568198", PremiumOnly = false})
PlayerTab:AddSection({Name = "Movement"})

PlayerTab:AddToggle({
    Name = "🪂 Fly Mode",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if Value then startFly() else stopFly() end
    end
})

PlayerTab:AddSlider({
    Name = "✈️ Fly Speed",
    Min = 1,
    Max = 20,
    Default = FlySpeed,
    Increment = 1,
    Callback = function(Value)
        FlySpeed = Value
    end
})

PlayerTab:AddSlider({
    Name = "🚶 WalkSpeed",
    Min = 0,
    Max = 300,
    Default = _G.SavedSpeed or 16,
    Increment = 1,
    Callback = function(Value)
        _G.SavedSpeed = Value
    end
})

PlayerTab:AddSlider({
    Name = "🏃 JumpPower",
    Min = 0,
    Max = 200,
    Default = _G.SavedJump or 50,
    Increment = 1,
    Callback = function(Value)
        _G.SavedJump = Value
    end
})

-- Tab Combat
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://6023426912", PremiumOnly = false})
CombatTab:AddSection({Name = "Combat Features"})

CombatTab:AddToggle({
    Name = "👊 Kill Aura",
    Default = false,
    Callback = function(Value)
        auraEnabled = Value
        if Value then
            spawn(function()
                while auraEnabled do
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local target = v.Character.HumanoidRootPart
                            local plrHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if plrHrp and (target.Position - plrHrp.Position).Magnitude <= auraRange then
                                -- Thay bằng hàm tấn công của game nếu có
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

CombatTab:AddSlider({
    Name = "⚡ Kill Aura Range",
    Min = 5,
    Max = 50,
    Default = auraRange,
    Increment = 1,
    Callback = function(Value)
        auraRange = Value
    end
})

local knockback = false
CombatTab:AddToggle({
    Name = "🛡️ No Knockback",
    Default = false,
    Callback = function(Value)
        knockback = Value
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Value then
                char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            else
                char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
            end
        end
    end
})

local instantRespawn = false
CombatTab:AddToggle({
    Name = "⚡ Instant Respawn",
    Default = false,
    Callback = function(Value)
        instantRespawn = Value
        if Value then
            player.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid")
                hum.Health = hum.MaxHealth
            end)
        end
    end
})

-- Tab Utilities
local UtilitiesTab = Window:MakeTab({Name = "Utilities", Icon = "rbxassetid://6004287365", PremiumOnly = false})
UtilitiesTab:AddSection({Name = "Visual"})

UtilitiesTab:AddToggle({
    Name = "🧊 Box ESP",
    Default = _G.BoxESP,
    Callback = function(Value)
        _G.BoxESP = Value
        -- Cần thêm logic vẽ khung nếu muốn sử dụng
    end
})

UtilitiesTab:AddToggle({
    Name = "💯 Name ESP",
    Default = _G.ESPEnabled,
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

UtilitiesTab:AddSlider({
    Name = "🌞 Brightness",
    Min = 0,
    Max = 2,
    Default = game.Lighting.Brightness,
    Increment = 0.1,
    Callback = function(Value)
        game.Lighting.Brightness = Value
    end
})

UtilitiesTab:AddSection({Name = "Server"})

UtilitiesTab:AddButton({
    Name = "🔄 Rejoin",
    Callback = function()
        local TS = game:GetService("TeleportService")
        TS:Teleport(game.PlaceId, player)
    end
})

UtilitiesTab:AddButton({
    Name = "🌐 Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TS = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local servers = HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId))).data
        local currentId = game.JobId
        for _, s in ipairs(servers) do
            if s.id ~= currentId and s.playing < s.maxPlayers then
                TS:TeleportToPlaceInstance(placeId, s.id, player)
                return
            end
        end
    end
})

local antiAfkConnection = nil
UtilitiesTab:AddToggle({
    Name = "🚫 Anti AFK",
    Default = false,
    Callback = function(Value)
        if Value then
            if not antiAfkConnection then
                local vu = game:GetService("VirtualUser")
                antiAfkConnection = player.Idled:Connect(function()
                    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    wait(1)
                    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
            end
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end
})

-- Click TP
local mouse = player:GetMouse()
UIS.InputBegan:Connect(function(input, gameProcessed)
    pcall(function()
        if gameProcessed or not teleportEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = mouse.Hit and mouse.Hit.Position
            if pos then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                end
            end
        end
    end)
end)
UIS.TouchTap:Connect(function(touchPositions, gameProcessed)
    pcall(function()
        if gameProcessed or not teleportEnabled then return end
        local pos = mouse.Hit and mouse.Hit.Position
        if pos then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            end
        end
    end)
end)

-- Thông báo hoàn tất
OrionLib:MakeNotification({
    Name = "KOIHXZ HUB",
    Content = "Script loaded successfully! Enjoy!",
    Image = "rbxassetid://7489181066",
    Time = 5
})