local Player = game.Players.LocalPlayer
local Humanoid = workspace:WaitForChild(Player.Name):WaitForChild("Humanoid")
local HRP = workspace:WaitForChild(Player.Name):WaitForChild("HumanoidRootPart")

local boundActions = setmetatable({
	SpringY = require(script.Parent:WaitForChild("SpringYellow"));
	DashPanel = require(script.Parent:WaitForChild("DashPanel"))
}, {__index = function() return function() end end})

Humanoid.Touched:Connect(function(part)
	if part.Transparency ~= 1 then
		boundActions[part.Name](part)
	end
end)
