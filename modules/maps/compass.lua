--[[	$Id: compass.lua 3492 2013-08-17 06:21:20Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.compass = caelUI.createModule("Compass")

local compass = caelUI.compass

compass = {}

compass.frame = CreateFrame("Button", nil, Minimap)
compass.frame:EnableMouse(false)
compass.frame:SetSize(Minimap:GetWidth() - 14, 10)
compass.frame:SetPoint("TOP")

compass.graphics = compass.frame:CreateTexture(nil, "ARTWORK")
compass.graphics:SetTexture([[Interface\Addons\caelUI\media\miscellaneous\compass]])
compass.graphics:SetVertexColor(0.84, 0.75, 0.65)

compass.pointer = compass.frame:CreateTexture(nil, "OVERLAY")
compass.pointer:SetTexture([[Interface\Addons\caelUI\media\arrows\arrow-down-active]])
compass.pointer:SetPoint("TOP", 0, 2.5)
compass.pointer:SetVertexColor(0, 0, 0)

local ADJ_FACTOR, DEG_TO_COORD, PI = 1 / math.rad(720), 1 / 1440, math.rad(180)
local timer, adjCoord, currentFacing, interval = 0.1, 270 * DEG_TO_COORD, nil, 0.1

compass.frame:SetScript("OnUpdate", function(self, elapsed)
	timer = timer + elapsed

	if timer < interval then
		return
	end

	timer = 0

	local facing = GetPlayerFacing()

	if facing ~= currentFacing then
		local coord = (facing < PI and 0.5 or 1) - (facing * ADJ_FACTOR)
		compass.graphics.SetTexCoord(compass.graphics, coord - adjCoord, coord + adjCoord, 0.0625, 0.875)
		currentFacing = facing
	end
end)

compass.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
compass.frame:SetScript("OnEvent", function(self)
	compass.graphics:ClearAllPoints()
	compass.graphics:SetAllPoints(compass.frame)

	self:SetScale(Minimap:GetScale())
	self:SetAlpha(Minimap:GetAlpha())
end)