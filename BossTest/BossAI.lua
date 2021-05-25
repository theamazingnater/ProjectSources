-- Giant Noob Boss by Theamazingnater
-- Enjoy!

-- bro this stuff is so old

char = script.Parent
idle = char.Humanoid:LoadAnimation(char.Idle)
slam = char.Humanoid:LoadAnimation(char.Slam)
hurt = char.Humanoid:LoadAnimation(char.Hurt)
attacking = false
Music = char.Music
local Boom = Instance.new("Sound",char)
Boom.SoundId = "rbxassetid://315775189"
Boom.Volume = 10

local currTarget = nil

function GetTarget()
	-- Find a random player using some stuff. Used to figure out what target to target. Simple.
	local plrlist = game.Players:GetPlayers()
    local randomNumb = math.random(0, #plrlist)
    currTarget = plrlist[randomNumb]
end

function intro()
	attacking = true
	wait()
	slam:Play()
	wait(1)
	char.Head.face.Texture = "http://www.roblox.com/asset/?id=1334264335"
	wait(2)
	Music:Play()
	Music.Looped = true
	idle:Play()
	attacking = false
end

intro()

Mesh = function(MeshType, Parent, MeshId, TextureId)
	local mesh = Instance.new(MeshType,Parent)
	mesh.MeshId = MeshId
	mesh.TextureId = TextureId
end

function slam2()
	attacking = true
	idle:Stop()
	wait()
	slam:Play()
	repeat wait() until slam.IsPlaying ~= true 
	idle:Play()
	Boom:Play()
	local ring = Instance.new("Part",workspace)
    ring.CFrame = char["Right Arm"].CFrame +  Vector3.new(0,-5,0)
    ring.CanCollide = false
    ring.Anchored = true
    ring.Orientation = Vector3.new(89.54, -90, 180)
    Mesh("FileMesh",ring,"http://www.roblox.com/asset/?id=3270017", "rbxassetid://0")
     ring.Touched:connect(function(part)
        local human = part.Parent:FindFirstChildOfClass("Humanoid")
        if human and human.Parent.Name ~= char.Name then
            human.Health = human.Health - 10
        end
    end)
    for i = 1,100 do
        wait()
        ring.Size = ring.Size + Vector3.new(1,1,1)
        ring.Mesh.Scale = ring.Mesh.Scale + Vector3.new(1,1,1)
    end
    ring:Destroy()
    idle:Play()
    attacking = false
end

hit = false


char.Head.Touched:connect(function(p)
	local human = p.Parent:FindFirstChildOfClass("Humanoid")
	if human and not hit and human.Parent.Name ~= char.Name then
		hit = true
		attacking = true
		char.Humanoid:TakeDamage(10)
		idle:Stop()
		hurt:Play()
		char.Head.face.Texture = "http://www.roblox.com/asset/?id=1615189031"
		local position = Instance.new("BodyPosition",human.Parent.Head)
		position.Position = workspace.p1.Position
		wait(2)
		position.Position = workspace.p2.Position
		wait(1)
		position:Destroy()
		char.Head.face.Texture = "http://www.roblox.com/asset/?id=1334264335"
		hit = false
		attacking = false
		slam2()
	end
end)

coroutine.wrap(function()
	while true do
		wait()
		if char.Humanoid.Health < 1 then
			char.Head.face.Texture = "http://www.roblox.com/asset/?id=546029421"
			attacking = true
			char.Head.Anchored = true
			char.HumanoidRootPart.Anchored = true
			char.Torso.Anchored = true
			char["Left Arm"].Anchored = true
			char["Right Arm"].Anchored = true
			char["Right Leg"].Anchored = true
			char["Left Leg"].Anchored = true
			wait(2)
			char.Torso.ParticleEmitter.Enabled = true
			wait(3)
			char:Destroy()
			break
		end
	end
end)()


while true do
	wait(5.5)
	if attacking == false then
		slam2()
	end
end
