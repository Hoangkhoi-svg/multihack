-- KOIHXZ HUB - BẢN FIX KHÔNG HIỆN UI
_G.HeadSize = 50
_G.Disabled = true
local SavedSpeed, SavedJump = 16, 50
_G.ESPEnabled = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- FIX: Đảm bảo UI luôn hiển thị
local Rayfield = nil
local Window = nil

-- Hàm tải Rayfield an toàn
local function SafeLoadRayfield()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
    end)
    
    if success then
        return result
    end
    
    -- Thử URL dự phòng
    success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
    end)
    
    return success and result or error("Không thể tải Rayfield UI")
end

-- FIXED: Hệ thống thông báo
local function SafeNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- FIXED: Cập nhật hitbox
local function updateHitbox(v)
    if v == player then return end
    
    local character = v.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    pcall(function()
        hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
        hrp.Transparency = 0.7
        hrp.BrickColor = BrickColor.new("Cyan")
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
    end)
end

-- FIXED: Tạo ESP
local function createESP(p)
    if p == player then return end
    
    local function attachESP(char)
        if not char then return end
        
        local head = char:FindFirstChild("Head")
        if not head then return end
        
        -- Xóa ESP cũ nếu có
        local existingESP = head:FindFirstChild("KOIHXZ_ESP")
        if existingESP then
            existingESP:Destroy()
        end
        
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
    
    if p.Character then
        attachESP(p.Character)
    end
    p.CharacterAdded:Connect(attachESP)
end

-- FIXED: Khởi tạo UI
local function InitializeUI()
    -- Đảm bảo chỉ tạo UI một lần
    if Window then return end
    
    -- Tải Rayfield
    Rayfield = SafeLoadRayfield()
    
    -- CẤU HÌNH MÀU XANH NEON
    Rayfield:SetConfiguration({
        Theme = {
            BackgroundColor = Color3.fromRGB(15, 15, 25),
            MainColor = Color3.fromRGB(0, 255, 150),
            AccentColor = Color3.fromRGB(0, 255, 150),
            FontColor = Color3.fromRGB(255, 255, 255),
        }
    })
    
    -- Tạo cửa sổ chính
    Window = Rayfield:CreateWindow({
        Name = "KOIHXZ HUB FIXED",
        LoadingTitle = "UI Đã Được Fix Thành Công!",
        LoadingSubtitle = "Chức năng chính hoạt động 100%",
        ConfigurationSaving = { Enabled = false }
    })
    
    -- TAB CHÍNH
    local MainTab = Window:CreateTab("Trang Chính", 6031094670)
    MainTab:CreateSection("Di Chuyển")

    -- WALKSPEED/JUMPPOWER
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

    -- INFINITE JUMP
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

    -- TELEPORT
    local teleportEnabled = false
    MainTab:CreateToggle({
        Name = "🛰️ Dịch chuyển chạm",
        CurrentValue = teleportEnabled,
        Flag = "ClickTP",
        Callback = function(Value)
            teleportEnabled = Value
        end
    })

    -- TAB HITBOX
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

    -- TAB ESP
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

    -- TAB SERVER
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
                if server.id ~= currentJobId and server.playing < server.maxPlayers then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, player)
                    break
                end
            end
        end
    })

    -- ANTI-AFK
    ServerTab:CreateToggle({
        Name = "🚫 Chống AFK",
        CurrentValue = false,
        Callback = function(state)
            if state then
                local vu = game:GetService("VirtualUser")
                player.Idled:Connect(function()
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end
        end
    })

    -- Thông báo UI đã sẵn sàng
    Rayfield:Notify({
        Title = "✅ KOIHXZ HUB ĐÃ SẴN SÀNG",
        Content = "UI đã được load thành công!",
        Duration = 5,
        Image = 7733925913
    })
end

-- FIXED: Khởi chạy chính
task.spawn(function()
    -- Thông báo bắt đầu
    SafeNotification("🚀 KOIHXZ HUB", "Đang khởi động...", 3)
    
    -- Khởi tạo ESP
    for _, p in pairs(Players:GetPlayers()) do
        createESP(p)
    end
    Players.PlayerAdded:Connect(createESP)
    
    -- Khởi tạo Hitbox
    RunService.RenderStepped:Connect(function()
        if _G.Disabled then
            for _, v in ipairs(Players:GetPlayers()) do
                updateHitbox(v)
            end
        end
        
        -- Cập nhật tốc độ
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = SavedSpeed
                hum.JumpPower = SavedJump
            end
        end
    end)
    
    -- FIXED: Jump vô hạn
    UIS.JumpRequest:Connect(function()
        if _G.InfiniteJumpEnabled and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    
    -- FIXED: Teleport
    local function teleportTo(position)
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
            end
        end
    end

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not teleportEnabled then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local target = game:GetService("Workspace"):FindPartOnRay(Ray.new(
                game.Workspace.CurrentCamera.CFrame.Position,
                game.Workspace.CurrentCamera.CFrame.LookVector * 1000
            ))
            if target then
                teleportTo(target.Position)
            end
        end
    end)

    -- KHỞI TẠO UI SAU KHI MỌI THỨ ĐÃ SẴN SÀNG
    task.wait(1) -- Đảm bảo mọi thứ đã load
    InitializeUI()
    
    -- Thông báo thành công
    SafeNotification("✅ THÀNH CÔNG", "UI đã sẵn sàng! Nhấn phím RightControl để mở", 5)
end)

-- Phím tắt mở UI (RightControl)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if Window then
            Rayfield:Toggle()
        else
            -- Nếu UI chưa được tạo, thử tạo lại
            InitializeUI()
        end
    end
end)