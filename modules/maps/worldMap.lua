--[[	$Id: worldMap.lua 3986 2015-01-26 10:23:06Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.worldmap = caelUI.createModule("WorldMap")

local worldmap = caelUI.worldmap

local kill = caelUI.kill
local dummy = caelUI.dummy
local pixelScale = caelUI.scale

local Player = WorldMapDetailFrame:CreateFontString(nil, "ARTWORK")
Player:SetPoint("BOTTOMLEFT", 5, 25)
Player:SetFont(caelMedia.fonts.ADDON_FONT, 12)
Player:SetTextColor(0.84, 0.75, 0.65)

local Cursor = WorldMapDetailFrame:CreateFontString(nil, "ARTWORK")
Cursor:SetPoint("BOTTOMLEFT", 5, 5)
Cursor:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 12)
Cursor:SetTextColor(0.84, 0.75, 0.65)

local ForceSmallMap = GetCVarBool("miniWorldMap")
if ForceSmallMap == nil then
	SetCVar("miniWorldMap", 1)
end

hooksecurefunc("WorldMap_ToggleSizeDown", function()
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("CENTER", UIParent, 0, 25)
end)

local SetupMap = function(self)

	WorldMapPlayerUpper:EnableMouse(false)
	WorldMapPlayerLower:EnableMouse(false)

	WorldMapButton.timer = 0.1

	WorldMapButton:HookScript("OnUpdate", function(self, elapsed)
		self.timer = self.timer - elapsed
		if self.timer > 0 then
			return
		end

		self.timer = 0.1

		local PlayerX, PlayerY = GetPlayerMapPosition("player")
		Player:SetFormattedText("Player X, Y • %.1f, %.1f", PlayerX * 100, PlayerY * 100)

		local Scale = WorldMapDetailFrame:GetEffectiveScale()
		local Width, Height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()

		local CursorX, CursorY = GetCursorPosition()
		local CenterX, CenterY = WorldMapDetailFrame:GetCenter()

		CursorX = (CursorX / Scale - (CenterX - (Width / 2))) / Width * 100
		CursorY = (CenterY + (Height / 2) - CursorY / Scale) / Height * 100

		if CursorX >= 100 or CursorY >= 100 or CursorX <= 0 or CursorY <= 0 then
			Cursor:SetText("Cursor X, Y • |cffAF5050Out of bounds.|r")
		else
			Cursor:SetFormattedText("Cursor X, Y • %.1f, %.1f", CursorX, CursorY)
		end
	end)

	WorldMapButton:SetScript("OnMouseWheel", function(self, delta)
		if IsModifierKeyDown() then
			local level = GetCurrentMapDungeonLevel() - delta
			if level >= 1 then
				SetDungeonMapLevel(level)
				PlaySound("UChatScrollButton")
			end
		else
			WorldMapScrollFrame_OnMouseWheel(self, delta)
		end
	end)

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function FixMapIcon(unit, size)
	local frame = _G[unit]

	if not frame then
		return
	end

	frame:SetWidth(size)
	frame:SetHeight(size)
end

worldmap:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		SetupMap(self)
		SetupMap = nil

		for index = 1, 4 do
			FixMapIcon(format("WorldMapParty%d", index), pixelScale(24))
			if BattlefieldMinimap then
				FixMapIcon(format("BattlefieldMinimapParty%d", index), pixelScale(10))
			end
		end
		for index = 1, 40 do
			FixMapIcon(format("WorldMapRaid%d", index), pixelScale(24))
			if BattlefieldMinimap then
				FixMapIcon(format("BattlefieldMinimapRaid%d", index), pixelScale(10))
			end
		end
	end
end)

worldmap:RegisterEvent("PLAYER_ENTERING_WORLD")