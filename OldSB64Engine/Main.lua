-- // 3D Platformer Engine by Theamazingnater \\ --
-- // Please credit me if you use this\\ -- 
-- // Thanks! \\ --
-- // References \\ --
plr = game.Players.LocalPlayer
plr.CharacterAdded:wait()
char = plr.Character
UIS = game:GetService("UserInputService")
rootpart = char:WaitForChild("HumanoidRootPart")
-- //  Config references \\
ConfigFolder = script:WaitForChild('Config')
AbilitiesFolder = ConfigFolder:WaitForChild("Abilities")
AnimationsFolder = ConfigFolder:WaitForChild("Animations")
canGP = AbilitiesFolder.canGP
canWallJ = AbilitiesFolder.canWallJ
canLongJump = AbilitiesFolder.canLongJump
canCrouch = AbilitiesFolder.canCrouch
canDiveReal = AbilitiesFolder.canDive
canTripleJ = AbilitiesFolder.canTripleJump
canSlide = AbilitiesFolder.canSlide
canShowTrails = AbilitiesFolder.canShowTrails
repeat wait() until char:WaitForChild("Humanoid") ~= nil
LongJumpAnim = char.Humanoid:LoadAnimation(AnimationsFolder.Longjump)
GroundPoundAnim = char.Humanoid:LoadAnimation(AnimationsFolder.GroundPound)
GroundPoundStartA = char.Humanoid:LoadAnimation(AnimationsFolder.GroundPoundS)
WallJumpAnim = char.Humanoid:LoadAnimation(AnimationsFolder.WallJSlide)
CrouchAnim = char.Humanoid:LoadAnimation(AnimationsFolder.Crouch)
DoubleJumpAnim = char.Humanoid:LoadAnimation(AnimationsFolder.DoubleJump)
TripleJumpAnim = char.Humanoid:LoadAnimation(AnimationsFolder.TripleJump)
DiveAnim = char.Humanoid:LoadAnimation(AnimationsFolder.Dive)
DiveSAnim = char.Humanoid:LoadAnimation(AnimationsFolder.DiveS)
LavaBoost = char.Humanoid:LoadAnimation(AnimationsFolder.LavaBoost)
-- SpinAttack = char.Humanoid:LoadAnimation(AnimationsFolder:WaitForChild("SpinAttack"))
-- // Config References end \\ --
-- // Bools \\ --
LongJumping = false
Crouching = false
GroundPounding = false
Diving = false
WallJumping = false
hitfloor = true
DiveSliding = false
-- // Bools end \\ -
stateType = Enum.HumanoidStateType
humanoid = char.Humanoid
rootpart:WaitForChild("Jumping").Volume = 3
rootpart:WaitForChild("Landing").PlaybackSpeed = 1
vel = Instance.new("BodyVelocity")
vel.MaxForce = Vector3.new(math.huge,0,math.huge)
vel.Velocity = Vector3.new(0,-5,0)
-- // Animations \\ --
function PlayAnimation(pose)
	local AnimationTracks = {LongJumpAnim, WallJumpAnim, DoubleJumpAnim, TripleJumpAnim, DiveAnim, DiveSAnim, CrouchAnim, GroundPoundStartA, GroundPoundAnim, LavaBoost}
	if pose == "WallJ" then
		LongJumpAnim:Stop()
		WallJumpAnim:Play()
	end
	if pose == "Dive" then
		LongJumpAnim:Stop()
		DoubleJumpAnim:Stop()
		TripleJumpAnim:Stop()
		DiveAnim:Play()
	end 
	if pose == "DiveS" then
		DiveAnim:Stop()
		DiveSAnim:Play()
	end
	if pose == "Longjump" then
		CrouchAnim:Stop()
		LongJumpAnim:Play()
	end
	if pose == "Crouching" then
		CrouchAnim:Play()
	end
	if pose == "GroundpoundS" then
		GroundPoundStartA:Play()
	end
	if pose == "GroundPound" then
		GroundPoundStartA:Stop()
		GroundPoundAnim:Play()
	end
	if pose == "DoubleJump" then
		DoubleJumpAnim:Play()
	end
	if pose == "TripleJump" then
		DoubleJumpAnim:Stop()
		TripleJumpAnim:Play()
	end
	if pose == "LavaBoost" then
		LavaBoost:Play()
	end
	if pose == "None" then
		-- Stop all playing animations
		for i, track in pairs (AnimationTracks) do
				track:Stop()
		end
	end
