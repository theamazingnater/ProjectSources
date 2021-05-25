-- Written by Theamazingnater
local figure = script.Parent
local humanoid = figure.Humanoid
local root = figure.HumanoidRootPart

-- Loading animations.
local run = humanoid:LoadAnimation(script.Running)
local falling = humanoid:LoadAnimation(script.Falling)
local idle = humanoid:LoadAnimation(script.Idling)
local jump = humanoid:LoadAnimation(script.Jump)

local pose = ""

local grounded = false

local speed = 0

humanoid.Running:connect(function(s)
	speed = s
end)

-- Update the pose
coroutine.wrap(function()
	while true do
		wait()
		if root.Velocity.Y > 0 and grounded == false then
			pose = "Jumping"
		end
		if root.Velocity.Y < 0 and grounded == false then
			pose = "Falling"
		end
		if speed > 1 and grounded == true then
			pose = "Running"
		end
		if speed < 1 and grounded == true then
			pose = "Idle"
		end
	end
end)()

local hum = humanoid

-- Play animations
while true do
	wait()
	AnimationTracks = figure.Humanoid:GetPlayingAnimationTracks()
	run:AdjustSpeed(humanoid.WalkSpeed / 14)
	-- make sure player is grounded
	if hum:GetState() == Enum.HumanoidStateType.Running or hum:GetState() == Enum.HumanoidStateType.RunningNoPhysics or hum:GetState() == Enum.HumanoidStateType.Landed then
		-- if the state matches, assume that the player is grounded
		grounded = true
	elseif hum:GetState() ~= Enum.HumanoidStateType.Running or hum:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics then
		-- if the state doesn't match, assume that the player is not grounded
		grounded = false
	end
	if pose == "Running" then
		for i, track in pairs (AnimationTracks) do
			if track ~= run then
				track:Stop()
			end
		end
		if run.IsPlaying ~= true then
			run:Play()
		end
	end
	if pose == "Idle" then
		for i, track in pairs (AnimationTracks) do
			if track ~= idle then
				track:Stop()
			end
		end
		if idle.IsPlaying ~= true then
			idle:Play()
		end
	end
	if pose == "Jumping" then
		for i, track in pairs (AnimationTracks) do
			if track ~= jump then
				track:Stop()
			end
		end
		if jump.IsPlaying ~= true then
			jump:Play()
		end
	end
	if pose == "Falling" then
		for i, track in pairs (AnimationTracks) do
			if track ~= falling then
				track:Stop()
			end
		end
		if falling.IsPlaying ~= true then
			falling:Play()
		end
	end
end
