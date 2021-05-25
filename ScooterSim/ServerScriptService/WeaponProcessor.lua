local tweensInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false)
local tweenService = game:GetService("TweenService")

game.ReplicatedStorage.Events.ServerWeapon.OnServerEvent:Connect(function(plr, whatTo, weaponType) -- ScooterType is only used for spawning
	local char = plr.Character
	if whatTo == "Swing" then 
		-- Attaching weapon to the player's hand/arm
		local WeaponFinder = game.ReplicatedStorage.Weapons.models:FindFirstChild(weaponType)
		if WeaponFinder == nil then error("Unable to find model " .. weaponType) return end
		local Weapon = WeaponFinder:Clone()
		local R15 = false
		Weapon.Parent = char
		local weld = Instance.new("Weld", Weapon)
		if char.Humanoid.RigType == Enum.HumanoidRigType.R15 then
			weld.Part0 = char.RightHand
			R15 = true
		elseif char.Humanoid.RigType == Enum.HumanoidRigType.R6 then
			R15 = false
			weld.Part0 = char["Right Arm"]
		end
		
		weld.Part1 = Weapon
		if R15 then
			weld.C0 = Weapon.R15Pos.Value
		else
			weld.C0 = Weapon.R6Pos.Value
		end
		
		-- Damage, swinging, etc
		Weapon.swing:Play()
		
		local weaponstatsFinder = game.ReplicatedStorage.Weapons.stats:FindFirstChild(weaponType)
		
		if weaponstatsFinder == nil then error("Unable to find weapon stats for " .. weaponType) return end
		
		local actualStats = require(weaponstatsFinder)
		
		local used = false
		
		local connection = Weapon.Touched:connect(function(hit)
			local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
			if hum ~= nil and hum.Parent.Name ~= char.Name then
				if used ~= true then
					local chance = math.random(1,actualStats.CritChance)
					if chance == 1 then
						Weapon.crit:Play()
						local critBill = game.ReplicatedStorage.crit:Clone()
						critBill.Parent = hit.Parent.HumanoidRootPart
						critBill.StudsOffset = Vector3.new(0,5,0)
						game:GetService("Debris"):AddItem(critBill, 2)
						local shakescript = script.critBillShake:Clone()
						shakescript.Parent = critBill
						shakescript.Disabled = false
						used = true
						hum:TakeDamage(actualStats.CritDamage)
						hum:ChangeState(Enum.HumanoidStateType.Flying)
						hum.Parent.HumanoidRootPart.Velocity = (char.HumanoidRootPart.CFrame.LookVector * actualStats.CritLaunchPower) + Vector3.new(0,80,0)
						hum.Parent.HumanoidRootPart.RotVelocity = Vector3.new(math.random(1,100), math.random(1,100), math.random(1,100))
						wait(0.45)
						used = false
					else
						Weapon.hit:Play()
						used = true
						hum:TakeDamage(actualStats.BaseDamage)
						wait(0.45)
						used = false
					end
				end
			end
		end)
		
		wait(0.5)
		connection:Disconnect()
		Weapon:Destroy()
	end
end)