end
--//Moveset!\\--
function GroundPound()
	hitfloor = false
	Crouching = false
	PlayAnimation("GroundpoundS")
	rootpart:WaitForChild("Jumping").Pitch = 1.5
	rootpart:WaitForChild("Jumping"):Play()
	local vel = Instance.new("BodyVelocity",char.Torso)
	vel.Velocity = Vector3.new(0,0,0)
	vel.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	vel.Name = "GroundPoundVelocity"
	wait(1)
	PlayAnimation("GroundPound")
	vel.Velocity = char.HumanoidRootPart.CFrame.upVector * -75
	repeat wait() until hitfloor == true
	vel:Destroy()
	hitfloor = false
	GroundPounding = false
	char:WaitForChild("Animate").Disabled = false
	wait(0.3)
end
hrp = char.HumanoidRootPart
local canDive = true;
local diveCount = 0;
local totalDives = 0;
local Diving = false;
local DiveSpeed
WallJumpSoundURL = "rbxasset://sounds/action_jump.mp3"
WallAttachSoundURL = "rbxasset://sounds/action_jump_land.mp3"
WallGripDuration = 1
JumpCooldown = 0.1
GrabCooldown = 0.1
RunService = game:GetService("RunService")
RootPart = rootpart
Humanoid = humanoid
RootAttachment = RootPart.RootAttachment
WallGripLeft = 0 -- To make players fall off eventually.
JumpWait = 0 -- To prevent accidental auto-jumping.
GrabWait = 0 -- To prevent players grabbing the wall forever with shift-lock.
CurrentConstraint = nil
CurrentAttachment = nil
OldWalkspeed = 0
GripLookVector = Vector3.new(0, 0, -1)
function LoseGrip()
	WallGripLeft = 0
	GrabWait = GrabCooldown
	Humanoid.WalkSpeed = OldWalkspeed
	PlayAnimation("None")
	Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	char.Animate.Disabled = false
	CurrentConstraint:Destroy()
	CurrentConstraint = nil
	CurrentAttachment:Destroy()
	CurrentAttachment = nil
	WallJumping = false
