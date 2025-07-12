--// MULTIHACK UI - VIP VERSION w/ ANIMATION, DRAGGABLE, CENTERED

-- [ SERVICES ]
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- [ STATE ]
local toggle = {
	Wallhop = false,
	InfJump = false,
	Fly = false,
	Speed = false,
	NoClip = false,
	ESP = false,
	AntiAFK = true
}
local flyDir = 0
local lastJump = 0

-- [ ANIMATION ]
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://507767714"
local animTrack = hum:LoadAnimation(anim)

-- [ GUI ]
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MultiHackVIP"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 40)
frame.Position = UDim2.new(0.5, -140, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Active = true
frame.Draggable = true
frame.Visible = false

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", frame)
UIStroke.Color = Color3.fromRGB(0,170,255)
UIStroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Text = "☰ MULTIHACK VIP MENU"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- [ FUNCTION: Create Button ]
local buttonsFrame = Instance.new("Frame", frame)
buttonsFrame.Position = UDim2.new(0, 0, 0, 40)
buttonsFrame.Size = UDim2.new(1, 0, 0, 0)
buttonsFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", buttonsFrame)
UIListLayout.Padding = UDim.new(0, 6)

local function makeBtn(txt, func)
	local btn = Instance.new("TextButton", buttonsFrame)
	btn.Size = UDim2.new(1, -20, 0, 32)
	btn.Position = UDim2.new(0, 10, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = txt
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.AutoButtonColor = true

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(func)
end

-- [ Toggle Button ]
local openBtn = Instance.new("TextButton", gui)
openBtn.Text = "☰ MỞ MENU"
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0.5, -60, 0.85, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.AnchorPoint = Vector2.new(0.5, 0)

local cornerOpen = Instance.new("UICorner", openBtn)

local function animateMenu(open)
	if open then
		frame.Visible = true
		for i = 0, 1, 0.1 do
			frame.Size = UDim2.new(0, 280, 0, 40 + i * 280)
			buttonsFrame.Size = UDim2.new(1, 0, 0, i * 240)
			wait()
		end
	else
		for i = 1, 0, -0.1 do
			frame.Size = UDim2.new(0, 280, 0, 40 + i * 280)
			buttonsFrame.Size = UDim2.new(1, 0, 0, i * 240)
			wait()
		end
		frame.Visible = false
	end
end

local menuOpen = false
openBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	openBtn.Text = menuOpen and "✖ ẨN MENU" or "☰ MỞ MENU"
	animateMenu(menuOpen)
end)

-- [ Toggle logic ]
local function makeToggleBtn(name)
	makeBtn(name .. ": OFF", function(btn)
		toggle[name] = not toggle[name]
		btn.Text = name .. ": " .. (toggle[name] and "ON" or "OFF")
		btn.BackgroundColor3 = toggle[name] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
	end)
end

-- [ FEATURE BUTTONS ]
makeToggleBtn("Wallhop")
makeToggleBtn("InfJump")
makeToggleBtn("Fly")
makeToggleBtn("Speed")
makeToggleBtn("NoClip")
makeToggleBtn("ESP")

-- Extra
makeBtn("🔁 Rejoin Server", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end)
makeBtn("🔄 Reset Character", function()
	plr.Character:BreakJoints()
end)
makeBtn("💤 Anti-AFK: ON", function()
	-- nothing needed, enabled by default
end)

-- [ ESP ]
local function toggleESP(state)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= plr and p.Character and p.Character:FindFirstChild("Head") then
			local h = p.Character.Head
			if state then
				local billboard = Instance.new("BillboardGui", h)
				billboard.Name = "ESP"
				billboard.Size = UDim2.new(0,100,0,30)
				billboard.AlwaysOnTop = true
				local label = Instance.new("TextLabel", billboard)
				label.Text = p.DisplayName
				label.Size = UDim2.new(1,0,1,0)
				label.TextColor3 = Color3.new(1,0,0)
				label.BackgroundTransparency = 1
			else
				local gui = h:FindFirstChild("ESP")
				if gui then gui:Destroy() end
			end
		end
	end
end

-- [ LISTEN INPUT ]
UIS.InputBegan:Connect(function(k)
	if toggle.Fly then
		if k.KeyCode == Enum.KeyCode.W then flyDir = 1 end
		if k.KeyCode == Enum.KeyCode.S then flyDir = -1 end
	end
end)
UIS.InputEnded:Connect(function(k)
	if k.KeyCode == Enum.KeyCode.W or k.KeyCode == Enum.KeyCode.S then flyDir = 0 end
end)

UIS.JumpRequest:Connect(function()
	if toggle.InfJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- [ WALL CHECK ]
local function touchingWall()
	local ray = workspace:Raycast(root.Position, root.CFrame.LookVector * 2, RaycastParams.new())
	return ray
end

-- [ MAIN LOOP ]
RS.RenderStepped:Connect(function()
	if toggle.Wallhop and tick() - lastJump > 0.25 then
		if hum.FloorMaterial == Enum.Material.Air and touchingWall() then
			lastJump = tick()
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			hum:Move(Vector3.new(root.CFrame.LookVector.X, 1, root.CFrame.LookVector.Z).Unit, true)
			if animTrack.IsPlaying then animTrack:Stop() end
			animTrack:Play()
		end
	end
	if toggle.Fly then
		root.Velocity = Vector3.new(0, flyDir * 60, 0)
	end
	hum.WalkSpeed = toggle.Speed and 48 or 16
	if toggle.NoClip then
		for _, p in pairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end
	toggleESP(toggle.ESP)
end)

-- [ ANTI-AFK ]
plr.Idled:Connect(function()
	if toggle.AntiAFK then
		virtualUser = game:GetService("VirtualUser")
		virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		wait(1)
		virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end
end)
