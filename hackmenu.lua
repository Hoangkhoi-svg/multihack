-- KOIHXZ HUB - ĐÃ UPDATE THEO YÊU CẦU
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

-- Load Rayfield UI
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

-- Tab Main
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

-- Thêm toggle Infinite Jump vào đây
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

-- Click TP handling
local mouse = player:GetMouse()
UIS.InputBegan:Connect(function(input, gameProcessed)
    pcall(function()
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
end)
UIS.TouchTap:Connect(function(touchPositions, gameProcessed)
    pcall(function()
        if gameProcessed or not teleportEnabled then return end
        local pos = mouse.Hit and mouse.Hit.Position
        if pos then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
            end
        end
    end)
end)

-- TAB COMBAT (CHỈNH SỬA TOÀN BỘ THEO YÊU CẦU)
local CombatTab = Window:CreateTab("⚔️ Combat", 6023426912)

-- Kill Aura
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
                                -- NOTE: Thay thế hàm dưới đây bằng hàm đánh của game bạn (nếu có)
                                -- Ví dụ: game.ReplicatedStorage.MeleeEvent:FireServer(v.Character.Humanoid)
                            end
                        end
                    end
                    wait(0.2)
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

-- Invisibility
local invis = false
CombatTab:CreateToggle({
    Name = "👻 Invisibility",
    CurrentValue = invis,
    Flag = "Invisibility",
    Callback = function(val)
        invis = val
        local char = player.Character
        if char then
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.Transparency = val and 1 or 0
                end
            end
        end
    end
})

-- No Knockback
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
                char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
            else
                char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.7,0.3,0.5)
            end
        end
    end
})

-- Instant Respawn
local instantRespawn = false
CombatTab:CreateToggle({
    Name = "⚡ Instant Respawn",
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

-- TAB PLAYER (SỬA FLY MODE THEO SOURCE MỚI)
local PlayerTab = Window:CreateTab("🕹️ Player", 6026568198)
local flyEnabled = false
local flyConn, flyGyro, flyVel
local upPressed, downPressed = false, false

-- MOBILE BUTTONS
local function createMobileFlyButtons()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FlyButtons"
    gui.Parent = game.Players.LocalPlayer.PlayerGui
    gui.ResetOnSpawn = false

    local upBtn = Instance.new("TextButton")
    upBtn.Name = "FlyUp"
    upBtn.Size = UDim2.new(0, 60, 0, 60)
    upBtn.Position = UDim2.new(1, -75, 0.7, 0)
    upBtn.Text = "↑"
    upBtn.TextSize = 40
    upBtn.BackgroundTransparency = 0.4
    upBtn.BackgroundColor3 = Color3.fromRGB(90,200,255)
    upBtn.Parent = gui

    local downBtn = Instance.new("TextButton")
    downBtn.Name = "FlyDown"
    downBtn.Size = UDim2.new(0, 60, 0, 60)
    downBtn.Position = UDim2.new(1, -75, 0.7, 70)
    downBtn.Text = "↓"
    downBtn.TextSize = 40
    downBtn.BackgroundTransparency = 0.4
    downBtn.BackgroundColor3 = Color3.fromRGB(90,200,255)
    downBtn.Parent = gui

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
    flyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)
    flyGyro.cframe = root.CFrame

    flyVel = Instance.new("BodyVelocity", root)
    flyVel.velocity = Vector3.new(0,0.1,0)
    flyVel.maxForce = Vector3.new(9e9,9e9,9e9)

    -- Tạo nút mobile nếu là mobile
    if UIS.TouchEnabled then
        flyBtnGui = createMobileFlyButtons()
    end

    flyConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()

        -- PC: Phím W/A/S/D di chuyển ngang, Space lên, Shift xuống
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec + Vector3.new(0,-1,0) end

        -- MOBILE: Joystick + nút bay lên/xuống
        if hum.MoveDirection.Magnitude > 0 then
            moveVec = Vector3.new(hum.MoveDirection.X, moveVec.Y, hum.MoveDirection.Z)
        end
        if upPressed then moveVec = moveVec + Vector3.new(0,1,0) end
        if downPressed then moveVec = moveVec + Vector3.new(0,-1,0) end

        -- Tăng tốc bay (FlySpeed)
        if moveVec.Magnitude > 0 then
            flyVel.Velocity = moveVec.Unit * FlySpeed * 5
        else
            flyVel.Velocity = Vector3.new(0,0.1,0)
        end
        flyGyro.CFrame = cam.CFrame
    end)
end

function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
    if flyVel then flyVel:Destroy() flyVel = nil end
    if flyBtnGui then flyBtnGui:Destroy() flyBtnGui = nil end
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
        if val then startFly() else stopFly() end
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

-- Tab Visual
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

-- Tab Server
local ServerTab = Window:CreateTab("🔧 Server", 6004287365)
ServerTab:CreateButton({
    Name = "🔄 Rejoin",
    Callback = function()
        local TS = game:GetService("TeleportService")
        TS:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})
ServerTab:CreateButton({
    Name = "🌐 Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TS = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local servers = HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId))).data
        local currentId = game.JobId
        for _, s in ipairs(servers) do
            if s.id ~= currentId and s.playing < s.maxPlayers then
                TS:TeleportToPlaceInstance(placeId, s.id, game.Players.LocalPlayer)
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
            game.Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})
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

-- Cập nhật danh sách người chơi cho Dropdown
local function updatePlayers()
    local options = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(options, p.Name)
        end
    end
    if #options == 0 then
        options = {"No players available"}
    end
    ServerTab.TeleportToPlayer:SetOptions(options)
end
game.Players.PlayerAdded:Connect(updatePlayers)
game.Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

--// jump inffi 

local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
UIS.JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled then
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