end
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
local sliding = false;
function JumpN()
	stage = 0
	rootpart:WaitForChild("Jumping").Pitch = 1
	rootpart:WaitForChild("Jumping"):Play()
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
RunService.Heartbeat:Connect(function(deltaTime)
	if CurrentConstraint == nil and GrabWait <= 0 and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		-- When the character is falling in front of a wall, attach it to the wall.
		local ray = Ray.new(RootPart.Position, RootPart.CFrame.LookVector * 1.5)
		local hit, point, normal = workspace:FindPartOnRay(ray, char)
		local hitTag = hit and hit:FindFirstChild("_Wall")
		if hitTag == nil then
			-- Temporarily attach the Humanoid to the wall.
			if hit ~= nil and hit.CanCollide ~= false then
			local normalCFrame = hit.CFrame:ToObjectSpace(CFrame.new(Vector3.new(0, 0, 0), normal))
			normalCFrame = normalCFrame - normalCFrame.Position
			local offsetCFrame = CFrame.new((hit.CFrame:inverse() * RootPart.CFrame).Position)
			local newCFrame = hit.CFrame * offsetCFrame * normalCFrame
			RootPart.CFrame = newCFrame
			GripLookVector = newCFrame.LookVector
			OldWalkspeed = Humanoid.WalkSpeed
			Humanoid.WalkSpeed = 0
			WallJumping = true
				CurrentAttachment = Instance.new("Attachment")
				CurrentAttachment.Name = "WallJumpAttachment"
				CurrentAttachment.CFrame = offsetCFrame * normalCFrame
				CurrentAttachment.Parent = hit
				CurrentConstraint = Instance.new("BallSocketConstraint")
				CurrentConstraint.Attachment0 = CurrentAttachment
				CurrentConstraint.Attachment1 = RootAttachment
				CurrentConstraint.Name = "WallWeld"
				CurrentConstraint.Parent = RootPart
				game.Debris:AddItem(CurrentAttachment, WallGripDuration + 1)
				game.Debris:AddItem(CurrentConstraint, WallGripDuration + 1)
			char.Animate.Disabled = true
			PlayAnimation("WallJ")
			WallGripLeft = WallGripDuration
			JumpWait = JumpCooldown
			end
		end
	elseif CurrentConstraint ~= nil then
		-- When the character holds on to the wall for too long, make it lose hold.
		WallGripLeft = math.max(0, WallGripLeft - deltaTime)
		if WallGripLeft <= 0 then
			LoseGrip()
		end
	end
	JumpWait = math.max(0, JumpWait - deltaTime)
	GrabWait = math.max(0, GrabWait - deltaTime)
end)
Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
	-- When the character jumps and they're attached to a wall, propel them away from it.
	if CurrentConstraint ~= nil and Humanoid.Jump and JumpWait <= 0 then
		LoseGrip()
		-- Propel the character away from the wall.
		char.Animate.Disabled = false
		PlayAnimation("None")
		RootPart.Velocity =	RootPart.Velocity + Vector3.new(0,  0, 0) + (GripLookVector * Humanoid.JumpPower)
		stage = 0
		JumpN()
	end
end)
DiveControl = Enum.KeyCode.LeftShift
CrouchControl = Enum.KeyCode.LeftControl
MenuOpenControl = Enum.KeyCode.Q
deb2 = 1
function Dive()
	if canDive ~= false then
		LongJumping = false
		canDive = false;
		Diving = true;
		diveCount = diveCount + 1;
		totalDives = totalDives + 1;
		char:WaitForChild("Animate").Disabled = true
		PlayAnimation("Dive")
		humanoid:ChangeState(Enum.HumanoidStateType.Flying);
		hrp.Velocity = hrp.CFrame:vectorToWorldSpace(Vector3.new(0, humanoid.JumpPower, -humanoid.WalkSpeed*2));
		DiveSpeed = hrp.Velocity.Y
		hrp.RotVelocity = hrp.CFrame:vectorToWorldSpace(Vector3.new(-math.rad(100), 0, 0));
		rootpart:WaitForChild("Jumping").Pitch = 2
		rootpart:WaitForChild("Jumping"):Play()
		local currentDive = totalDives;
		wait(0.5);
		if (currentDive == totalDives) then
			hrp.RotVelocity = hrp.CFrame:vectorToWorldSpace(Vector3.new(0, 0, 0));
		end		
	end
end
DiveSlideCanceling = true


function DiveSlide()
	DiveSpeed = DiveSpeed - 15
	canDive = true
	char:WaitForChild("Animate").Disabled = true
	PlayAnimation("DiveS")
	vel.Parent = char.Torso
	char.Humanoid.MaxSlopeAngle = 1
	rootpart:WaitForChild("Jumping").Pitch = 1
	DiveSliding = true
	while DiveSpeed > 0 do
		wait()
		vel.velocity = char.HumanoidRootPart.CFrame.lookVector*DiveSpeed
		if OnSlope ~= true then
			DiveSpeed = DiveSpeed - 1
		end
		char.Humanoid.JumpPower = 0
	end
	DiveSliding = false
	vel.Parent = game.ReplicatedStorage
	PlayAnimation("None")
	char:WaitForChild("Animate").Disabled = false
	rootpart:WaitForChild("Landing").Pitch = 1
	char.Humanoid.JumpPower = 50
	char.Humanoid.MaxSlopeAngle = 60
