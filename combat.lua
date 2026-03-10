-- KOIHXZ HUB - Combat Warriors FIXED 2026

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui",10)
if not PlayerGui then
    warn("PlayerGui not found")
    return
end

repeat task.wait() until LocalPlayer.Character

warn("KOIHXZ HUB STARTED")

-- SETTINGS
local HitboxSize = 30
local ParryDistance = 18
local ParryDelay = 0.08
local ParryCooldown = 0.35

local lastParry = 0

-- ================= NOTIFY =================
local function notify(text)

    local gui = Instance.new("ScreenGui")
    gui.Name = "KOIHXZ_NOTIFY"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.4,0,0.1,0)
    frame.Position = UDim2.new(0.3,0,0.05,0)
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    txt.TextColor3 = Color3.fromRGB(255,70,70)
    txt.Text = text
    txt.Parent = frame

    task.delay(5,function()
        gui:Destroy()
    end)

end

notify("KOIHXZ HUB LOADING...")
print("KOIHXZ HUB LOADING")

-- ================= HITBOX =================
local function applyHitbox(char)

    local root = char:FindFirstChild("HumanoidRootPart")

    if root then
        pcall(function()
            root.Size = Vector3.new(HitboxSize,HitboxSize,HitboxSize)
            root.Transparency = 1
            root.CanCollide = false
            root.Massless = true
        end)
    end

end

-- ================= PARRY =================
local function pressF()

    VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.F,false,game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.F,false,game)

end

local function autoParry(enemy)

    if tick() - lastParry < ParryCooldown then return end

    if not enemy:FindFirstChild("HumanoidRootPart") then return end

    local mychar = LocalPlayer.Character
    if not mychar then return end

    local myroot = mychar:FindFirstChild("HumanoidRootPart")
    if not myroot then return end

    local dist = (enemy.HumanoidRootPart.Position - myroot.Position).Magnitude

    if dist < ParryDistance then

        lastParry = tick()

        task.spawn(function()
            task.wait(ParryDelay + math.random(0.01,0.04))
            pressF()
        end)

    end

end

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()

    for _,plr in pairs(Players:GetPlayers()) do

        if plr ~= LocalPlayer and plr.Character then
            applyHitbox(plr.Character)
            autoParry(plr.Character)
        end

    end

end)

-- ================= FAST RESPAWN =================
LocalPlayer.CharacterAdded:Connect(function(char)

    local hum = char:WaitForChild("Humanoid")

    hum.Died:Connect(function()
        task.wait(0.05)
        LocalPlayer:LoadCharacter()
    end)

end)

notify("KOIHXZ HUB LOADED\nHitbox + Auto Parry + Fast Respawn")

print("KOIHXZ HUB FULLY LOADED") if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
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
