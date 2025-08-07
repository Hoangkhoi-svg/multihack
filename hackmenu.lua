-- KOIHXZ HUB - BẢN FIX CHỨC NĂNG
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

local FlySpeed = 2 -- Default fly speed, dùng cho slider

-- Chat System Message - FIXED
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

-- Hitbox và giữ tốc độ/jump - FIXED
local function updateHitbox(v)
    if v == player then return end
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

RunService.RenderStepped:Connect(function()
    if _G.Disabled then
        for _, v in ipairs(Players:GetPlayers()) do
            updateHitbox(v)
        end
    end
    
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = SavedSpeed
        hum.JumpPower = SavedJump
    end
end)

-- FIXED: Gắn hitbox cho người mới
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
        if _G.Disabled then
            updateHitbox(p)
        end
    end)
end)

-- ESP Tên - FIXED
local function createESP(p)
    if p == player then return end
    
    local function attachESP(char)
        local head = char:FindFirstChild("Head")
        if head then
            -- Xóa ESP cũ nếu có
            local existingESP = head:FindFirstChild("KOIHXZ_ESP")
            if existingESP then existingESP:Destroy() end
            
            local b = Instance.new("BillboardGui")
            b.Name = "KOIHXZ_ESP"
            b.Size = UDim2.new(0,60,0,20)
            b.Adornee = head
            b.AlwaysOnTop = true
            b.Enabled = _G.ESPEnabled
            b.Parent = head
            
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1,0,1,0)
            t.BackgroundTransparency = 1
            t.Text = p.Name
            t.TextColor3 = Color3.new(1,1,1)
            t.TextStrokeTransparency = 0
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

-- Load Rayfield UI - GIỮ NGUYÊN
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua", true))()

-- Tạo cửa sổ chính - GIỮ NGUYÊN
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

-- Tab Main - GIỮ NGUYÊN
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Teleport")
local teleportEnabled = false
MainTab:CreateToggle({
    Name = "🛰️ Click TP",
    CurrentValue = teleportEnabled,
    Flag = "ClickTP",
    Callback = function(Value)
        teleportEnabled = Value
    end
})

-- Thêm toggle Infinite Jump - FIXED
local infiniteJumpEnabled = false
MainTab:CreateToggle({
    Name = "🦘 Infinite Jump",
    CurrentValue = infiniteJumpEnabled,
    Flag = "InfiniteJump",
    Callback = function(Value)
        infiniteJumpEnabled = Value
        _G.InfiniteJumpEnabled = Value
    end
})

-- Click TP handling - FIXED FOR MOBILE
local mouse = player:GetMouse()
local function teleportTo(position)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position + Vector3.new(0,3,0))
    end
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not teleportEnabled then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local ray = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, game.Workspace.CurrentCamera.CFrame.LookVector * 1000)
        local part, position = game.Workspace:FindPartOnRay(ray, player.Character)
        if position then
            teleportTo(position)
        end
    end
end)

UIS.TouchTap:Connect(function(touchPositions, gameProcessed)
    if gameProcessed or not teleportEnabled then return end
    
    local touchPosition = touchPositions[1]
    local ray = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (game.Workspace.CurrentCamera:ViewportPointToRay(touchPosition.X, touchPosition.Y).Direction * 1000))
    local part, position = game.Workspace:FindPartOnRay(ray, player.Character)
    if position then
        teleportTo(position)
    end
end)

-- TAB COMBAT - FIXED CHỨC NĂNG
local CombatTab = Window:CreateTab("⚔️ Combat", 6023426912)