end

function CancelSlide()
	stage = 0
	DiveSlideCanceling = true
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	DiveSpeed = 0
	DiveSliding = false
	vel.Parent = game.ReplicatedStorage
	char:WaitForChild("Animate").Disabled = false
	PlayAnimation("None")
	rootpart:WaitForChild("Landing").Pitch = 1
	char.Humanoid.JumpPower = 50
	char.Humanoid.MaxSlopeAngle = 60
end
stage = 0
jumping = false
falling = false
triplejumping = false
hum = humanoid
-- Jumps --
function onJump(val)
	if canTripleJ.Value ~= false then
	jumping = val
	if jumping == true and stage > 1 and stage < 3 and not LongJumping then
			stage = 3
			char.Animate.Disabled = true
			PlayAnimation("TripleJump")
			triplejumping = true
			char:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,85,0)
			rootpart:WaitForChild("Jumping").Pitch = 2
			rootpart:WaitForChild("Jumping"):Play()
			triplejumping = true
			char.Animate.Disabled = true
	elseif jumping == true and stage >= 1 and stage < 2 and not LongJumping then 
			stage = 2
			rootpart:WaitForChild("Jumping").Pitch = 1.5
			rootpart:WaitForChild("Jumping"):Play()
			char:WaitForChild("Animate").Disabled = true
			char:WaitForChild("HumanoidRootPart").Velocity = Vector3.new(0,65,0)
			PlayAnimation("DoubleJump")
			doublejump = true
    elseif jumping == true and stage < 1 and not LongJumping then 
			stage = 1
			rootpart:WaitForChild("Jumping").Pitch = 1
			rootpart:WaitForChild("Jumping"):Play()
		end
	end
end
hum.Jumping:connect(onJump)
--//Moveset End\\--
canSpin = true
grounded = true
-- Jump Timeout --
function onFall(val)
	falling = val
	if val == false then	--When player lands...
		wait(0.25)			--Next jump times out after .2 seconds.
		if stage > 0 and falling == false then
			stage = 0		--Resets jumps.
		end
	end
end
hum.FreeFalling:connect(onFall)
canGroundPound = true
deb = 1
debagain = 1
--//Binding inputs!\\--
function crouchReal()
	if canCrouch.Value == true and GroundPounding ~= true and LongJumping ~= true and Diving ~= true and WallJumping ~= true and doublejump ~= true then
		Crouching = true
		char.Humanoid.WalkSpeed = 5
		char:WaitForChild("Animate").Disabled = true
		PlayAnimation("Crouching")
	end
end
function uncrouchReal()
	Crouching = false
	char:WaitForChild("Animate").Disabled = false
	char.Humanoid.WalkSpeed = 20
	PlayAnimation("None")
end
function longjumpReal()
	if canLongJump.Value == true and Crouching then
		char:WaitForChild("Animate").Disabled = true
		Crouching = false
		LongJumping = true
		char.Humanoid.Jump = true
		rootpart:WaitForChild("Jumping").Pitch = 1.5
		rootpart:WaitForChild("Jumping"):Play()
		local BodyVelocity = Instance.new("BodyVelocity",char.Torso)
		BodyVelocity.MaxForce = Vector3.new(math.huge,0,math.huge)
		BodyVelocity.Velocity = char.Torso.CFrame.lookVector * 85
		char.Humanoid.WalkSpeed = 20
		PlayAnimation("Longjump")
		game:GetService("Debris"):AddItem(BodyVelocity, .1)
	end
