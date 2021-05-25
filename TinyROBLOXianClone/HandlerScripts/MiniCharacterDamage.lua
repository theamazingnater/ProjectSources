local figure = script.Parent
local humanoid = figure.Humanoid

local BloxikinDamage = 15
local CooldownsBetweenDamage = 0.2

function canDamagePlayer(player)
	if player.Name ~= figure.Name and player.Humanoid.Health > 0 and player ~= nil then
		return true
	end
	return false
end

function tagHumanoid(humanoid, player)
	local creator_tag = Instance.new("ObjectValue")
	creator_tag.Value = player
	creator_tag.Name = "creator"
	creator_tag.Parent = humanoid
end

function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:findFirstChild("creator")
		if tag ~= nil then
			tag.Parent = nil
		end
	end
end

used = false

-- Set up a touched connection
local connection = humanoid.Touched:connect(function(hit)
	local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
	if hum ~= nil and used ~= true then
		if canDamagePlayer(hum.Parent) == true then
			hum:TakeDamage(BloxikinDamage)
			tagHumanoid(hum, game.Players:FindFirstChild(figure.Name))
			used = true
			wait(CooldownsBetweenDamage)
			used = false
			wait(1 - CooldownsBetweenDamage)
			untagHumanoid(hum)
		end
	end
end)
