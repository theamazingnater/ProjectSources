game.ReplicatedStorage.Events.ServerScooter.OnServerEvent:Connect(function(plr, whatTo, scooterType, playerHit) -- ScooterType is only used for spawning
	local char = plr.Character
	if whatTo == "Summon" then
		local scoot = game.ReplicatedStorage.scooter_ModelTest:Clone()
		scoot.Parent = char
		scoot.Anchored = false
		scoot.Running:Play()
		local w = Instance.new("Weld",char.HumanoidRootPart)
		w.Part0 = char:WaitForChild("HumanoidRootPart")
		w.Part1 = scoot
		w.C0 = CFrame.new(0, -0.750000477, -0.920009613, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		scoot.Spawn:Emit(50)
		scoot.SpawnSFX:Play()
	elseif whatTo == "Remove" then
		local scooter = char:FindFirstChild("scooter_ModelTest")
		if scooter ~= nil then
			scooter:Destroy()
		end
	elseif whatTo == "Slam" then
		local scooter = char:FindFirstChild("scooter_ModelTest")
		if scooter ~= nil then
			-- do funny
			scooter.Slam:Play()
			playerHit.Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
			playerHit.Humanoid.PlatformStand = true
			playerHit.Humanoid:TakeDamage(char.Humanoid.WalkSpeed / 14)
			playerHit.HumanoidRootPart.Velocity = (char.HumanoidRootPart.CFrame.LookVector * char.Humanoid.WalkSpeed) + Vector3.new(0,80,0)
			playerHit.HumanoidRootPart.RotVelocity = Vector3.new(math.random(1,100), math.random(1,100), math.random(1,100))
			wait(5)
			playerHit.Humanoid.PlatformStand = false
		end
	end
end)
