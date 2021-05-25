-- util

function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)
	if child then return child end
	while true do
		child = parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end

function newSound(id)
	local sound = Instance.new("Sound")
	sound.SoundId = id
	sound.archivable = false
	sound.Parent = script.Parent.Head
	return sound
end

-- declarations

local sDied = newSound("rbxasset://sounds/uuhhh.mp3")
local sFallingDown = newSound("rbxasset://sounds/splat.wav")
local sFreeFalling = newSound("rbxasset://sounds/Rocket whoosh 01.wav")
local sGettingUp = newSound("rbxasset://sounds/hit.wav")
local sJumping = newSound("rbxassetid://12222200") -- swoosh.wav
local sJumping2 = newSound("rbxassetid://12221967") -- button.wav
local sLanded = newSound("rbxassetid://0")
local sRunning = newSound("rbxasset://sounds/bfsl-minifigfoots1.mp3")
sRunning.Looped = true

local Figure = script.Parent
local Head = waitForChild(Figure, "Head")
local Humanoid = waitForChild(Figure, "Humanoid")

-- functions

function onDied()
	sDied:Play()
end

function onState(state, sound)
	if state then
		sound:Play()
	else
		sound:Pause()
	end
end

function onRunning(speed)
	if speed > 1 then
		sRunning:Play()
	elseif speed < 1 then
		sRunning:Pause()
	end
end

function landed()
	sLanded:Play()
end

-- connect up

local currentVel = Figure.HumanoidRootPart.Velocity

Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.GettingUp:connect(function(state) sGettingUp:Play() end)
Humanoid.FallingDown:connect(function(state) onState(state, sFallingDown) end)

Humanoid.StateChanged:connect(function(old, new) -- land sfx
	if new == Enum.HumanoidStateType.Landed then
		landed()
	end
end)

grounded = false

-- for sounds that don't always work like they should, case in point jumping
while true do
	wait()
	-- freefall
	-- get the root's velocity. if it's over -250, start the falling sound.
	local rootvel = Figure.HumanoidRootPart.Velocity
	if rootvel.Y < -250 then
		if sFreeFalling.IsPlaying ~= true then
			sFreeFalling:Play()
		end
	else
		sFreeFalling:Stop()
	end
	
	-- jumping
	-- make sure that they're grounded first before and jump checks are made
	if Humanoid:GetState() == Enum.HumanoidStateType.Running or Humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics or Humanoid:GetState() == Enum.HumanoidStateType.Landed then
		-- if the state matches, assume that the player is grounded
		grounded = true
	elseif Humanoid:GetState() ~= Enum.HumanoidStateType.Running or Humanoid:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics then
		-- if the state doesn't match, assume that the player is not grounded
		grounded = false
	end
	-- now do some checks for jumping
	if rootvel.Y > 0 and not grounded then
		if sJumping.IsPlaying ~= true and sJumping2.IsPlaying ~= true then
			sJumping2:Play()
			wait(0.04)
			sJumping2:Stop()
			sJumping:Play()
		end
		wait(0.3)
	elseif rootvel.Y < 0 and not grounded then
		sJumping:Stop()
		sJumping2:Stop()
	end
end

