--// Multi Hack Script with Collapsible Menu UI (KRNL Compatible)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local ws = game:GetService("Workspace")

-- Flags
local toggle = {
	Wallhop = false,
	InfJump = false,
	Fly = false,
	Speed = false,
	NoClip = false
}
local flyDir = 0
local lastJump = 0

-- Animation
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://507767714"
local animTrack = hum:LoadAnimation(anim)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FoldMenuUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 40)
frame.Position = UDim2.new(0, 30, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Toggle Menu Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, 0, 0, 40)
toggleBtn.Text = "☰ Mở Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18

-- Container for options
local buttonsFrame = Instance.new("Frame", frame)
buttonsFrame.Position = UDim2.new(0, 0, 0, 40)
buttonsFrame.Size = UDim2.new(1, 0, 0, 5 * 35)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Visible = false

local expanded = false
toggleBtn.MouseButton1Click:Connect(function()
	expanded = not expanded
	buttonsFrame.Visible = expanded
	toggleBtn.Text = expanded and "✖ Đóng Menu" or "☰ Mở Menu"
	frame.Size = UDim2.new(0, 200, 0, expanded and (40 + 5*35) or 40)
end)

-- Function: create toggle button
local function makeToggle(name, index)
	local btn = Instance.new("TextButton", buttonsFrame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, (index - 1) * 35)
	btn.Text = name .. ": OFF"
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16

	btn.MouseButton1Click:Connect(function()
		toggle[name] = not toggle[name]
		btn.Text = name .. ": " .. (toggle[name] and "ON" or "OFF")
		btn.BackgroundColor3 = toggle[name] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
	end)
end

-- Create buttons
makeToggle("Wallhop", 1)
makeToggle("InfJump", 2)
makeToggle("Fly", 3)
makeToggle("Speed", 4)
makeToggle("NoClip", 5)

-- Input for Fly
UIS.InputBegan:Connect(function(key)
	if toggle.Fly then
		if key.KeyCode == Enum.KeyCode.W then flyDir = 1 end
		if key.KeyCode == Enum.KeyCode.S then flyDir = -1 end
	end
end)
UIS.InputEnded:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.W or key.KeyCode == Enum.KeyCode.S then flyDir = 0 end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if toggle.InfJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Check wall
local function isTouchingWall()
	local ray = ws:Raycast(root.Position, root.CFrame.LookVector * 2, RaycastParams.new())
	return ray
end

-- Main loop
RS.RenderStepped:Connect(function()
	-- Wallhop
	if toggle.Wallhop and tick() - lastJump > 0.25 then
		if hum.FloorMaterial == Enum.Material.Air then
			local hit = isTouchingWall()
			if hit then
				lastJump = tick()
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
				hum:Move(Vector3.new(root.CFrame.LookVector.X, 1, root.CFrame.LookVector.Z).Unit, true)
				if animTrack.IsPlaying then animTrack:Stop() end
				animTrack:Play()
			end
		end
	end

	-- Fly
	if toggle.Fly then
		root.Velocity = Vector3.new(0, flyDir * 60, 0)
	end

	-- Speed
	hum.WalkSpeed = toggle.Speed and 48 or 16

	-- NoClip
	if toggle.NoClip then
		for _, p in pairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end
end)
