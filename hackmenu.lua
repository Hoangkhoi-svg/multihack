-- KOIHXZ HUB - FINAL BY KoiHxz
_G.HeadSize = 50
_G.Disabled = true
local SavedSpeed, SavedJump = 16, 50
_G.FlyEnabled = false
_G.ESPEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local FlySpeed = 2 -- Default fly speed, chỉnh bằng slider

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

-- Hitbox & giữ tốc độ/jump
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

-----------------------------------------------------------------
-- TAB MAIN (nhiều chức năng mạnh)
-----------------------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Main Tools")

-- Click TP
local teleportEnabled = false
MainTab:CreateToggle({
    Name = "🛰️ Click TP",
    CurrentValue = teleportEnabled,
    Flag = "ClickTP",
    Callback = function(Value)
        teleportEnabled = Value
    end
})
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

-- Reset Character
MainTab:CreateButton({
    Name = "🔄 Reset Character",
    Callback = function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end
})

-- Unlock Camera Zoom
MainTab:CreateButton({
    Name = "🔭 Unlock Camera Zoom",
    Callback = function()
        player.CameraMaxZoomDistance = 999
        player.CameraMinZoomDistance = 0
        SafeChat("Max Zoom: 999, Min Zoom: 0 (đã mở khoá camera)")
    end
})

-- Infinite Jump
local infJump = false
MainTab:CreateToggle({
    Name = "🌙 Infinite Jump",
    CurrentValue = infJump,
    Callback = function(val)
        infJump = val
    end
})
UIS.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- TP to Spawn (nếu có SpawnLocation)
MainTab:CreateButton({
    Name = "🌀 TP To Spawn",
    Callback = function()
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("SpawnLocation") then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                    SafeChat("Đã TP tới vị trí spawn.")
                end
                return
            end
        end
        SafeChat("Không tìm thấy spawn location!")
    end
})

-- Walk on Water (tuỳ game, dựa trên nước là Terrain)
MainTab:CreateToggle({
    Name = "🌊 Walk On Water",
    CurrentValue = false,
    Callback = function(v)
        if v then
            for _, part in pairs(workspace:GetDescendants()) do
                if part.Name:lower():find("water") and part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            SafeChat("Đã bật Walk on Water (nếu map hỗ trợ)")
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part.Name:lower():find("water") and part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            SafeChat("Đã tắt Walk on Water")
        end
    end
})

-----------------------------------------------------------------
-- TAB COMBAT (Fling + ForceField)
-----------------------------------------------------------------
local CombatTab = Window:CreateTab("⚔️ Combat", 6023426912)

-- Fling (đụng văng người khác)
local flingActive = false
local flingConn
CombatTab:CreateToggle({
    Name = "💥 Fling",
    CurrentValue = flingActive,
    Callback = function(val)
        flingActive = val
        if flingConn then flingConn:Disconnect() flingConn = nil end
        if val then
            flingConn = RunService.Stepped:Connect(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                for _,v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local target = v.Character.HumanoidRootPart
                        if (hrp.Position - target.Position).magnitude < 5 then
                            target.Velocity = Vector3.new(math.random(-200,200),math.random(150,300),math.random(-200,200))
                        end
                    end
                end
            end)
        end
    end
})

-- Force Field
local ffObj = nil
CombatTab:CreateToggle({
    Name = "🛡️ Force Field",
    CurrentValue = false,
    Callback = function(val)
        if val then
            ffObj = Instance.new("ForceField", player.Character)
        else
            if ffObj then ffObj:Destroy() ffObj = nil end
        end
    end
})

-----------------------------------------------------------------
-- TAB VISUAL (Hide Name)
-----------------------------------------------------------------
local VisualTab = Window:CreateTab("🎨 Visual", 6034567821)
-- Hide Name
local hideName = false
VisualTab:CreateToggle({
    Name = "🙈 Hide Name",
    CurrentValue = hideName,
    Callback = function(val)
        hideName = val
        local char = player.Character
        if char and char:FindFirstChild("Head") then
            for _,v in pairs(char.Head:GetChildren()) do
                if v:IsA("BillboardGui") or v:IsA("Decal") then
                    v.Enabled = not val
                end
            end
        end
    end
})

-- Bật/tắt ESP tên người chơi (giữ lại vì hữu dụng)
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

-- Fullbright (lúc nào cũng sáng map)
VisualTab:CreateToggle({
    Name = "🌞 Fullbright",
    CurrentValue = false,
    Callback = function(val)
        if val then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 1000
            game.Lighting.GlobalShadows = true
            game.Lighting.OutdoorAmbient = Color3.fromRGB(33,33,33)
        end
    end
})

-----------------------------------------------------------------
-- TAB PLAYER (Fly tối ưu cả PC & MOBILE, lên/xuống)
-----------------------------------------------------------------
local PlayerTab = Window:CreateTab("🕹️ Player", 6026568198)
local flyEnabled = false
local flyConn, flyGyro, flyVel, flyBtnGui
local upPressed, downPressed = false, false

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

    if UIS.TouchEnabled then
        flyBtnGui = createMobileFlyButtons()
    end

    flyConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()

        -- PC: W/A/S/D, Space lên, Shift xuống
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec + Vector3.new(0,-1,0) end

        -- Mobile: Joystick + nút lên/xuống
        if hum.MoveDirection.Magnitude > 0 then
            moveVec = Vector3.new(hum.MoveDirection.X, moveVec.Y, hum.MoveDirection.Z)
        end
        if upPressed then moveVec = moveVec + Vector3.new(0,1,0) end
        if downPressed then moveVec = moveVec + Vector3.new(0,-1,0) end

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

-----------------------------------------------------------------
-- TAB SERVER (Anti Lag REAL + các chức năng gốc)
-----------------------------------------------------------------
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

-- Anti AFK
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

-- Anti Lag REAL (xoá effect, mesh, decal, sound, particle, shadow)
ServerTab:CreateButton({
    Name = "🚀 Anti Lag REAL",
    Callback = function()
        local removeClass = {"ParticleEmitter","Trail","Smoke","Fire","Sparkles","Explosion","MeshPart","Decal","Texture","ShirtGraphic","Accessory","Clothing","Sound"}
        for _,v in pairs(workspace:GetDescendants()) do
            for _,c in pairs(removeClass) do
                if v:IsA(c) then
                    pcall(function() v:Destroy() end)
                end
            end
        end
        for _,l in pairs(game:GetService("Lighting"):GetChildren()) do
            if not l:IsA("Sky") then pcall(function() l:Destroy() end) end
        end
        game.Lighting.FogEnd = 1e10
        game.Lighting.GlobalShadows = false
        game.Lighting.Brightness = 2
        SafeChat("Đã bật Anti Lag REAL! Tăng FPS tối đa.")
    end
})

-- Teleport To Player
ServerTab:CreateDropdown({
    Name = "🚪 Teleport To Player",
    Options = {"Select a player"},
    CurrentOption = "Select a player",
    Flag = "TeleportToPlayer",
    Callback = function(Value)
        if Value ~= "Select a player" then
            local targetPlayer = Players:FindFirstChild(Value)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local 