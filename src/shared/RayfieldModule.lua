-- src/shared/RayfieldModule.lua
-- Studio-compatible Rayfield-style UI ModuleScript for local Roblox Studio testing.
-- Provides CreateWindow, CreateTab, and CreateToggle APIs using native Roblox GUI instances.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Rayfield = {}
Rayfield.__index = Rayfield

function Rayfield:CreateWindow(config)
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local existing = playerGui:FindFirstChild("RayfieldStudioUI")
	if existing then
		existing:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RayfieldStudioUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainWindow"
	mainFrame.Size = UDim2.new(0, 420, 0, 320)
	mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
	mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 42)
	topBar.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame

	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 10)
	topCorner.Parent = topBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 1, 0)
	titleLabel.Position = UDim2.new(0, 14, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = (config and config.Name) or "Rayfield Studio UI"
	titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	local contentContainer = Instance.new("ScrollingFrame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1, -24, 1, -56)
	contentContainer.Position = UDim2.new(0, 12, 0, 48)
	contentContainer.BackgroundTransparency = 1
	contentContainer.BorderSizePixel = 0
	contentContainer.ScrollBarThickness = 4
	contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentContainer.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = contentContainer

	local WindowObj = {}

	function WindowObj:CreateTab(tabName)
		local header = Instance.new("TextLabel")
		header.Size = UDim2.new(1, 0, 0, 24)
		header.BackgroundTransparency = 1
		header.Text = tostring(tabName or "Tab")
		header.TextColor3 = Color3.fromRGB(160, 170, 190)
		header.TextSize = 13
		header.Font = Enum.Font.GothamSemibold
		header.TextXAlignment = Enum.TextXAlignment.Left
		header.Parent = contentContainer

		local TabObj = {}

		function TabObj:CreateToggle(toggleConfig)
			local state = toggleConfig.CurrentValue == true
			local callback = toggleConfig.Callback

			local itemFrame = Instance.new("Frame")
			itemFrame.Size = UDim2.new(1, 0, 0, 42)
			itemFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
			itemFrame.BorderSizePixel = 0
			itemFrame.Parent = contentContainer

			local itemCorner = Instance.new("UICorner")
			itemCorner.CornerRadius = UDim.new(0, 8)
			itemCorner.Parent = itemFrame

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -76, 1, 0)
			label.Position = UDim2.new(0, 12, 0, 0)
			label.BackgroundTransparency = 1
			label.Text = toggleConfig.Name or "Toggle"
			label.TextColor3 = Color3.fromRGB(235, 235, 240)
			label.TextSize = 14
			label.Font = Enum.Font.Gotham
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = itemFrame

			local switchBtn = Instance.new("TextButton")
			switchBtn.Size = UDim2.new(0, 48, 0, 24)
			switchBtn.Position = UDim2.new(1, -60, 0.5, -12)
			switchBtn.BackgroundColor3 = state and Color3.fromRGB(52, 168, 83) or Color3.fromRGB(65, 65, 75)
			switchBtn.Text = ""
			switchBtn.AutoButtonColor = false
			switchBtn.Parent = itemFrame

			local switchCorner = Instance.new("UICorner")
			switchCorner.CornerRadius = UDim.new(1, 0)
			switchCorner.Parent = switchBtn

			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, 18, 0, 18)
			knob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.BorderSizePixel = 0
			knob.Parent = switchBtn

			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1, 0)
			knobCorner.Parent = knob

			local function updateVisuals()
				local targetColor = state and Color3.fromRGB(52, 168, 83) or Color3.fromRGB(65, 65, 75)
				local targetPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
				TweenService:Create(switchBtn, TweenInfo.new(0.15), { BackgroundColor3 = targetColor }):Play()
				TweenService:Create(knob, TweenInfo.new(0.15), { Position = targetPos }):Play()
			end

			switchBtn.MouseButton1Click:Connect(function()
				state = not state
				updateVisuals()
				if callback then
					callback(state)
				end
			end)
		end

		return TabObj
	end

	return WindowObj
end

return Rayfield
