local plr = game.Players.LocalPlayer
workspace:WaitForChild(plr.Name, 10)
local char = workspace[plr.Name]
char:WaitForChild("Humanoid", 10)
local hum = char.Humanoid

while true do
	wait()
	-- spin!!!
	-- make sure their root exists
	local root = char:FindFirstChild("HumanoidRootPart")
	if root ~= nil then
		-- check their movedirection 
		if hum.MoveDirection == Vector3.new(0,0,0) then
			script.Parent.Rotation += 1
		elseif hum.MoveDirection ~= Vector3.new(0,0,0) then
			-- do some complicated stuff with Magnitude
			local velocityWithOnlyXZ = Vector3.new(char.HumanoidRootPart.Velocity.X, 0, char.HumanoidRootPart.Velocity.Z)
			script.Parent.Rotation += (velocityWithOnlyXZ.magnitude / 10)
		end
	end
end
