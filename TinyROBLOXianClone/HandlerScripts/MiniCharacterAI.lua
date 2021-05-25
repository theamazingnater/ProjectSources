-- Follows the character.
local figure = script.Parent
local modeltofollow = script.ModelToFollow

local dead = false

function Die()
	-- Kill the mini robloxian
	figure.Humanoid.Health = 0
	-- By the way, respawn is now handled by the Handler script inside the tool.
end

local RangeUntilTP = 42
local timeUntilAttackCancel = 8 -- 8 seconds until the attack is cancelled (to prevent the figure from getting stuck)
local ATKRange = 32

function CanAttackPlayer(player)
	if player.Name ~= modeltofollow.Value.Name and player.Character ~= nil and player.Character.Humanoid.Health > 0 then
		return true
	end
	return false
end

function GetANearbyPlayer()
	-- Iterates through a list of the players, and checks if they're nearby. If they are, then return that player's character.
	local list = game.Players:GetPlayers()
	for i,v in pairs(list) do
		-- Make sure the character isn't nil.
		if v.Character ~= nil then
			-- Now check distance.
			local dis = (figure.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
			if dis < ATKRange then
				-- Check if we can even attack this player.
				if CanAttackPlayer(v) == true then
					return v.Character
				end
			end
		end
	end
	return nil
end

local atktimer = 0

coroutine.wrap(function()
	while true do
		-- timer
		wait(1)
		if script.AttemptingAttack.Value == true then
			atktimer += 1
		end
	end
end)()

while true do
	wait()
	if modeltofollow.Value ~= nil and figure:FindFirstChildOfClass("Humanoid").Health > 0 then
		local model = modeltofollow.Value
		local cf = model.HumanoidRootPart.CFrame + model.HumanoidRootPart.CFrame.lookVector * -4
		local vc = cf.p
		if script.AttemptingAttack.Value == false then
			figure.Humanoid:MoveTo(vc)
		end
		if model.Humanoid.Jump == true then
			wait(math.random(0, 0.2))
			figure.Humanoid.Jump = true
		end
		-- If player dies...
		if model.Humanoid.Health <= 0 then
			if figure.Humanoid.Health > 0 then -- This is here to prevent the function from firing 5 billon times.
				Die()
			end
		end
		-- If the player gets too far away...
		local magnitude = (figure.HumanoidRootPart.Position - model.HumanoidRootPart.Position).magnitude
		if magnitude > RangeUntilTP then
			-- Try to teleport them away... UNLESS they're trying to attack something, in that case, don't do anything until the target dies.
			if script.AttemptingAttack.Value == false then
				-- Immediately teleport the mini boy over to the player.
				figure:MoveTo(vc)
				print("Got too far away!")
			end
		end
		
		-- Attacking
		-- Look for nearby targets, such as players.
		local nearbyplayer = GetANearbyPlayer()
		if nearbyplayer ~= nil then
			if script.AttackTarget.Value == nil then
				-- Set the target to them
				print("Found target")
				script.AttackTarget.Value = nearbyplayer
				script.AttemptingAttack.Value = true
				local sword = figure:FindFirstChild("MiniSword")
				if sword == nil then
					sword = game.ReplicatedStorage.MiniSword:Clone()
					sword.Parent = figure
				end
			end
		end
		
		if script.AttemptingAttack.Value == true then
			if atktimer > timeUntilAttackCancel then
				-- Cancel attack
				figure:MoveTo(vc)
				script.AttackTarget.Value = nil
				script.AttemptingAttack.Value = false
				atktimer = 0
				local sword = figure:FindFirstChild("MiniSword")
				if sword ~= nil then
					sword:Destroy()
				end
			end
			-- But if it hasn't, then move towards the target's position
			if script.AttackTarget.Value ~= nil then -- just to be safe
				figure.Humanoid:MoveTo(script.AttackTarget.Value.HumanoidRootPart.Position)
				if script.AttackTarget.Value.Humanoid.Health <= 0 then
					-- Cancel attack
					figure:MoveTo(vc)
					script.AttackTarget.Value = nil
					script.AttemptingAttack.Value = false
					atktimer = 0
					local sword = figure:FindFirstChild("MiniSword")
					if sword ~= nil then
						sword:Destroy()
					end
				end
			end
		end
	end
end
