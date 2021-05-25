-- Handles everything relating to scooters.
local plr = game.Players.LocalPlayer

local char = workspace:WaitForChild(plr.Name, 50)
local hum = char:WaitForChild("Humanoid", 50)
local hrp = char:WaitForChild("HumanoidRootPart", 50)

local onScooter = false
local scooter = nil

local UIS = game:GetService("UserInputService")

-- Setting up keys
UIS.InputBegan:connect(function(inputObject, gameProcessed)
	if gameProcessed then return end
	
	if inputObject.KeyCode == Enum.KeyCode.E then
		-- do funny
		if onScooter then
			-- dismount
			Dismount()
		elseif not onScooter then
			-- mount
			Mount()
		end
	end
end)

local function FindCharacterInString(String, CharacterToFind, Start, End)
	if not String or not CharacterToFind or not Start then return end
	if not End then End = string.len(String) end
	local CharacterPos
	for i = Start, End do
		if string.sub(String, i, i) == CharacterToFind then
			CharacterPos = i
			break
		end
	end
	return CharacterPos
end

local function GetMaterialOfPartAsString(enum)
	local EnumAsString = tostring(enum)
	local FirstDotPos = FindCharacterInString(EnumAsString, ".", 1)
	if FirstDotPos then
		local SecondDotPos = FindCharacterInString(EnumAsString, ".", FirstDotPos + 1)
		if SecondDotPos then
			local MaterialOfPart = string.sub(EnumAsString, SecondDotPos + 1)
			return MaterialOfPart
		end
	end
end

-- Setting up animations
local scooterRide = hum:LoadAnimation(script.Anims["ScooterRide" .. GetMaterialOfPartAsString(hum.RigType)])

-- Setting up scooter functions (mounting, dismounting, etc.)

local slamCooldown = false

function Mount()
	onScooter = true
	game.ReplicatedStorage.Events.ServerScooter:FireServer("Summon", "Default", char) -- Spawn a scooter
	-- Prevent the player from climbing
	hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	scooter = char:WaitForChild("scooter_ModelTest")
	scooter.Touched:connect(function(hit)
		local huma = hit.Parent:FindFirstChildOfClass("Humanoid")
		if huma ~= nil and huma.Parent.Name ~= hum.Parent.Name then
			if hum.WalkSpeed > 30 and slamCooldown ~= true then
				Slam(huma.Parent)
			end
		end
	end)
	char.Animate.Disabled = true
	local AnimationTracks = hum:GetPlayingAnimationTracks()
	for i, track in pairs (AnimationTracks) do
		track:Stop()
	end
	scooterRide:Play()
end

function Dismount()
	hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true) -- Reenable climbing
	onScooter = false
	scooterRide:Stop()
	char.Animate.Disabled = false
	game.ReplicatedStorage.Events.ServerScooter:FireServer("Remove", "Default", char)
	hum.WalkSpeed = 16
	scooter = nil
end

function Slam(character)
	game.ReplicatedStorage.Events.ServerScooter:FireServer("Slam", "Default", character)
	slamCooldown = true
	hum.WalkSpeed = hum.WalkSpeed - 14 -- Slow 'em down
	wait(0.5)
	slamCooldown = false
end


while true do
	wait()
	if onScooter == true and hum.MoveDirection ~= Vector3.new(0,0,0) then
		if scooter ~= nil then
			scooter.Moving.ParticleEmitter.Enabled = true
			hum.WalkSpeed = math.clamp(hum.WalkSpeed + 1, 16, 50)
			scooter.Running.PlaybackSpeed = math.clamp(scooter.Running.PlaybackSpeed + 0.1, 1, 3)
		end
	elseif onScooter == true and hum.MoveDirection == Vector3.new(0,0,0) then
		if scooter ~= nil then
			scooter.Moving.ParticleEmitter.Enabled = false
			hum.WalkSpeed = 16
			scooter.Running.PlaybackSpeed = 1
		end
	end
end
