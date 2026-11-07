local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local REMOTE_NAME = "BoneToolRemote"
local TOOL_NAME = "Bone"
local COOLDOWN_SECONDS = 1.25
local PROJECTILE_SPEED = 105
local PROJECTILE_LIFETIME = 5
local DAMAGE = 18
local MAX_AIM_DISTANCE = 500

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = REMOTE_NAME
	remote.Parent = ReplicatedStorage
end

local lastUseByPlayer = {}

local function createBoneTool()
	local tool = Instance.new("Tool")
	tool.Name = TOOL_NAME
	tool.ToolTip = "Throw a bone"
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool.Grip = CFrame.new(0, -0.25, 0) * CFrame.Angles(0, 0, math.rad(90))

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.35, 1.8, 0.35)
	handle.Color = Color3.fromRGB(232, 220, 184)
	handle.Material = Enum.Material.SmoothPlastic
	handle.CanCollide = false
	handle.Massless = true
	handle.Parent = tool

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = "rbxassetid://10470609"
	mesh.TextureId = "rbxassetid://10470625"
	mesh.Scale = Vector3.new(0.8, 0.8, 0.8)
	mesh.Parent = handle

	return tool
end

local function giveTool(player)
	local backpack = player:WaitForChild("Backpack")
	if backpack:FindFirstChild(TOOL_NAME) then
		return
	end
	if player.Character and player.Character:FindFirstChild(TOOL_NAME) then
		return
	end
	createBoneTool().Parent = backpack
end

local function getHumanoidFromHit(hitPart)
	local model = hitPart and hitPart:FindFirstAncestorOfClass("Model")
	return model and model:FindFirstChildOfClass("Humanoid")
end

local function throwBone(player, aimPosition)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local tool = character and character:FindFirstChild(TOOL_NAME)
	if not root or not tool or typeof(aimPosition) ~= "Vector3" then
		return
	end

	local direction = aimPosition - root.Position
	if direction.Magnitude < 2 then
		return
	end
	if direction.Magnitude > MAX_AIM_DISTANCE then
		direction = direction.Unit * MAX_AIM_DISTANCE
	end

	local now = os.clock()
	if now - (lastUseByPlayer[player] or 0) < COOLDOWN_SECONDS then
		return
	end
	lastUseByPlayer[player] = now

	local projectile = Instance.new("Part")
	projectile.Name = "ThrownBone"
	projectile.Size = Vector3.new(0.35, 1.8, 0.35)
	projectile.Color = Color3.fromRGB(232, 220, 184)
	projectile.Material = Enum.Material.SmoothPlastic
	projectile.CanCollide = false
	projectile.CanTouch = true
	projectile.CFrame = CFrame.lookAt(root.Position + direction.Unit * 3, root.Position + direction.Unit * 4) * CFrame.Angles(0, 0, math.rad(90))
	projectile.AssemblyLinearVelocity = direction.Unit * PROJECTILE_SPEED
	projectile.Parent = workspace

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = "rbxassetid://10470609"
	mesh.TextureId = "rbxassetid://10470625"
	mesh.Scale = Vector3.new(0.8, 0.8, 0.8)
	mesh.Parent = projectile

	local hitConnection
	hitConnection = projectile.Touched:Connect(function(hitPart)
		if not projectile.Parent or hitPart:IsDescendantOf(character) then
			return
		end
		local humanoid = getHumanoidFromHit(hitPart)
		if humanoid and humanoid.Health > 0 then
			humanoid:TakeDamage(DAMAGE)
			if hitConnection then
				hitConnection:Disconnect()
			end
			projectile:Destroy()
		end
	end)

	Debris:AddItem(projectile, PROJECTILE_LIFETIME)
end

remote.OnServerEvent:Connect(throwBone)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		giveTool(player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	lastUseByPlayer[player] = nil
end)

for _, player in Players:GetPlayers() do
	task.spawn(function()
		giveTool(player)
	end)
end
