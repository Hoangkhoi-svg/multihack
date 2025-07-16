local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "Hihi_UI"
gui.ResetOnSpawn = false

-- MENU CHÍNH
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 200, 0, 160)
menu.Position = UDim2.new(0, 20, 0.7, 0)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menu.BorderSizePixel = 0
menu.Active = true
menu.Draggable = true -- ✅ CHO DRAG MOBILE + PC
menu.Parent = gui
Instance.new("UICorner", menu)

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "📌 Hihi Menu (Draggable)"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- NÚT
local savedPos = nil
local tpEnabled = false

local saveBtn = Instance.new("TextButton", menu)
saveBtn.Size = UDim2.new(1, -20, 0, 30)
saveBtn.Position = UDim2.new(0, 10, 0, 40)
saveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Text = "💾 Save Position"
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextScaled = true
Instance.new("UICorner", saveBtn)

local teleBtn = Instance.new("TextButton", menu)
teleBtn.Size = UDim2.new(1, -20, 0, 30)
teleBtn.Position = UDim2.new(0, 10, 0, 80)
teleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
teleBtn.TextColor3 = Color3.new(1,1,1)
teleBtn.Text = "🚀 Teleport to Saved"
teleBtn.Font = Enum.Font.Gotham
teleBtn.TextScaled = true
Instance.new("UICorner", teleBtn)

local tpBtn = Instance.new("TextButton", menu)
tpBtn.Size = UDim2.new(1, -20, 0, 30)
tpBtn.Position = UDim2.new(0, 10, 0, 120)
tpBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Text = "🛸 Click TP: OFF"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextScaled = true
Instance.new("UICorner", tpBtn)

-- FUNCTION
saveBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		savedPos = char.HumanoidRootPart.Position
		StarterGui:SetCore("SendNotification", {
			Title = "✅ Đã lưu vị trí",
			Text = tostring(savedPos),
			Duration = 2
		})
	end
end)

teleBtn.MouseButton1Click:Connect(function()
	if savedPos then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(savedPos + Vector3.new(0, 3, 0))
		end
	else
		StarterGui:SetCore("SendNotification", {
			Title = "⚠️ Chưa lưu vị trí!",
			Text = "Vui lòng nhấn Save trước.",
			Duration = 2
		})
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	tpEnabled = not tpEnabled
	tpBtn.Text = tpEnabled and "🛸 Click TP: ON" or "🛸 Click TP: OFF"
	tpBtn.BackgroundColor3 = tpEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(100, 100, 100)
end)

-- CHẠM MÀN HÌNH (MOBILE TP)
UIS.TouchTap:Connect(function(_, isProcessed)
	if tpEnabled and not isProcessed and mouse.Hit then
		local pos = mouse.Hit.Position
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
		end
	end
end)