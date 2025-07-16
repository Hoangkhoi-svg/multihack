--// ✅ CẤU HÌNH
_G.HeadSize = 50
_G.Disabled = true
local SavedSpeed = 16
local SavedJump = 50

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// ✅ CHAT KHI EXEC
local function SafeChat(msg)
    pcall(function()
        if TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral") then
            TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(msg)
        else
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = msg,
                Color = Color3.new(1,1,0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
        end
    end)
end
SafeChat("👑 Nhà Vua Đã Tới | The King Has Arrived 👑")

--// ✅ THÔNG BÁO EXEC
StarterGui:SetCore("SendNotification", {Title="🚀 KOIHXZ HUB ĐANG KHỞI ĐỘNG...", Text="Chuẩn bị quét toàn bộ server", Duration=3})
task.delay(3.2, function()
    StarterGui:SetCore("SendNotification", {Title="🛡️ KOIHXZ HUB THỐNG TRỊ SERVER", Text="Hitbox auto toàn server. Người mới cũng dính.", Icon="rbxassetid://7489181066", Duration=6})
end)
task.delay(6.5, function()
    StarterGui:SetCore("SendNotification", {Title="⭐ TUỲ CHỌN NÂNG CẤP ⭐", Text="Gõ /vip để mở chế độ PRO: ESP, Silent, Antiban,...", Duration=8})
end)

--// ✅ TĂNG HITBOX + GIỮ TỐC ĐỘ + NHẢY
RunService.RenderStepped:Connect(function()
    if _G.Disabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player then
                pcall(function()
                    local hrp = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                        hrp.Transparency,hrp.BrickColor,hrp.Material,hrp.CanCollide = 0.7,BrickColor.new("Really blue"),"Neon",false
                    end
                end)
            end
        end
    end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.WalkSpeed ~= SavedSpeed then hum.WalkSpeed = SavedSpeed end
        if hum.JumpPower ~= SavedJump then hum.JumpPower = SavedJump end
    end
end)

--// ✅ ÁP DỤNG HITBOX CHO NGƯỜI MỚI
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        repeat wait() until p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        wait(1)
        if _G.Disabled then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    hrp.Size=Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                    hrp.Transparency,hrp.BrickColor,hrp.Material,hrp.CanCollide = 0.7,BrickColor.new("Really blue"),"Neon",false
                end)
            end
        end
    end)
end)

--// ✅ ESP – THU NHỎ
function createESP(p)
    if p==player then return end
    p.CharacterAdded:Connect(function(char)
        repeat wait() until char:FindFirstChild("Head")
        local b=Instance.new("BillboardGui",char.Head)
        b.Name="KOIHXZ_ESP"; b.Size=UDim2.new(0,60,0,20); b.Adornee=char.Head; b.AlwaysOnTop=true
        local t=Instance.new("TextLabel",b)
        t.Size=UDim2.new(1,0,1,0); t.BackgroundTransparency=1; t.Text=p.Name; t.TextColor3=Color3.new(1,1,1)
        t.TextStrokeTransparency=0; t.TextScaled=true; t.Font=Enum.Font.GothamBold
    end)
end
for _, p in ipairs(Players:GetPlayers()) do if p~=player then createESP(p) end end
Players.PlayerAdded:Connect(createESP)

--// ✅ UI – DARK FUTURISTIC
local gui = player:WaitForChild("PlayerGui"):FindFirstChild("KOIHXZ_UI")
if not gui then
    gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "KOIHXZ_UI"
    gui.ResetOnSpawn = false
end

local mainBtn = gui:FindFirstChild("MainBtn") or Instance.new("TextButton")
if not mainBtn.Parent then
    mainBtn.Name="MainBtn"
    mainBtn.Size=UDim2.new(0,180,0,40); mainBtn.Position=UDim2.new(0,20,0,160)
    mainBtn.BackgroundColor3=Color3.fromRGB(20,20,20); mainBtn.BorderColor3=Color3.fromRGB(0,255,200)
    mainBtn.Text="🧬 KOIHXZ HUB ⚔️"; mainBtn.TextColor3=Color3.fromRGB(0,255,200)
    mainBtn.Font=Enum.Font.GothamBlack; mainBtn.TextScaled=true; mainBtn.Active=true; mainBtn.Draggable=true
    Instance.new("UICorner",mainBtn).CornerRadius=UDim.new(0,8)
    mainBtn.Parent=gui
