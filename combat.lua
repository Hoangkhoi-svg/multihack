-- KOIHXZ HUB - Combat Warriors Mobile Auto All-In-One (No Menu 2026)
-- Bỏ hết menu Rayfield, kích hoạt script là chạy hết luôn
-- Có thông báo Notify + print giống raw hackmenu.lua của mày để biết nó sống hay chết
-- Load bằng: loadstring(game:HttpGet("https://raw.githubusercontent.com/Hoangkhoi-svg/multihack/refs/heads/main/combat.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ================== CÀI ĐẶT (có thể chỉnh nếu muốn) ==================
local HitboxSize = 38          -- Size hitbox full body
local ParryDelay = 0.08        -- Delay parry legit (random thêm 0.01-0.04)
local Magnitude = 20           -- Phạm vi detect parry (đừng tăng quá lag mobile)
local Transparency = 1         -- Ẩn hitbox hoàn toàn

-- ================== THÔNG BÁO (giống hackmenu.lua của mày) ==================
print("KOIHXZ HUB - Combat Warriors LOADING...")

local function Notify(title, content)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = content,
        Duration = 8,
        Icon = "rbxassetid://4483362458"  -- Icon combat cho ngầu
    })
end

Notify("KOIHXZ HUB", "Đang load combat script... Hitbox auto, Auto Parry, Anti Parry, Fast Spawn sẵn sàng bro!")

-- ================== LOGIC HITBOX FULL BODY ==================
local function applyHitbox(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                part.Transparency = Transparency
                part.CanCollide = false
                part.Massless = true
            end)
        end
    end
end

-- ================== AUTO PARRY (detect sound trong hitbox) ==================
local function keyclick(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(math.random(0.03, 0.08))
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function lookAt(target)
    local cam = Workspace.CurrentCamera
    local goal = CFrame.lookAt(cam.CFrame.Position, target.HumanoidRootPart.Position)
    cam.CFrame = cam.CFrame:Lerp(goal, 0.6)
end

local function isLegitLooking(chr)
    if not LocalPlayer.Character or not chr.HumanoidRootPart then return false end
    local dir = chr.HumanoidRootPart.CFrame.LookVector
    local toMe = (LocalPlayer.Character.HumanoidRootPart.Position - chr.HumanoidRootPart.Position).Unit
    return dir:Dot(toMe) > 0.3
end

local function setupAutoParry(chr, plr)
    if plr == LocalPlayer then return end
    task.spawn(function()
        repeat task.wait() until chr:FindFirstChildOfClass("Tool")
        local tool = chr:FindFirstChildOfClass("Tool")
        local hitboxes = tool:FindFirstChild("Hitboxes") or tool:FindFirstChild("Weapon1Hitbox") or tool:FindFirstChild("Hitbox")
        
        if hitboxes then
            hitboxes.ChildAdded:Connect(function(child)
                if not child:IsA("Sound") then return end
                local dist = (chr.HumanoidRootPart.Position - (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero)).Magnitude
                if dist > Magnitude then return end
                if not isLegitLooking(chr) then return end
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    task.wait(ParryDelay + math.random(0.01, 0.04))
                    lookAt(chr)
                    keyclick(Enum.KeyCode.F)
                end
            end)
        end
    end)
end

-- ================== ANTI PARRY (break parry địch) ==================
local function setupAntiParry(chr, plr)
    if plr == LocalPlayer then return end
    task.spawn(function()
        if chr:FindFirstChild("SemiTransparentShield") then
            chr.SemiTransparentShield.ChildAdded:Connect(function()
                if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then return end
                local myTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                LocalPlayer.Character.Humanoid:UnequipTools()
                task.wait(math.random(0.08, 0.18))
                if chr:FindFirstChild("SemiTransparentShield") then
                    chr.SemiTransparentShield:GetPropertyChangedSignal("Transparency"):Wait()
                end
                LocalPlayer.Character.Humanoid:EquipTool(myTool)
            end)
        end
    end)
end

-- ================== FAST SPAWN (0.01s respawn) ==================
local function setupFastSpawn()
    LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            task.wait(0.01)
            LocalPlayer:LoadCharacter()
        end)
    end)
end

-- ================== ÁP DỤNG CHO TẤT CẢ PLAYER ==================
for _, plr in ipairs(Players:GetPlayers()) do
    if plr \~= LocalPlayer then
        if plr.Character then
            applyHitbox(plr.Character)
            setupAutoParry(plr.Character, plr)
            setupAntiParry(plr.Character, plr)
        end
        plr.CharacterAdded:Connect(function(char)
            applyHitbox(char)
            setupAutoParry(char, plr)
            setupAntiParry(char, plr)
        end)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr \~= LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            applyHitbox(char)
            setupAutoParry(char, plr)
            setupAntiParry(char, plr)
        end)
    end
end)

-- Loop update hitbox realtime
RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            applyHitbox(plr.Character)
        end
    end
end)

setupFastSpawn()

