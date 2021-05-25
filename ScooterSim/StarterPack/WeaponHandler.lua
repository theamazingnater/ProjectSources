-- Handles everything relating to weapons.
local plr = game.Players.LocalPlayer

local char = workspace:WaitForChild(plr.Name, 50)
local hum = char:WaitForChild("Humanoid", 50)
local hrp = char:WaitForChild("HumanoidRootPart", 50)
local mouse = plr:GetMouse()

local canSwing = true

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

local currWeapon = "weapon_linked"

plr.PlayerGui.WeaponSelection.numberselect.Value = "One"

-- Setting up animations
local swingAnim = hum:LoadAnimation(script.Anims["Swing" .. GetMaterialOfPartAsString(hum.RigType)])

mouse.Button1Down:connect(function()
	if canSwing then
		canSwing = false
		game.ReplicatedStorage.Events.ServerWeapon:FireServer("Swing", currWeapon)
		swingAnim:Play()
		wait(0.5)
		canSwing = true
	end
end)

game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameProcessed)
	if gameProcessed then return end
	
	if inputObject.KeyCode == Enum.KeyCode.One then
		currWeapon = "weapon_linked"
		plr.PlayerGui.WeaponSelection.numberselect.Value = "One"
	elseif inputObject.KeyCode == Enum.KeyCode.Two then
		currWeapon = "weapon_bat"
		plr.PlayerGui.WeaponSelection.numberselect.Value = "Two"
	end
end)

