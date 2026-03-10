-- KOIHXZ HUB v2.1 - Combat Warriors Mobile Meta 2026 (Loadstring Version)
-- Raw GitHub ready - Hitbox to vl | Auto Parry perfect | Anti Parry unbreakable | Fast Spawn | Legit anti-ban

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "KOIHXZ HUB | Combat Warriors 2026",
    LoadingTitle = "Đang load hub pro vl...",
    LoadingSubtitle = "by Khôi Hoàng @Koihxz2610 - Mobile Only",
    ConfigurationSaving = { Enabled = true, FolderName = "KoiHxzHub", FileName = "CW_Config" },
    KeySystem = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local CombatTab = Window:CreateTab("Combat", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- ================== CÀI ĐẶT QUA MENU ==================
_G.HitboxEnabled = true
_G.GlobalSize = 38           -- To hơn nữa default
_G.AutoParryEnabled = true
_G.ParryDelay = 0.08
_G.AntiParryEnabled = true
_G.FastSpawnEnabled = true
_G.Magnitude = 20

CombatTab:CreateToggle({ Name = "Hitbox Expander (Siêu to)", CurrentValue = true, Callback = function(v) _G.HitboxEnabled = v end })
CombatTab:CreateSlider({ Name = "Hitbox Size", Range = {20, 50}, Increment = 1, Suffix = "stud", CurrentValue = 38, Callback = function(v) _G.GlobalSize = v end })

CombatTab:CreateToggle({ Name = "Auto Parry (VIP Legit)", CurrentValue = true, Callback = function(v) _G.AutoParryEnabled = v end })
CombatTab:CreateSlider({ Name = "Parry Delay (Legit)", Range = {0.05, 0.2}, Increment = 0.01, Suffix = "s", CurrentValue = 0.08, Callback = function(v) _G.ParryDelay = v end })

CombatTab:CreateToggle({ Name = "Anti Parry (Break địch parry)", CurrentValue = true, Callback = function(v) _G.AntiParryEnabled = v end })
MiscTab:CreateToggle({ Name = "Fast Spawn (0.01s)", CurrentValue = true, Callback = function(v) _G.FastSpawnEnabled = v end })

-- ================== FUNCTIONS ==================
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
        local hitboxes = tool:FindFirstChild("Hitboxes") or tool:FindFirstChild("Weapon1Hitbox")
        
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

-- Áp dụng player
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

print("✅ KOIHXZ HUB v2.1 LOADED - GitHub Raw ready! Hitbox size: " .. _G.GlobalSize .. " | Quẩy vl bro")
Rayfield:Notify({Title = "KOIHXZ HUB", Content = "Load xong rồi Khôi Hoàng, mở menu toggle thoải mái! @Koihxz2610 pro max", Duration = 6})