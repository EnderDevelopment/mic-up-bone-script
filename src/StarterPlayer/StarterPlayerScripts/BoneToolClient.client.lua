local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("BoneToolRemote")
local connectedTools = {}

local function connectTool(tool)
	if connectedTools[tool] or not tool:IsA("Tool") or tool.Name ~= "Bone" then
		return
	end
	connectedTools[tool] = true

	tool.Activated:Connect(function()
		local mouse = player:GetMouse()
		remote:FireServer(mouse.Hit.Position)
	end)

	tool.AncestryChanged:Connect(function(_, parent)
		if not parent then
			connectedTools[tool] = nil
		end
	end)
end

local function scan(container)
	for _, child in container:GetChildren() do
		connectTool(child)
	end
	container.ChildAdded:Connect(connectTool)
end

scan(player:WaitForChild("Backpack"))

player.CharacterAdded:Connect(function(character)
	scan(character)
end)

if player.Character then
	scan(player.Character)
end
