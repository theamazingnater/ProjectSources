-- Changes music, and the tag.
-- Written by Theamazingnater, 2021.

local muslist = {
	"506272814"; -- Iron Blades
	"5172853098"; -- Gothic - Zero Project
	"148285099"; -- Chaoz Fantasy
	"5039086600"; -- Crossroad Times
	"5302951759"; -- Build your Own Game
	"142689201"; -- Explore ROBLOX
	"511269867"; -- Explosive ROBLOX Demo
	"5710714222"; -- Wind of Fjords (Telamon's Sword)
	"5039089122"; -- Training Day
	"5014057599"; -- DJ Glejs - Better Off Alone (Remix)
	"488980937"; -- Solaris - Packet Power (short)
	"6376665950"; -- Daniel Bautista - Flight of the Bumblebee
	"3321761486"; -- Super Smash Bros. Melee - Final Destination (nintendo better not kill me for this)
	"5894815772"; -- S4 League - Come On (Tunnel)
	"5348819299"; -- Nezzera? It's three tracks in one, so...
	"5816105707"; -- Wind of Fjords
	"701690032"; -- Wind of Fjords [Electronic Remix]
}

plr = game.Players.LocalPlayer

while true do
	wait()
	if game.SoundService.MUS.IsPlaying ~= true and plr.Playing.Value == true then
		local tracknumber = math.random(1,#muslist)
		game.SoundService.MUS:Stop()
		script.Parent.Text = "Updating Song Info..."
		game.SoundService.MUS.TimePosition = 0
		game.SoundService.MUS.SoundId = "rbxassetid://" .. muslist[tracknumber]
		game.SoundService.MUS:Play()
	end
end
