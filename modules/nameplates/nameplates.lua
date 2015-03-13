--[[	$Id: nameplates.lua 3942 2014-10-19 19:19:49Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.nameplates = caelUI.createModule("Nameplates")

local nameplates = caelUI.nameplates

local iconTexture = caelMedia.files.buttonNormal
local raidIcons = caelMedia.files.raidIcons
local overlayTexture = [[Interface\Tooltips\Nameplate-Border]]

local select = select

local barScale
local temp = nil
local index, numChildren = 1, -1
local GetMinMaxValues, WorldFrame = GetMinMaxValues, WorldFrame

local frames, castbarValues = {}, {}

local pixelScale = caelUI.scale

caelUI.activePlates = {}

local UpdatePlateColor = function(self, r, g, b)
--	if caelUI.round(r, 2) == 0.53 and caelUI.round(g, 2) == 0.53 and caelUI.round(b, 2) == 0.53 then
		-- Tapped unit
--		return 1, 0, 0
	if g + b == 0 then
		-- Hostile unit
		return 0.69, 0.31, 0.31
	elseif r + b == 0 then
		-- Friendly unit
		return 0.33, 0.59, 0.33
	elseif r + g == 0 then
		-- Friendly player
		return 0.31, 0.45, 0.63
	elseif 2 - (r + g) < 0.05 and b == 0 then
		-- Neutral unit
		return 0.65, 0.63, 0.35
	else
		-- Hostile player - class colored.
		return r, g, b
	end
end

local UpdatePlate = function(self)
	local oldName = self.oldname:GetText()

--	local tempName = Ambiguate(oldName, "none") -- Remove realm from name
--	local newName = gsub(tempName, " %(%*%)", "") -- Remove (*) from name

	local newName = (string.len(oldName) > 20) and string.gsub(oldName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or oldName -- "%s?(.)%S+%s"

	self.name:SetText(newName)

	self.oldlevel:Hide()

	local level, elite, mylevel = tonumber(self.oldlevel:GetText()), self.elite:IsShown(), UnitLevel("player")

	if not elite and level == mylevel then
		self.level:Hide()
	else
		self.level:Show()

		self.level:SetTextColor(self.oldlevel:GetTextColor())

		if self.boss:IsShown() then
			self.level:SetText("??")
			self.level:SetTextColor(0.8, 0.05, 0)
		else
			self.level:SetText(level and level..(elite and "+" or ""))
		end
	end

	self.castBar.iconOverlay:SetVertexColor(self.healthBar.r, self.healthBar.g, self.healthBar.b)

	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	caelUI.activePlates[self] = true
end

local Frame_OnHide = function(self)
	self.highlight:Hide()
	self.healthGlow:SetBackdropBorderColor(0, 0, 0)

	caelUI.activePlates[self] = nil
end

local HealthBar_OnSizeChanged = function(self)
	if floor(self:GetHeight() + 0.5) ~= pixelScale(8 / barScale) then
		self.healthBar:ClearAllPoints()
		self.healthBar:SetPoint("CENTER", self.healthBar:GetParent())
		self.healthBar:SetSize(pixelScale(100 / barScale), pixelScale(8 / barScale))

		while self:GetEffectiveScale() < 1 do
			self:SetScale(self:GetScale() + 0.01)
		end

		while self:GetEffectiveScale() > 1 do
			self:SetScale(self:GetScale() - 0.01)
		end
	end
end

local ColorCastBar = function(self, shielded)
	if shielded then
		self:SetStatusBarColor(0.8, 0.05, 0)
		self.castGlow:SetBackdropBorderColor(0.75, 0.75, 0.75)
	else
		self.castGlow:SetBackdropBorderColor(0, 0, 0)
	end
end

local Castbar_OnUpdate = function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOM", self.healthBar, "TOP", 0, pixelScale(6.5))

	if floor(self:GetHeight() + 0.5) ~= pixelScale(5) then
		self:SetSize(pixelScale(100), pixelScale(5))

		while self:GetEffectiveScale() < 1 do
			self:SetScale(self:GetScale() + 0.01)
		end

		while self:GetEffectiveScale() > 1 do
			self:SetScale(self:GetScale() - 0.01)
		end
	end
end

local CastBar_OnShow = function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOM", self.healthBar, "TOP", 0, pixelScale(6.5))

	self.text:SetTextColor(0.84, 0.75, 0.65)

	ColorCastBar(self, self.shieldedRegion:IsShown())
	self.iconOverlay:Show()
end

local CastBar_OnValueChanged = function(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	local oldValue = castbarValues[self.frameName]

	if oldValue then
		if curValue < oldValue then -- castbar is depleting -> unit is channeling a spell
			self.time:SetFormattedText("%.1f ", curValue)
		else
			self.time:SetFormattedText("%.1f ", maxValue - curValue)
		end
	end

	castbarValues[self.frameName] = curValue

	ColorCastBar(self, self.shieldedRegion:IsShown())
end

local CreatePlate = function(self, frameName)
	local barFrame, nameFrame = self:GetChildren()
	local healthBar, castBar = barFrame:GetChildren()

	barScale = healthBar:GetScale()

	local glowRegion, overlayRegion, highlightRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = barFrame:GetRegions()
	local _, castbarOverlay, shieldedRegion, spellIconRegion, castTextRegion, castShadowRegion = castBar:GetRegions()
	local nameTextRegion = nameFrame:GetRegions()

	self.oldname = nameTextRegion
	nameTextRegion:Hide()

	local newNameRegion = self:CreateFontString()
	newNameRegion:SetPoint("TOP", healthBar, "BOTTOM", 0, pixelScale(-2 / barScale))
	newNameRegion:SetFont(caelMedia.fonts.NAMEPLATE_FONT, 9)
	newNameRegion:SetTextColor(0.84, 0.75, 0.65)
	newNameRegion:SetShadowOffset(1.25, -1.25)
	self.name = newNameRegion

	self.oldlevel = levelTextRegion

	local newLevelRegion = self:CreateFontString()
	newLevelRegion:SetPoint("RIGHT", healthBar, "LEFT", pixelScale(-2 / barScale), 0)
	newLevelRegion:SetFont(caelMedia.fonts.NAMEPLATE_FONT, 9)
	newLevelRegion:SetShadowOffset(1.25, -1.25)
	self.level = newLevelRegion

	self:HookScript("OnShow", UpdatePlate)
	self:HookScript("OnHide", Frame_OnHide)
	self:HookScript("OnSizeChanged", HealthBar_OnSizeChanged)

	healthBar:ClearAllPoints()
	healthBar:SetPoint("CENTER", healthBar:GetParent())
	healthBar:SetSize(pixelScale(100 / barScale), pixelScale(8 / barScale))
	self.healthBar = healthBar

	healthBar:SetStatusBarTexture(caelMedia.files.statusBarC)

	local healthBackground = healthBar:CreateTexture(nil, "BACKGROUND")
	healthBackground:SetAllPoints()
	healthBackground:SetTexture(caelMedia.files.statusBarC)
	self.healthBackground = healthBackground

	local healthGlow = CreateFrame("Frame", nil, healthBar)
	healthGlow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
	healthGlow:SetPoint("TOPLEFT", pixelScale(-2 / barScale), pixelScale(2 / barScale))
	healthGlow:SetPoint("BOTTOMRIGHT", pixelScale(2 / barScale), pixelScale(-2 / barScale))
	healthGlow:SetBackdrop(caelMedia.backdropTable)
	healthGlow:SetBackdropColor(0, 0, 0, 0)
	healthGlow:SetBackdropBorderColor(0, 0, 0)
	self.healthGlow = healthGlow

	highlightRegion:SetTexture(caelMedia.files.statusBarC)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25)
	self.highlight = highlightRegion

	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar.frameName = frameName
	self.castBar = castBar

	castBar:SetStatusBarTexture(caelMedia.files.statusBarC)

	castBar:HookScript("OnShow", CastBar_OnShow)
	castBar:HookScript("OnUpdate", Castbar_OnUpdate)
	castBar:HookScript("OnValueChanged", CastBar_OnValueChanged)

	local castTime = castBar:CreateFontString(nil, "ARTWORK")
	castTime:SetPoint("RIGHT", castBar, "LEFT", pixelScale(-2), 0)
	castTime:SetFont(caelMedia.fonts.NAMEPLATE_FONT, 9 * UIParent:GetScale())
	castTime:SetTextColor(0.84, 0.75, 0.65)
	castTime:SetShadowOffset(1.25, -1.25)
	castBar.time = castTime

	local castBackground = castBar:CreateTexture(nil, "BACKGROUND")
	castBackground:SetAllPoints()
	castBackground:SetTexture(caelMedia.files.statusBarC)
	castBackground:SetVertexColor(0.25, 0.25, 0.25, 0.75)

	local castGlow = CreateFrame("Frame", nil, castBar)
	castGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)
	castGlow:SetPoint("TOPLEFT", pixelScale(-2), pixelScale(2))
	castGlow:SetPoint("BOTTOMRIGHT", pixelScale(2), pixelScale(-2))
	castGlow:SetBackdrop(caelMedia.backdropTable)
	castGlow:SetBackdropColor(0, 0, 0, 0)
	castGlow:SetBackdropBorderColor(0, 0, 0)
	castBar.castGlow = castGlow

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetPoint("LEFT", castBar, pixelScale(8), 0)
	spellIconRegion:SetSize(pixelScale(15), pixelScale(15))
	spellIconRegion:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	local iconOverlay = castBar:CreateTexture(nil, "OVERLAY", nil, 2) -- 2 sublevels above spellIcon
	iconOverlay:SetPoint("TOPLEFT", spellIconRegion, pixelScale(-1.5), pixelScale(1.5))
	iconOverlay:SetPoint("BOTTOMRIGHT", spellIconRegion, pixelScale(1.5), pixelScale(-1.5))
	iconOverlay:SetTexture(iconTexture)
	castBar.iconOverlay = iconOverlay

	castTextRegion:ClearAllPoints()
	castTextRegion:SetPoint("BOTTOM", castBar, "TOP", 0, pixelScale(4))
	castTextRegion:SetFont(caelMedia.fonts.NAMEPLATE_FONT, 9 * UIParent:GetScale())
	castTextRegion:SetShadowOffset(1.25, -1.25)
	castBar.text = castTextRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("RIGHT", healthBar, pixelScale(-8), 0)
	raidIconRegion:SetSize(pixelScale(15), pixelScale(15))
	raidIconRegion:SetTexture(raidIcons)	

	self.elite = stateIconRegion
	self.boss = bossIconRegion
	self.oldglow = glowRegion

	for _, region in next, {
		glowRegion, overlayRegion, shieldedRegion, castbarOverlay, castShadowRegion, stateIconRegion, bossIconRegion
	} do
		region:SetAlpha(0)
		region:SetTexture(nil)
	end

	UpdatePlate(self)

	frames[self] = true
end

local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local frameName = frame:GetName()

		if (not frames[frame] and frameName and frameName:find("NamePlate%d") ) then
			CreatePlate(frame, frameName)
		end
	end
end

nameplates:SetScript("OnUpdate", function(self, elapsed)
	temp = WorldFrame:GetNumChildren()

	if temp ~= numChildren then
		numChildren = temp
		HookFrames(WorldFrame:GetChildren())
	end

	if self.elapsed and self.elapsed > 0.1 then
		for plate in pairs(caelUI.activePlates) do
			local healthBar = plate.healthBar

			healthBar.r, healthBar.g, healthBar.b = UpdatePlateColor(healthBar, healthBar:GetStatusBarColor())
			healthBar:SetStatusBarColor(healthBar.r, healthBar.g, healthBar.b)
			plate.healthBackground:SetVertexColor(healthBar.r * 0.33, healthBar.g * 0.33, healthBar.b * 0.33, 0.75)
		end

		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

nameplates:SetScript("OnEvent", function(self, event, ...)
	if type(self[event]) == "function" then
		return self[event](self, event, ...)
	end
end)

function nameplates:PLAYER_REGEN_ENABLED()
	SetCVar("nameplateShowEnemies", 0)
end

function nameplates:PLAYER_REGEN_DISABLED()
	SetCVar("nameplateShowEnemies", 1)
end

nameplates:RegisterEvent("ADDON_LOADED")
function nameplates:ADDON_LOADED(event, addon)
	if addon and addon:lower() == "caelui" then
		if not caelNameplatesDB then
			caelNameplatesDB = {autotoggle = true}
		end

		nameplates.settings = caelNameplatesDB

		if nameplates.settings.autotoggle then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end
	end
end

SlashCmdList["caelNameplates"] = function(parameters)
	if parameters == "autotoggle" then
		local newsetting = not nameplates.settings.autotoggle
		nameplates.settings.autotoggle = newsetting

		local func = newsetting and "RegisterEvent" or "UnregisterEvent"

		nameplates[func](nameplates, "PLAYER_REGEN_ENABLED")
		nameplates[func](nameplates, "PLAYER_REGEN_DISABLED")
		print("Auto toggling of nameplates based on combat state " .. (nameplates.settings.autotoggle and "|cff00ff00enabled|r." or "|cffff0000disabled|r."))
	end
end

SLASH_caelNameplates1 = "/nameplates"