local MarketplaceService = game:GetService("MarketplaceService")

game.SoundService.Music.Changed:Connect(function(property)
	-- The property variable is what was changed
	if property == "SoundId" then
		script.Parent.SongInfo.Text = "mining diaaaaamoooonds"
		local id = game.SoundService.Music.SoundId:sub(14)
		local asset = MarketplaceService:GetProductInfo(id)
		script.Parent.SongInfo.Text = asset.Name
	end
end)

script.Parent.SongInfo.Text = "Loading Song Info..."
local id = game.SoundService.Music.SoundId:sub(14)
local asset = MarketplaceService:GetProductInfo(id)
script.Parent.SongInfo.Text = asset.Name

-- Mute
local muted = false

script.Parent.mute.MouseButton1Click:Connect(function()
	if muted == false then
		muted = true
	else
		muted = false
		game.SoundService.Music.Volume = 0.3
	end
end)

while true do
	wait()
	if muted then
		script.Parent.speaker.Image = "rbxassetid://6450527160"
		game.SoundService.Music.Volume = 0
	else
		script.Parent.speaker.Image = "rbxassetid://166377448"
	end
end
