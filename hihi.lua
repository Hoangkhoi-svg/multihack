--// ✅ SAVE & TELEPORT TO SAVED POSITION
local SavedPosition = nil

-- Save Position Button
local saveBtn = Instance.new("TextButton", menu)
saveBtn.Size = UDim2.new(1, -20, 0, 40)
saveBtn.Position = UDim2.new(0, 10, 0, 310)
saveBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextScaled = true
saveBtn.Text = "💾 Save Position"
Instance.new("UICorner", saveBtn)

saveBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		SavedPosition = char.HumanoidRootPart.Position
		StarterGui:SetCore("SendNotification", {
			Title = "📍 Đã lưu vị trí",
			Text = tostring(SavedPosition),
			Duration = 2
		})
	end
end)

-- Teleport to Saved Position Button
local teleBtn = Instance.new("TextButton", menu)
teleBtn.Size = UDim2.new(1, -20, 0, 40)
teleBtn.Position = UDim2.new(0, 10, 0, 360)
teleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
teleBtn.TextColor3 = Color3.new(1,1,1)
teleBtn.Font = Enum.Font.GothamBold
teleBtn.TextScaled = true
teleBtn.Text = "🚀 Teleport to Save"
Instance.new("UICorner", teleBtn)

teleBtn.MouseButton1Click:Connect(function()
	if SavedPosition then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(SavedPosition + Vector3.new(0, 3, 0))
		end
	else
		StarterGui:SetCore("SendNotification", {
			Title = "⚠️ Chưa lưu vị trí!",
			Text = "Nhấn Save trước đã.",
			Duration = 2
		})
	end
end)

--// ✅ CLICK TELEPORT (MOBILE ONLY)
local teleportEnabled = false

-- Toggle TP Button
local tpToggle = Instance.new("TextButton", menu)
tpToggle.Size = UDim2.new(1, -20, 0, 40)
tpToggle.Position = UDim2.new(0, 10, 0, 410)
tpToggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpToggle.TextColor3 = Color3.new(1,1,1)
tpToggle.Font = Enum.Font.GothamBold
tpToggle.TextScaled = true
tpToggle.Text = "🛸 Click TP: OFF"
Instance.new("UICorner", tpToggle)

tpToggle.MouseButton1Click:Connect(function()
	teleportEnabled = not teleportEnabled
	tpToggle.Text = teleportEnabled and "🛸 Click TP: ON" or "🛸 Click TP: OFF"
	tpToggle.BackgroundColor3 = teleportEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
end)

-- Chạm màn hình để TP (Mobile Only)
UIS.TouchTap:Connect(function(_, isProcessed)
	if teleportEnabled and not isProcessed and mouse.Hit then
		local pos = mouse.Hit.Position
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
		end
	end
end)