end

local panel = mainBtn:FindFirstChild("Panel") or Instance.new("Frame")
if not panel.Parent then
    panel.Name="Panel"; panel.Size=UDim2.new(0,180,0,100); panel.Position=UDim2.new(0,0,1,0)
    panel.BackgroundColor3=Color3.fromRGB(30,30,30); panel.BorderColor3=Color3.fromRGB(0,255,200)
    Instance.new("UICorner",panel).CornerRadius=UDim.new(0,8)
    panel.Visible=false; panel.Parent=mainBtn
end

local open=false
mainBtn.MouseButton1Click:Connect(function()
    open = not open
    panel.Visible = open
end)

-- WalkSpeed
local wsBox = panel:FindFirstChild("WS") or Instance.new("TextBox",panel)
wsBox.Name="WS"; wsBox.PlaceholderText="🚶 WalkSpeed (16)"
wsBox.Size=UDim2.new(1,-10,0,30); wsBox.Position=UDim2.new(0,5,0,5)
wsBox.BackgroundColor3=Color3.fromRGB(50,50,50); wsBox.TextColor3=Color3.new(1,1,1)
wsBox.ClearTextOnFocus=false; wsBox.Font=Enum.Font.Gotham; wsBox.TextScaled=true
wsBox.FocusLost:Connect(function()
    local v=tonumber(wsBox.Text)
    if v then SavedSpeed=v end
end)

-- JumpPower
local jpBox = panel:FindFirstChild("JP") or Instance.new("TextBox",panel)
jpBox.Name="JP"; jpBox.PlaceholderText="🪂 JumpPower (50)"
jpBox.Size=UDim2.new(1,-10,0,30); jpBox.Position=UDim2.new(0,5,0,40)
jpBox.BackgroundColor3=Color3.fromRGB(50,50,50); jpBox.TextColor3=Color3.new(1,1,1)
jpBox.ClearTextOnFocus=false; jpBox.Font=Enum.Font.Gotham; jpBox.TextScaled=true
jpBox.FocusLost:Connect(function()
    local v=tonumber(jpBox.Text)
    if v then SavedJump=v end
end)

-- Teleport Button
local tpBtn = gui:FindFirstChild("TPButton") or Instance.new("TextButton",gui)
tpBtn.Name="TPButton"; tpBtn.Size=UDim2.new(0,160,0,35); tpBtn.Position=UDim2.new(0,20,0,110)
tpBtn.BackgroundColor3=Color3.fromRGB(45,45,45); tpBtn.TextColor3=Color3.fromRGB(200,255,200)
tpBtn.Font=Enum.Font.GothamBlack; tpBtn.TextScaled=true
Instance.new("UICorner",tpBtn).CornerRadius=UDim.new(0,8)
tpBtn.Text="🛸 INVITE (Click TP: OFF)"

local teleportEnabled=false
tpBtn.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    tpBtn.Text = teleportEnabled and "🛸 INVITE (Click TP: ON)" or "🛸 INVITE (Click TP: OFF)"
    tpBtn.BackgroundColor3 = teleportEnabled and Color3.fromRGB(0,170,100) or Color3.fromRGB(45,45,45)
end)

local mouse = player:GetMouse()
UIS.InputBegan:Connect(function(i, gp)
    if gp or not teleportEnabled then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos=mouse.Hit and mouse.Hit.Position
        if pos then
            local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(pos+Vector3.new(0,3,0)) end
        end
    end
end)

UIS.TouchTap:Connect(function(_,processed)
    if processed or not teleportEnabled then return end
    local pos=mouse.Hit and mouse.Hit.Position
    if pos then
        local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(pos+Vector3.new(0,3,0)) end
    end
end)
--// 🚨 CẢNH BÁO NGƯỜI MỚI VÀO GAME
game.Players.PlayerAdded:Connect(function(plr)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "🆕 Người mới vào",
		Text = plr.Name .. " vừa vào game!",
		Duration = 5
	})
end)