end
local function mobileLongjump(actionName, inputState, inputObject)
	local state = char.Humanoid:GetState()
	if inputState == Enum.UserInputState.Begin and canLongJump.Value == true and state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping and Diving ~= true then
		char:WaitForChild("Animate").Disabled = true
		Crouching = false
		LongJumping = true
		char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		rootpart:WaitForChild("Jumping").Pitch = 1.5
		rootpart:WaitForChild("Jumping"):Play()
		local BodyVelocity = Instance.new("BodyVelocity",char.Torso)
		BodyVelocity.MaxForce = Vector3.new(math.huge,0,math.huge)
		BodyVelocity.Velocity = char.Torso.CFrame.lookVector * 85
		PlayAnimation("Longjump")
		game:GetService("Debris"):AddItem(BodyVelocity, .1)
	end
end
local function groundpound(actionName, inputState, inputObject)
	local state = char.Humanoid:GetState()
	if inputState == Enum.UserInputState.Begin  and canGP.Value == true and LongJumping ~= true and GroundPounding ~= true and Diving ~= true and canGroundPound ~= false and WallJumping ~= true then
		if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
			char:WaitForChild("Animate").Disabled = true
			char.Humanoid.WalkSpeed = 0 
			GroundPounding = true
			canGroundPound = false
			GroundPound()
		end
	end
end
local function dive(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin and canDiveReal.Value == true and GroundPounding ~= true and WallJumping ~= true then
		Dive()
	end
end
local ContextActionService = game:GetService("ContextActionService")
ContextActionService:BindAction("MLongJump", mobileLongjump, true, Enum.KeyCode.F7)
ContextActionService:BindAction("GroundPound", groundpound, true, Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonR2)
ContextActionService:BindAction("Dive", dive, true, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonB)
ContextActionService:SetTitle("GroundPound", "Ground-pound")
ContextActionService:SetTitle("Dive", "Dive")
ContextActionService:SetTitle("MLongJump", "LongJump")
local TouchGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui")
if TouchGui ~= nil then
local jumpbutton = game.Players.LocalPlayer.PlayerGui.TouchGui.TouchControlFrame["JumpButton"]
ContextActionService:SetPosition("MLongJump", jumpbutton.Position-UDim2.new(0,0,0,160))
ContextActionService:SetPosition("Dive", jumpbutton.Position-UDim2.new(0,0,0,120))
ContextActionService:SetPosition("GroundPound", jumpbutton.Position-UDim2.new(0,0,0,80))
end
UIS.InputBegan:connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == CrouchControl then
			crouchReal()
		elseif input.KeyCode == Enum.KeyCode.Space then
			longjumpReal()
		end
	elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonR2 then
			crouchReal()
		elseif input.KeyCode == Enum.KeyCode.ButtonA then
			longjumpReal()
		end
	end
end)
UIS.InputEnded:connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == CrouchControl and GroundPounding ~= true and triplejumping ~= true and doublejump ~= true and Diving ~= true and WallJumping ~= true and LongJumping ~= true then
			uncrouchReal()
		end
	elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonR2 and GroundPounding ~= true and triplejumping ~= true and doublejump ~= true and Diving ~= true and WallJumping ~= true and LongJumping ~= true then
			uncrouchReal()
		end
	end
