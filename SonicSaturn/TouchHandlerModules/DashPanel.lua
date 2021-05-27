local Player = game.Players.LocalPlayer
local Humanoid = workspace:WaitForChild(Player.Name):WaitForChild("Humanoid")
local HRP = workspace:WaitForChild(Player.Name):WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

local offset = Vector3.new(0,4,0)

local used = false

return function(part)
	if used == false then
		used = true
		script.Parent.PlayerScript.MaxSpeed.Value = true
		if Humanoid.WalkSpeed < part.Configuration.SPD.Value then
			Humanoid.WalkSpeed = part.Configuration.SPD.Value
		end
		script.Parent.PlayerScript.MaxSpeed.Value = false
		cam.CameraType = Enum.CameraType.Scriptable
		cam.CFrame = CFrame.new(part.CFrame:PointToWorldSpace(Vector3.new(0, 12, -25)), part.CFrame:PointToWorldSpace(Vector3.new(0, 5, 0)))
		cam.CameraType = Enum.CameraType.Custom
		Humanoid.AutoRotate = false
		script.Parent:SetPrimaryPartCFrame(CFrame.new(part.Position + offset, part.endpoint.WorldPosition * Vector3.new(1, 0, 1) + Vector3.new(0, part.Position.Y + 3, 0)))
		local Bodyvel = Instance.new("BodyVelocity",HRP)
		Bodyvel.MaxForce = Vector3.new(math.huge,0,math.huge)
		Bodyvel.Velocity = HRP.CFrame.lookVector * part.Configuration.SPD.Value
		game:GetService("Debris"):AddItem(Bodyvel, 0.3)
		script.Dash:Play()
		wait(0.3)
		Humanoid.AutoRotate = true
		used = false
	end
end
