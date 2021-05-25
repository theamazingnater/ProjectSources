local C = workspace.Noob
local H = C:WaitForChild("Humanoid")
H.HealthChanged:connect(function()
	script.Parent:TweenSize(UDim2.new(1/(H.MaxHealth/math.floor(H.Health + .5)),0,1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce,1)
	script.Parent.Parent.percentage.Text = tostring(math.floor(100/(H.MaxHealth/H.Health)).."%")
end)