end)
UIS.JumpRequest:connect(function()
	if DiveSliding and GroundPounding ~= true and WallJumping ~= true then
		CancelSlide()
	end
end)
--//Binding inputs done!\\--
doublejump = false
local Debris = game:GetService("Debris")
--//Landing from a move (dive, longjump, triple jump or double jump, etc)\\--
char.Humanoid.StateChanged:connect(function(old, new)
	if LongJumping and new == Enum.HumanoidStateType.Landed then
		PlayAnimation("None")
		LongJumping = false
		rootpart:WaitForChild("Landing").Pitch = 2
		rootpart:WaitForChild("Landing"):Play()
		char:WaitForChild("Animate").Disabled = false
		wait(0.5)
		rootpart:WaitForChild("Landing").Pitch = 1
	elseif GroundPounding and new == Enum.HumanoidStateType.Landed then
		rootpart:WaitForChild("Landing").Pitch = 1
		hitfloor = true
		PlayAnimation("None")
		char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,1,0)
		canGroundPound = true
		stage = 1
        
	elseif doublejump and new == Enum.HumanoidStateType.Landed then
		triplejumping = false
		doublejump = false
		PlayAnimation("None")
		char:WaitForChild("Animate").Disabled = false
	elseif Diving and old == Enum.HumanoidStateType.Flying then
		Diving = false
		canDive = true
		rootpart:WaitForChild("Landing").Pitch = 0.5
		rootpart:WaitForChild("Landing"):Play()
		char.Humanoid.JumpPower = 0
		DiveSlide()
	elseif triplejumping and old == Enum.HumanoidStateType.Freefall and new == Enum.HumanoidStateType.Landed then
		triplejumping = false
		PlayAnimation("None")
		char:WaitForChild("Animate").Disabled = false
		stage = 0
	elseif DiveSlideCanceling and new == Enum.HumanoidStateType.Landed then
		DiveSlideCanceling = false
		PlayAnimation("None")
		char:WaitForChild("Animate").Disabled = false
	end
end)
--//Effects!\\
function MakeWeld(parent, part0, part1, c0)
	local Weld = Instance.new("Weld",parent)
	Weld.Part0 = part0
	Weld.Part1 = part1
	Weld.C0 = c0
end
walking = false
chara = char
pose = "None"
local speed = 0
char.Humanoid.Running:connect(function(s)
	speed = s
end)
OnSlope = false
coroutine.wrap(function()
	while true do
		wait()
		local vel = char.HumanoidRootPart.Velocity.Y
		local ray = Ray.new(chara.Torso.Position, (chara.Torso.Position - Vector3.new(0,9999999,0)).unit * 300)
		local p, position = game.Workspace:FindPartOnRay(ray, char, true, false)
		local dis = (chara.Torso.Position - position).magnitude
		if dis > 3.8 and chara.Torso.Velocity.Y > 0 then
			pose = "Jumping"
		end
		if dis> 3.8 and chara.Torso.Velocity.Y < 0 then
			pose = "Falling"
		end
		if dis < 3.8 and speed == 0 then
			pose = "Standing"
		end
		if dis < 3.8 and speed > 0 then
			pose = "Walking"
		end
		if p then
			OnSlope = false
			if p.ClassName == "WedgePart" and vel > 0 and char.Humanoid.WalkSpeed > 20 then
				char.Humanoid.WalkSpeed = char.Humanoid.WalkSpeed - 0.3
				OnSlope = true
				if DiveSliding then
					DiveSpeed = DiveSpeed - 2
				end
			elseif p.ClassName == "WedgePart" and vel < 0 then
				if char.Humanoid.WalkSpeed < 30 then
					if DiveSliding then
						if DiveSpeed < 100 then
							DiveSpeed = DiveSpeed + 2
						end
					else
						char.Humanoid.WalkSpeed = char.Humanoid.WalkSpeed + 0.3
					end
					OnSlope = true
				end
			end
		end
	end
end)()
LavaBoosting = false
cananimate = true
CanBoost = false
while wait() do
	if pose == "Standing" and cananimate and LavaBoosting ~= true then
		grounded = true
	end
	if pose == "Walking" and cananimate and DiveSliding ~= true then
		grounded = true
		--wait(0.1)
		--wlkEffect.Attachment["Particle"]:Emit(1)
		--wait(0.1)
		--wlkEffect.Attachment["Particle"]:Emit(1)
	end
	if pose == "Jumping" and cananimate then
		grounded = false
	end
	if pose == "Falling" and cananimate then  
		grounded = false
	end
end
--//Effects done!\\--
