local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local AbilityConfig = require(Shared:WaitForChild("AbilityConfig"))

-- Ensure ReplicatedStorage.Stuff exists
local StuffFolder = ReplicatedStorage:FindFirstChild("Stuff")
if not StuffFolder then
	StuffFolder = Instance.new("Folder")
	StuffFolder.Name = "Stuff"
	StuffFolder.Parent = ReplicatedStorage
end

-- Track per-player cooldowns to prevent spam
local LastUsed = {}

Players.PlayerAdded:Connect(function(player)
	LastUsed[player.UserId] = {}
end)

Players.PlayerRemoving:Connect(function(player)
	LastUsed[player.UserId] = nil
end)

local function onAbilityTriggered(player, skillName)
	local config = AbilityConfig.Abilities[skillName]
	if not config then
		return
	end

	local userCooldowns = LastUsed[player.UserId]
	if not userCooldowns then
		userCooldowns = {}
		LastUsed[player.UserId] = userCooldowns
	end

	local now = os.clock()
	local previous = userCooldowns[skillName] or 0
	if (now - previous) < config.Cooldown then
		return
	end

	userCooldowns[skillName] = now

	-- Place your actual server-side ability logic here
	print(string.format("[Server] %s activated %s (%s)", player.Name, config.DisplayName, skillName))
end

-- Create RemoteEvents AbiSkill1 through AbiSkill5 inside ReplicatedStorage.Stuff
for _, skillName in ipairs(AbilityConfig.Order) do
	local remote = StuffFolder:FindFirstChild(skillName)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = skillName
		remote.Parent = StuffFolder
	end

	remote.OnServerEvent:Connect(function(player)
		onAbilityTriggered(player, skillName)
	end)
end
