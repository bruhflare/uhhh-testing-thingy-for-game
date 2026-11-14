local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local AbilityConfig = require(Shared:WaitForChild("AbilityConfig"))
local StuffFolder = ReplicatedStorage:WaitForChild("Stuff")

-- Optional: If you add RayfieldModule.lua to src/shared, require it here:
local RayfieldModule = Shared:FindFirstChild("RayfieldModule")
local Rayfield = RayfieldModule and require(RayfieldModule) or nil

-- Track toggle states for AbiSkill1 through AbiSkill5
local ActiveStates = {}

local function setAbilityLoop(skillName, enabled)
	ActiveStates[skillName] = enabled
	if enabled then
		local remote = StuffFolder:WaitForChild(skillName)
		task.spawn(function()
			while ActiveStates[skillName] do
				remote:FireServer()
				task.wait(AbilityConfig.LoopInterval)
			end
		end)
	end
end

if Rayfield then
	-- Use Rayfield UI if RayfieldModule is present in ReplicatedStorage.Shared
	local Window = Rayfield:CreateWindow({
		Name = "Studio Ability Tester",
		LoadingTitle = "Ability Test Suite",
		LoadingSubtitle = "Roblox Studio Dev Tools",
		ConfigurationSaving = { Enabled = false }
	})

	local Tab = Window:CreateTab("Ability Loops", 4483362458)

	for _, skillName in ipairs(AbilityConfig.Order) do
		local info = AbilityConfig.Abilities[skillName]
		Tab:CreateToggle({
			Name = info.DisplayName .. " (" .. skillName .. ")",
			CurrentValue = false,
			Flag = skillName .. "_Toggle",
			Callback = function(Value)
				setAbilityLoop(skillName, Value)
			end,
		})
	end
else
	-- Built-in native ScreenGui fallback so the project works immediately out of the box
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AbilityTesterGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = PlayerGui

	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 240, 0, 270)
	frame.Position = UDim2.new(0, 20, 0.5, -135)
	frame.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 38)
	title.BackgroundTransparency = 1
	title.Text = "Studio Ability Tester"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.Parent = frame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = frame

	title.LayoutOrder = 0

	for index, skillName in ipairs(AbilityConfig.Order) do
		local info = AbilityConfig.Abilities[skillName]
		local button = Instance.new("TextButton")
		button.Name = skillName .. "_Button"
		button.Size = UDim2.new(0, 210, 0, 36)
		button.BackgroundColor3 = Color3.fromRGB(45, 49, 58)
		button.TextColor3 = Color3.fromRGB(235, 235, 235)
		button.Font = Enum.Font.GothamSemibold
		button.TextSize = 14
		button.Text = info.DisplayName .. ": OFF"
		button.LayoutOrder = index
		button.Parent = frame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = button

		local toggled = false
		button.MouseButton1Click:Connect(function()
			toggled = not toggled
			button.Text = info.DisplayName .. (toggled and ": ON" or ": OFF")
			button.BackgroundColor3 = toggled and Color3.fromRGB(46, 160, 67) or Color3.fromRGB(45, 49, 58)
			setAbilityLoop(skillName, toggled)
		end)
	end
end
