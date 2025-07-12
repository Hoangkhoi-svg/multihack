--// MULTIHACK UI - CỔ ĐIỂN (STABLE VERSION) --// ✅ Wallhop, InfJump, Fly, Speed, NoClip, ESP, AntiAFK --// 📦 UI kiểu cũ, đơn giản nhưng DRAGGABLE & ĐẦY ĐỦ CHỨC NĂNG

-- [ SERVICES ] local Players = game:GetService("Players") local UIS = game:GetService("UserInputService") local RS = game:GetService("RunService") local TS = game:GetService("TeleportService") local plr = Players.LocalPlayer local char = plr.Character or plr.CharacterAdded:Wait() local hum = char:WaitForChild("Humanoid") local root = char:WaitForChild("HumanoidRootPart") local cam = workspace.CurrentCamera

-- [ STATE ] local toggle = { Wallhop = false, InfJump = false, Fly = false, Speed = false, NoClip = false, ESP = false, AntiAFK = true }

-- [ UI: SETUP CỔ ĐIỂN ] local gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "MultiHackUI"

local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 200, 0, 250) frame.Position = UDim2.new(0, 50, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) frame.BorderSizePixel = 0 frame.Active = true frame.Draggable = true

local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, 0, 0, 30) title.Text = "MULTIHACK UI ✅" title.TextColor3 = Color3.new(1, 1, 1) title.BackgroundColor3 = Color3.fromRGB(0, 170, 255) title.Font = Enum.Font.GothamBold title.TextSize = 16

local layout = Instance.new("UIListLayout", frame) layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Padding = UDim.new(0, 5)

-- [ CREATE TOGGLE BUTTON ] local function makeToggle(name) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, -10, 0, 30) btn.Position = UDim2.new(0, 5, 0, 0) btn.Text = name .. ": OFF" btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.AutoButtonColor = false btn.MouseButton1Click:Connect(function() toggle[name] = not toggle[name] btn.Text = name .. ": " .. (toggle[name] and "ON" or "OFF") btn.BackgroundColor3 = toggle[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50) end) end

-- [ TOGGLE BUTTONS ] makeToggle("Wallhop") makeToggle("InfJump") makeToggle("Fly") makeToggle("Speed") makeToggle("NoClip") makeToggle("ESP") makeToggle("AntiAFK")

-- [ ACTION BUTTONS ] local function makeAction(name, callback) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, -10, 0, 30) btn.Position = UDim2.new(0, 5, 0, 0) btn.Text = name btn.BackgroundColor3 = Color3.fromRGB(100, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.MouseButton1Click:Connect(callback) end

makeAction("🔁 Rejoin", function() TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr) end)

makeAction("🔄 Reset", function() hum.Health = 0 end)

-- [ LOGIC: TÍNH NĂNG ] UIS.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.Space and toggle.InfJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

RS.RenderStepped:Connect(function() if toggle.Wallhop and hum.FloorMaterial == Enum.Material.Air then local ray = Ray.new(root.Position, root.CFrame.LookVector * 2) local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char}) if hit then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end if toggle.Fly then root.Velocity = Vector3.new(0, 50, 0) end if toggle.Speed then root.CFrame = root.CFrame + root.CFrame.LookVector * 0.5 end if toggle.NoClip then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- [ ANTI-AFK ] if toggle.AntiAFK then local vu = game:GetService("VirtualUser") plr.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0), cam.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), cam.CFrame) end) end

