local Player = game.Players.LocalPlayer
local Humanoid = workspace:WaitForChild(Player.Name):WaitForChild("Humanoid")
local HRP = workspace:WaitForChild(Player.Name):WaitForChild("HumanoidRootPart")
local States = require(HRP.Parent.PlayerScript.States)

local used = false

return function(part)
	if used == false then
		used = true
		HRP.CFrame = part.CFrame + Vector3.new(0,3,0)
		HRP.Velocity = Vector3.new(0,part.Configuration.Force.Value,0)
		Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
		States.ChangeState("Spring")
		script.SpringSound:Play()
		wait(0.6)
		used = false
	end
end
