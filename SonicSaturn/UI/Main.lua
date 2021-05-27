ScoreUI = script.Parent.Score
TimeUI = script.Parent.Time
RingsUI = script.Parent.Rings

Rings = script.Rings
Score = script.Score
Time = script.Time

plr = game.Players.LocalPlayer
repeat wait() until plr.Character ~= nil

char = plr.Character

coroutine.wrap(function()
	while true do
		local minute = tostring(math.floor(Time.Value/60))
		local sec = math.floor(Time.Value%60)
		if sec < 10 then
			sec = "0".. tostring(math.floor(Time.Value%60))
		end
		TimeUI.TimeCount.Text = minute .. ":" .. sec
		wait(1)
		Time.Value = Time.Value + 1
	end
end)()

while true do
	wait()
	RingsUI.RingsCount.Text = tostring(Rings.Value)
	ScoreUI.ScoreCount.Text = tostring(Score.Value)
end
