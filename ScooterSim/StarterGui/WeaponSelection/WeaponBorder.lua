local weaponselect = script.Parent.numberselect

weaponselect.Changed:Connect(function(value)
	local actualValue = string.lower(value)
	local weaponportrait = script.Parent:FindFirstChild(actualValue)
	
	if weaponportrait ~= nil then
		weaponportrait.BorderSizePixel = 4
		for i,v in pairs(script.Parent:GetChildren()) do
			if v.Name ~= weaponportrait.Name and v:IsA("Frame") then
				v.BorderSizePixel = 0
			end
		end
	end
end)
