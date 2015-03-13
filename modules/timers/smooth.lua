--[[	$Id: smooth.lua 3492 2013-08-17 06:21:20Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.smoothbars = caelUI.createModule("SmoothBars")

local min, max = math.min, math.max

local smoothBars = {}

local function Smooth(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothBars[self] = value
	else
		smoothBars[self] = nil
	end
end

caelUI.smoothbars:SetScript("OnUpdate", function()
	local rate = GetFramerate()
	local limit = 30/rate
	for bar, value in pairs(smoothBars) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if (not bar:IsShown()) or (cur == value) or ((new < cur) and (abs(new + value) < .1)) or ((new > cur) and abs(new - value) < .1) then
			bar:SetValue_(value)
			smoothBars[bar] = nil
		end
	end
end)

caelUI.SmoothBar = function(bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end