-- ================== THÔNG BÁO HOÀN TẤT ==================
print("KOIHXZ HUB - Combat Warriors FULLY LOADED!")
Notify("KOIHXZ HUB", "TẤT CẢ ĐÃ CHẠY: Hitbox auto full server, Auto Parry legit, Anti Parry unbreakable, Fast Spawn 0.01s. Quẩy vl bro!")CombatTab:CreateToggle({
    Name = "Hitbox Expander (Full Body)",
    CurrentValue = true,
    Callback = function(v)
        _G.HitboxEnabled = v
        print("Hitbox: " .. (v and "BẬT" or "TẮT"))
    end
})
CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {20, 50},
    Increment = 1,
    Suffix = "stud",
    CurrentValue = 38,
    Callback = function(v)
        _G.GlobalSize = v
        print("Hitbox size cập nhật: " .. v)
    end
})

CombatTab:CreateSection("Auto Parry (Legit VIP)")
CombatTab:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = true,
    Callback = function(v)
        _G.AutoParryEnabled = v
        print("Auto Parry: " .. (v and "BẬT" or "TẮT"))
    end
})
CombatTab:CreateSlider({
    Name = "Parry Delay (Legit)",
    Range = {0.05, 0.2},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.08,
    Callback = function(v)
        _G.ParryDelay = v
        print("Parry delay: " .. v .. "s")
    end
})

CombatTab:CreateSection("Anti Parry")
CombatTab:CreateToggle({
    Name = "Anti Parry (Break parry địch)",
    CurrentValue = true,
    Callback = function(v)
        _G.AntiParryEnabled = v
        print("Anti Parry: " .. (v and "BẬT" or "TẮT"))
    end
})

CombatTab:CreateSection("Misc")
CombatTab:CreateToggle({
    Name = "Fast Spawn (0.01s respawn)",
    CurrentValue = true,
    Callback = function(v)
        _G.FastSpawnEnabled = v
        print("Fast Spawn: " .. (v and "BẬT" or "TẮT"))
    end
})

-- ================== LOGIC CHÍNH ==================
local function keyclick(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(math.random(0.03, 0.08))
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function lookAt(target)
    local cam = Workspace.CurrentCamera
    local goal = CFrame.lookAt(cam.CFrame.Position, target.HumanoidRootPart.Position)
    cam.CFrame = cam.CFrame:Lerp(goal, 0.6)
end

local function isLegitLooking(chr)
    if not LocalPlayer.Character or not chr.HumanoidRootPart then return false end
    local dir = chr.HumanoidRootPart.CFrame.LookVector
    local toMe = (LocalPlayer.Character.HumanoidRootPart.Position - chr.HumanoidRootPart.Position).Unit
    return dir:Dot(toMe) > 0.3
end

local function applyHitbox(character)
    if not character or not _G.HitboxEnabled then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.Size = Vector3.new(_G.GlobalSize, _G.GlobalSize, _G.GlobalSize)
                part.Transparency = 1
                part.CanCollide = false
                part.Massless = true
            end)
        end
    end
end

local function setupAutoAndAnti(chr, plr)
    if plr == LocalPlayer then return end
    task.spawn(function()
        repeat task.wait() until chr:FindFirstChildOfClass("Tool")
        local tool = chr:FindFirstChildOfClass("Tool")
        local hitboxes = tool:FindFirstChild("Hitboxes") or tool:FindFirstChild("Weapon1Hitbox") or tool:FindFirstChild("Hitbox")
        
        if hitboxes and _G.AutoParryEnabled then
            hitboxes.ChildAdded:Connect(function(child)
                if not child:IsA("Sound") or not _G.AutoParryEnabled then return end
                local dist = (chr.HumanoidRootPart.Position - (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.zero)).Magnitude
                if dist > _G.Magnitude then return end
                if not isLegitLooking(chr) then return end
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    task.wait(_G.ParryDelay + math.random(0.01, 0.04))
                    lookAt(chr)
                    keyclick(Enum.KeyCode.F)
                end
            end)
        end
        
        if chr:FindFirstChild("SemiTransparentShield") and _G.AntiParryEnabled then
            chr.SemiTransparentShield.ChildAdded:Connect(function()
                if not _G.AntiParryEnabled or not LocalPlayer.Character:FindFirstChildOfClass("Tool") then return end
                local myTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                LocalPlayer.Character.Humanoid:UnequipTools()
                task.wait(math.random(0.08, 0.18))
                if chr:FindFirstChild("SemiTransparentShield") then
                    chr.SemiTransparentShield:GetPropertyChangedSignal("Transparency"):Wait()
                end
                LocalPlayer.Character.Humanoid:EquipTool(myTool)
            end)
        end
    end)
end

local function setupFastSpawn()
    if not _G.FastSpawnEnabled then return end
    LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            task.wait(0.01)
            LocalPlayer:LoadCharacter()
        end)
    end)
end

-- Áp dụng cho tất cả player
for _, plr in ipairs(Players:GetPlayers()) do
    if plr \~= LocalPlayer then
        if plr.Character then
            applyHitbox(plr.Character)
            setupAutoAndAnti(plr.Character, plr)
        end
        plr.CharacterAdded:Connect(function(char)
            applyHitbox(char)
            setupAutoAndAnti(char, plr)
        end)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr \~= LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            applyHitbox(char)
            setupAutoAndAnti(char, plr)
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            applyHitbox(plr.Character)
        end
    end
end)

setupFastSpawn()

print("KOIHXZ HUB - Combat Tab LOADED! Menu Rayfield sẵn sàng, toggle thoải mái bro")
Rayfield:Notify({
    Title = "Combat Hub Ready",
    Content = "Hitbox auto full server, auto parry legit, anti parry break địch. Quẩy đi!",
    Duration = 6
})
