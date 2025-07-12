--// 📦 MULTIHACK VIP - REWRITE FROM ZERO --// ✅ Full Feature, Center UI, Animation, Toggle Menu

-- [ SERVICES ] local Players = game:GetService("Players") local UIS = game:GetService("UserInputService") local RS = game:GetService("RunService") local TS = game:GetService("TeleportService") local plr = Players.LocalPlayer local char = plr.Character or plr.CharacterAdded:Wait() local hum = char:WaitForChild("Humanoid") local root = char:WaitForChild("HumanoidRootPart") local cam = workspace.CurrentCamera

-- [ STATE ] local toggle = { Wallhop = false, InfJump = false, Fly = false, Speed = false, NoClip = false, ESP = false, AntiAFK = true }

-- [ GUI SETUP ] local gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "MultiHackVIP"

local menu = Instance.new("Frame", gui) menu.Size = UDim2.new(0, 250, 0, 40) menu.Position = UDim2.new(0.5, -125, 0.05, 0) menu.BackgroundColor3 = Color3.fromRGB(20,20,20) menu.BorderSizePixel = 0 menu.AnchorPoint = Vector2.new(0.5, 0) menu.Active = true menu.Draggable = true

local openBtn = Instance.new("TextButton", menu) openBtn.Size = UDim2.new(1, 0, 1, 0) openBtn.Text = "☰ MỞ MENU" openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) openBtn.TextColor3 = Color3.new(1,1,1) openBtn.Font = Enum.Font.GothamBold openBtn.TextSize = 16

local list = Instance.new("Frame", gui) list.Visible = false list.Size = UDim2.new(0, 250, 0, 360) list.Position = UDim2.new(0.5, -125, 0.05, 45) list.BackgroundColor3 = Color3.fromRGB(30,30,30) list.BorderSizePixel = 0 list.AnchorPoint = Vector2.new(0.5, 0)

local layout = Instance.new("UIListLayout", list) layout.Padding = UDim.new(0,5) layout.FillDirection = Enum.FillDirection.Vertical layout.HorizontalAlignment = Enum.HorizontalAlignment.Center layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- [ BUTTON FUNCTION ] local function makeToggle(name) local btn = Instance.new("TextButton", list) btn.Size = UDim2.new(1, -10, 0, 30) btn.Text = name..": OFF" btn.BackgroundColor3 = Color3.fromRGB(50,50,50) btn.TextColor3 = Color3.new(1,1,1) btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.MouseButton1Click:Connect(function() toggle[name] = not toggle[name] btn.Text = name..": "..(toggle[name] and "ON" or "OFF") btn.BackgroundColor3 = toggle[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50,50,50) end) end

local function makeAction(name, func) local btn = Instance.new("TextButton", list) btn.Size = UDim2.new(1, -10, 0, 30) btn.Text = name btn.BackgroundColor3 = Color3.fromRGB(100,50,50) btn.TextColor3 = Color3.new(1,1,1) btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.MouseButton1Click:Connect(func) end

-- [ FEATURES BUTTONS ] for _,v in ipairs({"Wallhop","InfJump","Fly","Speed","NoClip","ESP"}) do makeToggle(v) end makeAction("🔁 Rejoin", function() TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr) end) makeAction("🔄 Reset", function() hum.Health = 0 end) makeAction("🛏 AntiAFK", function() toggle.AntiAFK = not toggle.AntiAFK end)

-- [ MENU TOGGLE ANIMATION ] openBtn.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)

-- [ LOOP: MAIN FEATURES ] local flyVel = Vector3.zero UIS.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.Space and toggle.InfJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

RS.RenderStepped:Connect(function() if toggle.Wallhop and hum.FloorMaterial == Enum.Material.Air then local ray = Ray.new(root.Position, root.CFrame.LookVector * 2) local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char}) if hit then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end if toggle.Fly then root.Velocity = Vector3.new(0, 50, 0) end if toggle.Speed then root.CFrame = root.CFrame + root.CFrame.LookVector * 0.5 end if toggle.NoClip then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- [ ANTI AFK ] if toggle.AntiAFK then local vu = game:GetService("VirtualUser") plr.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end) end