-- Kill Aura - FIXED
local auraEnabled = false
local auraRange = 15
CombatTab:CreateToggle({
    Name = "👊 Kill Aura",
    CurrentValue = auraEnabled,
    Flag = "KillAura",
    Callback = function(val)
        auraEnabled = val
        if val then
            spawn(function()
                while auraEnabled do
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local target = v.Character.HumanoidRootPart
                            local plrHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if plrHrp and (target.Position - plrHrp.Position).Magnitude <= auraRange then
                                -- Simulate attack
                                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end,
})
CombatTab:CreateSlider({
    Name = "⚡ Kill Aura Range",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = auraRange,
    Flag = "AuraRange",
    Callback = function(val) auraRange = val end
})

-- Invisibility - FIXED
local invis = false
CombatTab:CreateToggle({
    Name = "👻 Invisibility",
    CurrentValue = invis,
    Flag = "Invisibility",
    Callback = function(val)
        invis = val
        local char = player.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = val and 1 or 0
                end
            end
        end
    end
})

-- No Knockback - FIXED
local knockback = false
CombatTab:CreateToggle({
    Name = "🛡️ No Knockback",
    CurrentValue = knockback,
    Flag = "NoKnockback",
    Callback = function(val)
        knockback = val
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if val then
                char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(math.huge, math.huge, math.huge)
            else
                char.HumanoidRootPart.CustomPhysicalProperties = nil
            end
        end
    end
})

-- Instant Respawn - FIXED
local instantRespawn = false
CombatTab:CreateToggle({
    Name = "⚡ Instant Respawn",
    CurrentValue = instantRespawn,
    Flag = "InstantRespawn",
    Callback = function(val)
        instantRespawn = val
    end
)

-- Kết nối sự kiện respawn
player.CharacterAdded:Connect(function(char)
    if instantRespawn then
        local hum = char:WaitForChild("Humanoid")
        hum.Health = 0
        task.wait(0.1)
        hum.Health = hum.MaxHealth
    end
end)

-- TAB PLAYER - FIXED FLY MODE
local PlayerTab = Window:CreateTab("🕹️ Player", 6026568198)
local flyEnabled = false
local flyConn, flyGyro, flyVel
local upPressed, downPressed = false, false

-- FIXED: Fly mode hoạt động trên mobile
local function startFly()
    local char = player.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return end

    hum.PlatformStand = true
    
    -- Tạo các bộ điều khiển vật lý
    flyGyro = Instance.new("BodyGyro")
    flyGyro.P = 9e4
    flyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)
    flyGyro.cframe = root.CFrame
    flyGyro.Parent = root

    flyVel = Instance.new("BodyVelocity")
    flyVel.velocity = Vector3.new(0,0.1,0)
    flyVel.maxForce = Vector3.new(9e9,9e9,9e9)
    flyVel.Parent = root

    flyConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()

        -- PC Controls
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec + Vector3.new(0,-1,0) end

        -- Mobile Controls
        if upPressed then moveVec = moveVec + Vector3.new(0,1,0) end
        if downPressed then moveVec = moveVec + Vector3.new(0,-1,0) end

        -- Apply movement
        if moveVec.Magnitude > 0 then
            flyVel.Velocity = moveVec.Unit * FlySpeed * 50
        else
            flyVel.Velocity = Vector3.new(0,0.1,0)
        end
        
        -- Update orientation
        flyGyro.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
    if flyVel then flyVel:Destroy() flyVel = nil end
    upPressed = false; downPressed = false
    
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = false
    end
end

PlayerTab:CreateToggle({
    Name = "🪂 Fly Mode",
    CurrentValue = flyEnabled,
    Flag = "FlyMode",
    Callback = function(val)
        flyEnabled = val
        if val then 
            startFly() 
        else 
            stopFly() 
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "✈️ Fly Speed",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = FlySpeed,
    Flag = "FlySpeed",
    Callback = function(val)
        FlySpeed = val
    end
})

PlayerTab:CreateSlider({
    Name = "🚶 WalkSpeed",
    Range = {0, 300},
    Increment = 1,
    CurrentValue = SavedSpeed,
    Flag = "WalkSpeed",
    Callback = function(Value)
        SavedSpeed = Value
    end
})
PlayerTab:CreateSlider({
    Name = "🏃 JumpPower",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = SavedJump,
    Flag = "JumpPower",
    Callback = function(Value)
        SavedJump = Value
    end
})

-- Tab Visual - FIXED ESP TOGGLE
local VisualTab = Window:CreateTab("🎨 Visual", 6034567821)
VisualTab:CreateToggle({
    Name = "🧊 Box ESP",
    CurrentValue = _G.BoxESP or false,
    Flag = "BoxESP",
    Callback = function(val) _G.BoxESP = val end,
})
VisualTab:CreateToggle({
    Name = "💯 ESP",
    CurrentValue = _G.ESPEnabled,
    Flag = "ESPToggle",
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
VisualTab:CreateSlider({
    Name = "🌞 Brightness",
    Range = {0, 2},
    Increment = 0.1,
    CurrentValue = game.Lighting.Brightness,
    Flag = "Brightness",
    Callback = function(Value)
        game.Lighting.Brightness = Value
    end,
})

-- Tab Server - FIXED SERVER HOP
local ServerTab = Window:CreateTab("🔧 Server", 6004287365)
ServerTab:CreateButton({
    Name = "🔄 Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})
ServerTab:CreateButton({
    Name = "🌐 Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TS = game:GetService("TeleportService")
        local placeId = game.PlaceId
        
        local servers = {}
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)
        
        if success and result and result.data then
            servers = result.data
        end
        
        local currentId = game.JobId
        for _, s in ipairs(servers) do
            if s.id ~= currentId and s.playing < s.maxPlayers then
                TS:TeleportToPlaceInstance(placeId, s.id, player)
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
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

-- FIXED: Cập nhật danh sách người chơi cho Dropdown
local function updatePlayers()
    local options = {"Select a player"}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(options, p.Name)
        end
    end
    
    -- Cập nhật dropdown nếu đã được tạo
    if ServerTab and ServerTab.TeleportToPlayer then
        ServerTab.TeleportToPlayer:SetOptions(options)
    end
end

-- Tạo dropdown lần đầu
ServerTab:CreateDropdown({
    Name = "🚪 Teleport To Player",
    Options = {"Select a player"},
    CurrentOption = "Select a player",
    Flag = "TeleportToPlayer",
    Callback = function(Value)
        if Value ~= "Select a player" then
            local targetPlayer = game.Players:FindFirstChild(Value)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local plrHrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if plrHrp then
                    plrHrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end,
})

-- Cập nhật danh sách người chơi
game.Players.PlayerAdded:Connect(updatePlayers)
game.Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

-- FIXED: Infinite Jump
UIS.JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)