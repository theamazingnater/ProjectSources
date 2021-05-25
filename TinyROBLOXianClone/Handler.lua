-- Rescripted by Theamazingnater

local tool = script.Parent

local reload = 5

function ScaleR6Avatar(model, scale)
	local Motors = {}
	local NewMotors = {}
	
	local Percentage = scale

	for i,v in pairs(model:GetDescendants()) do
		if v:IsA("Motor6D") or v:IsA("Weld") then
			table.insert(Motors, v)
		end
	end

	for i,v in pairs(Motors) do

		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = v.C0:components()
		X = X * Percentage
		Y = Y * Percentage
		Z = Z * Percentage
		R00 = R00 * Percentage
		R01 = R01 * Percentage
		R02 = R02 * Percentage
		R10 = R10 * Percentage
		R11 = R11 * Percentage
		R12 = R12 * Percentage
		R20 = R20 * Percentage
		R21 = R21 * Percentage
		R22 = R22 * Percentage
		v.C0 = CFrame.new(X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)

		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = v.C1:components()
		X = X * Percentage
		Y = Y * Percentage
		Z = Z * Percentage
		R00 = R00 * Percentage
		R01 = R01 * Percentage
		R02 = R02 * Percentage
		R10 = R10 * Percentage
		R11 = R11 * Percentage
		R12 = R12 * Percentage
		R20 = R20 * Percentage
		R21 = R21 * Percentage
		R22 = R22 * Percentage
		v.C1 = CFrame.new(X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)

		table.insert(NewMotors, {v:Clone(), v.Parent})
		v:Destroy()
	end

	for i,v in pairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Size = v.Size * Percentage
		elseif v:IsA("SpecialMesh") then
			v.Scale = v.Scale * Percentage
		end
	end

	for i,v in pairs(NewMotors) do
		v[1].Parent = v[2]
	end

end

function ScaleR15Avatar(model, scale)
	local hum = model:FindFirstChild("Humanoid")
	if hum then
		for i,v in pairs(hum:GetChildren()) do
			if v:IsA("NumberValue") and v.Name ~= "BodyTypeScale" and v.Name ~= "BodyProportionScale" then
				v.Value = scale
			end
		end
	end
end

MiniRegenTime = game.Players.RespawnTime - 3
MiniBloxikinsMax = 4

function CreateMini(character)
	-- Creates a mini version of the player
	-- Check for a bloxmodel in workspace. If it doesn't exist, create one.
	local bloxmodel = game.Workspace:FindFirstChild(character.Name .. "'s Clones")
	if bloxmodel == nil then
		bloxmodel = Instance.new("Model", workspace)
		bloxmodel.Name = character.Name .. "'s Clones"
	end
	-- Get the children and make SURE that there's no more than the max.
	local list = bloxmodel:GetChildren()
	if #list > MiniBloxikinsMax then tool.Handle.fail:Play() tool.Handle.bass:Stop() tool.Handle.use:Stop() print("failed") return end
	character.Archivable = true
	local mini = character:Clone()
	-- Once clone has been made, make sure there is no ForceFields inside them
	for i,v in pairs(mini:GetChildren()) do
		if v:IsA("ForceField") then
			v:Destroy()
		end
	end
	local cf = character.HumanoidRootPart.CFrame + character.HumanoidRootPart.CFrame.lookVector * 4
	mini.HumanoidRootPart.CFrame = cf
	character.Archivable = false
	if character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		-- do r15 scale
		ScaleR15Avatar(mini, 0.3)
	else
		-- do r6 scale
		ScaleR6Avatar(mini, 0.3)
	end
	-- Destroying leftovers from the playermodel
	mini:WaitForChild("Animate"):Destroy()
	mini:WaitForChild("Health"):Destroy()
	-- Configuring humanoid
	mini.Humanoid.WalkSpeed = (character.Humanoid.WalkSpeed + 9) -- Small speed boost so they can catch up to the player easier
	mini.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false) -- Prevent them from climbing. I really don't want to code animations and sound for that.
	-- Setting up AI, and sounds
	local sound = script.MiniCharacterSound:Clone()
	sound.Parent = mini
	sound.Disabled = false
	local ai = script.MiniCharacterAI:Clone()
	ai.ModelToFollow.Value = character
	ai.Parent = mini
	ai.Disabled = false
	-- idk
	mini:FindFirstChild(tool.Name):Destroy()
	local animate = script.MiniCharacterAnimate:Clone()
	-- Get the animation ID's and put them into the script.
	animate.Idling.AnimationId = character.Animate.idle.Animation1.AnimationId
	animate.Running.AnimationId = character.Animate.run.RunAnim.AnimationId
	animate.Falling.AnimationId = character.Animate.fall.FallAnim.AnimationId
	animate.Jump.AnimationId = character.Animate.jump:FindFirstChildOfClass("Animation").AnimationId
	animate.Parent = mini
	animate.Disabled = false
    -- Adding in other scripts
	local damage = script.MiniCharacterDamage:Clone()
	damage.Parent = mini
	damage.Disabled = false
	local regen = script.MiniCharacterHealth:Clone()
	regen.Parent = mini
	regen.Disabled = false
	-- Set up a connection for death "respawn" (even though the bloxikin never respawns)
	mini.Humanoid.Died:connect(function()
		game:GetService("Debris"):AddItem(mini, MiniRegenTime)
	end)
	mini.Parent = bloxmodel
end

tool.Activated:Connect(function()
	if tool.Enabled == false then
		return
	end
	
	local character = tool.Parent
	
	CreateMini(character)
	
	tool.Enabled = false
	
	tool.Handle.use:Play()
	tool.Handle.bass:Play()
	
	tool.Handle.Transparency = 1
	
	wait(reload)
	
	tool.Enabled = true
	
	tool.Handle.Transparency = 0
	
end)
