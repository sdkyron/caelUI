--[[	$Id: tooltips.lua 3929 2014-05-22 08:02:13Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.tooltips = caelUI.createModule("Tooltips")

local _G = getfenv(0)
local orig1, orig2 = {}, {}
local height, r, g, b
local pixelScale = caelUI.scale

local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]

local gsub, find, format, match, split = string.gsub, string.find, string.format, string.match, string.split

local upgradeLevel = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")

local ScanTip = CreateFrame("GameTooltip", "ScanningTooltip", nil, "GameTooltipTemplate")
ScanTip:SetOwner(UIParent, "ANCHOR_NONE")

_G["GameTooltipHeaderText"]:SetFont(caelMedia.fonts.ADDON_FONT, 10)
_G["GameTooltipText"]:SetFont(caelMedia.fonts.ADDON_FONT, 10)
_G["GameTooltipTextSmall"]:SetFont(caelMedia.fonts.ADDON_FONT, 9)

local Tooltips = {
	ConsolidatedBuffsTooltip,
	FriendsTooltip,
	GameTooltip,
	ItemRefTooltip,
	ItemRefShoppingTooltip1,
	ItemRefShoppingTooltip2,
	ItemRefShoppingTooltip3,
	ShoppingTooltip1,
	ShoppingTooltip2,
	ShoppingTooltip3,
	WorldMapTooltip,
	WorldMapCompareTooltip1,
	WorldMapCompareTooltip2,
	WorldMapCompareTooltip3,
}

local linkTypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true, instancelock = true}

local classification = {
	worldboss = "",
	rareelite = "|cffAF5050+ Rare|r",
	elite = "|cffAF5050+|r",
	rare = "|cffAF5050Rare|r",
}

local OnHyperlinkEnter = function(frame, link, ...)
	local linkType = link:match("^([^:]+)")
	if linkType and linkTypes[linkType] then
		GameTooltip:SetOwner(frame, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOM", caelPanel1, "TOP", 0, pixelScale(26))
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end

	if orig1[frame] then return orig1[frame](frame, link, ...) end
end

local OnHyperlinkLeave = function(frame, ...)
	GameTooltip:Hide()
	if orig2[frame] then return orig2[frame](frame, ...) end
end

for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	orig1[frame] = frame:GetScript("OnHyperlinkEnter")
	frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

	orig2[frame] = frame:GetScript("OnHyperlinkLeave")
	frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end

local GetItemUpgradeLevel = function(link)
	ScanTip:ClearLines()
	ScanTip:SetHyperlink(link)

	for i = 2, ScanTip:NumLines() do
		local text = _G["ScanningTooltipTextLeft"..i]:GetText()
		if text and text ~= "" then
			local currentUpgradeLevel, maxUpgradeLevel = match(text, upgradeLevel)
			if currentUpgradeLevel then
				return currentUpgradeLevel, maxUpgradeLevel
			end
		end
	end
end

local FormatMoney = function(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)

	if gold ~= 0 then
		return format("%s|cffffd700g|r %s|cffc7c7cfs|r %s|cffeda55fc|r", gold, silver, copper)
	elseif silver ~= 0 then
		return format("%s|cffc7c7cfs|r %s|cffeda55fc|r", silver, copper)
	else
		return format("%s|cffeda55fc|r", copper)
	end
end

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11, UnitBuff(...))
	if id then
		self:AddLine(format("|cffD7BEA5SpellID: %s", id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11, UnitDebuff(...))
	if id then
		self:AddLine(format("|cffD7BEA5SpellID: %s", id))
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11, UnitAura(...))
	if id then
		self:AddLine(format("|cffD7BEA5SpellID: %s", id))
		self:Show()
	end
end)

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
	if string.find(link, "^spell:") then
		local id = string.sub(link, 7)
		ItemRefTooltip:AddLine(format("|cffD7BEA5SpellID: %s", id))
		ItemRefTooltip:Show()
	end
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	local frame = GetMouseFocus() and GetMouseFocus():GetName() or ""

	if frame and (frame:match("oUF_Caellian_Party.*") or frame:match("oUF_Caellian_Raid.*")) then
		self:SetOwner(parent, "ANCHOR_BOTTOMRIGHT")

		if UnitAffectingCombat("player") then
			self:Hide()
		end
	elseif frame and frame:match("Button%d") then
		self:SetOwner(parent, "ANCHOR_TOP")
	else
		self:SetOwner(parent, "ANCHOR_NONE")
		self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", pixelScale(-5), pixelScale(170))
	end

	self.default = 1
end)

GameTooltip_UnitColor = function(unit)
	if not unit then unit = "mouseover" end

	local reaction = unit and UnitReaction(unit, "player")

	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)

		r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) and not UnitIsTappedByAllThreatList(unit) or UnitIsDead(unit) then
		r, g, b = 0.55, 0.57, 0.61
	elseif reaction then
		r, g, b = FACTION_BAR_COLORS[reaction].r, FACTION_BAR_COLORS[reaction].g, FACTION_BAR_COLORS[reaction].b
	else
		r, g, b = UnitSelectionColor(unit)
	end

	return r, g, b
end

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	for i = 1, 2 do
		if _G["GameTooltipMoneyFrame"..i] then
			_G["GameTooltipMoneyFrame"..i]:Hide()
		end
	end

	local _, link = self:GetItem()

	if link then
		local id = tonumber(link:match("item:(%-?%d+)"))
		local _, _, _, level, _, itemType, subType, stack = GetItemInfo(link)

		if level then
			local currentUpgradeLevel, maxUpgradeLevel = GetItemUpgradeLevel(link)

			local typeText = itemType and subType and format("Type: %s - %s", itemType, subType) or nil
			r, g, b = 0.84, 0.75, 0.65

			if currentUpgradeLevel and maxUpgradeLevel then
				local levelGain = tonumber(currentUpgradeLevel) == 0 and 0 or tonumber(currentUpgradeLevel) == 1 and 4 or tonumber(currentUpgradeLevel) == 2 and 8 or tonumber(currentUpgradeLevel) == 3 and 12 or tonumber(currentUpgradeLevel) == 4 and 16

				local iLevel = format("%s (%s/%s)", level + levelGain, currentUpgradeLevel, maxUpgradeLevel)

				self:AddDoubleLine("iLevel: "..iLevel, "ItemID: "..id, r, g, b, r, g, b)
			else
				self:AddDoubleLine("iLevel: "..level, "ItemID: "..id, r, g, b, r, g, b)
			end

			if stack ~= 1 then
				self:AddDoubleLine(typeText, "Stacks to: "..stack, r, g, b, r, g, b)
			else
				self:AddLine(typeText, r, g, b)
				self:AddLine(" ")
			end

			self:Show()
		end
	end
end)

ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
	for i = 1, 2 do
		if _G["ItemRefTooltipMoneyFrame"..i] then
			_G["ItemRefTooltipMoneyFrame"..i]:Hide()
		end
	end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local lines = self:NumLines()

	local _, unit = self:GetUnit()

	if not unit then
		unit = GetMouseFocus() and GetMouseFocus().unit or "mouseover"
	end

	local level

	if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
		level = UnitBattlePetLevel(unit)
	else
		level = UnitLevel(unit)
	end

	local classify = UnitClassification(unit)
	r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b

	if level == -1 then
		if classify == "worldboss" then
			level = "|cffAF5050"..ENCOUNTER_JOURNAL_ENCOUNTER.."|r"
		else
			level = "|cffAF5050??|r"
		end
	end

	if UnitIsPlayer(unit) then
		local name, realm = UnitName(unit)
		local race = UnitRace(unit)
		local guild = GetGuildInfo(unit)
		local relationship = UnitRealmRelationship(unit)

		if realm and realm ~= "" then
			if IsShiftKeyDown() then
				name = name.."-"..realm
			elseif relationship == LE_REALM_RELATION_COALESCED then
				name = name..FOREIGN_SERVER_LABEL
			elseif relationship == LE_REALM_RELATION_VIRTUAL then
				name = name..INTERACTIVE_SERVER_LABEL
			end
		end

		_G["GameTooltipTextLeft1"]:SetFormattedText("%s", name)

		local status = UnitIsAFK(unit) and CHAT_FLAG_AFK or UnitIsDND(unit) and CHAT_FLAG_DND or not UnitIsConnected(unit) and "<DC>"

		if status then
			self:AppendText(("|cff559655 %s|r"):format(status))
		end

		if guild then
			_G["GameTooltipTextLeft2"]:SetFormattedText("%s", IsInGuild() and GetGuildInfo("player") == guild and "|cff5073A0« "..guild.." »|r" or "|cff559655« "..guild.." »|r")
		end

		for i = guild and 3 or 2, lines do
			local line = _G["GameTooltipTextLeft"..i]

			if line:GetText():find(LEVEL) then
				line:SetFormattedText("|cff%02x%02x%02x%s|r %s", r * 255, g * 255, b * 255, level, race)
			end
		end
	else
		local creature = UnitCreatureType(unit)

		for i = 2, lines do
			local line = _G["GameTooltipTextLeft"..i]

			if (level and line:GetText():find(LEVEL)) or (creature and line:GetText():find(creature)) then
				line:SetFormattedText("|cff%02x%02x%02x%s|r%s %s", r * 255, g * 255, b * 255, level ~= 0 and level or "", classification[classify] or "", creature or "")
			end
		end
	end

	if UnitExists(unit.."target") then
		r, g, b = 0.33, 0.59, 0.33
		local text = ""

		if UnitIsEnemy("player", unit.."target") then
			r, g, b = 0.69, 0.31, 0.31
		elseif not UnitIsFriend("player", unit.."target") then
			r, g, b = 0.65, 0.63, 0.35
		end

		if UnitName(unit.."target") == UnitName("player") then
			text = "You"
		else
			text = UnitName(unit.."target")
		end

		local tarIcon = GetRaidTargetIndex(unit.."target")
		local tarText = ("%s %s"):format((tarIcon and ICON_LIST[tarIcon].."10|t") or "", text)

		self:AddDoubleLine("|cffD7BEA5Target:|r ", tarText, nil, nil, nil, r, g, b)
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local name = self:GetOwner():GetName()

	if name and name:match("PlayerTalentFrameTalentsTalentRow%dTalent%d") then
		return
	end

	local id = select(3, self:GetSpell())

	if id then
		self:AddLine(format("|cffD7BEA5SpellID: %s", id))
		self:Show()
	end
end)

GameTooltip:HookScript("OnTooltipAddMoney", function(self, cost, maxcost)
	self:AddLine("Value: "..FormatMoney(cost), 0.84, 0.75, 0.65)
end)

local healthBar = GameTooltipStatusBar
healthBar:ClearAllPoints()
healthBar:SetHeight(pixelScale(5))
healthBar:SetPoint("TOPLEFT", healthBar:GetParent(), pixelScale(2), pixelScale(-2))
healthBar:SetPoint("TOPRIGHT", healthBar:GetParent(), pixelScale(-2), pixelScale(-2))
healthBar:SetStatusBarTexture(caelMedia.files.statusBarC)

healthBar.bg = healthBar:CreateTexture(nil, "BORDER")
healthBar.bg:SetAllPoints()
healthBar.bg:SetTexture(caelMedia.files.statusBarC)

GameTooltipStatusBar:SetScript("OnValueChanged", function(self)
	local _, unit = GameTooltip:GetUnit()
	r, g, b = GameTooltip_UnitColor(unit)

	self:SetStatusBarColor(r, g, b)
end)

local BorderColor = function(self)
	if self.GetItem then
		local _, link = self:GetItem()
		local quality = link and select(3, GetItemInfo(link))

		if quality and quality >= 2 then			r, g, b = GetItemQualityColor(quality)

			self:SetBackdropBorderColor(r, g, b)
		else
			self:SetBackdropBorderColor(0, 0, 0)
		end
	else
		self:SetBackdropBorderColor(0, 0, 0)
	end
end

local SetStyle = function(self)
	self:SetSize(pixelScale(self:GetWidth()), pixelScale(self:GetHeight()))

	self:SetScale(0.9)

	height = pixelScale(self:GetHeight() / 6)

	local gradientTop = GameTooltip:CreateTexture(nil, "BORDER")
	gradientTop:SetTexture(caelMedia.files.bgFile)
	gradientTop:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0.84, 0.75, 0.65, 0.5)

	local gradientBottom = GameTooltip:CreateTexture(nil, "BORDER")
	gradientBottom:SetTexture(caelMedia.files.bgFile)
	gradientBottom:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.75, 0, 0, 0, 0)

	if not self.styled then
		self:SetBackdrop(caelMedia.backdropTable)

		gradientTop:SetParent(self)
		gradientTop:SetPoint("TOPLEFT", pixelScale(2), pixelScale(-2))
		gradientTop:SetPoint("TOPRIGHT", pixelScale(-2), pixelScale(-2))
		gradientTop:SetHeight(height)

		gradientBottom:SetParent(self)
		gradientBottom:SetPoint("BOTTOMLEFT", pixelScale(2), pixelScale(2))
		gradientBottom:SetPoint("BOTTOMRIGHT", pixelScale(-2), pixelScale(2))
		gradientBottom:SetHeight(height)

		self:SetBackdropColor(0, 0, 0, GetMouseFocus() == WorldFrame and 0.33 or 0.66)

		self.styled = true
	end

	r, g, b = healthBar:GetStatusBarColor()
	healthBar.bg:SetVertexColor(r * 0.33, g * 0.33, b * 0.33, 0.85)

	BorderColor(self)
end

local hiddenLines = {
	caelUI.pattern(ITEM_CREATED_BY),
	caelUI.pattern(ITEM_LEVEL),
	caelUI.pattern(ITEM_UPGRADE_TOOLTIP_FORMAT),
	caelUI.pattern(FACTION_ALLIANCE),
	caelUI.pattern(FACTION_HORDE),
	caelUI.pattern(PVP_ENABLED),
}

local COALESCED_REALM_TOOLTIP1 = string.split(FOREIGN_SERVER_LABEL, COALESCED_REALM_TOOLTIP)
local INTERACTIVE_REALM_TOOLTIP1 = string.split(INTERACTIVE_SERVER_LABEL, INTERACTIVE_REALM_TOOLTIP)

local HideLines = function(self)
	for i = 2, self:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		local prevLine = _G["GameTooltipTextLeft"..(i - 1)]

		local text = line:GetText()

		if text then
			for i = 1, #hiddenLines do
				if text:match(hiddenLines[i]) then
					line:SetText()
					line:Hide()

					self:Show()
				end
			end

			if text == " " and prevLine == " " then
				prevLine:SetText()
				prevLine:Hide()

				self:Show()
			elseif text:match(COALESCED_REALM_TOOLTIP1) or text:match(INTERACTIVE_REALM_TOOLTIP1) then
				line:SetText()
				line:Hide()
				prevLine:Hide()

				self:Show()
			end
		end
	end
end

local FormatLines = function(self)
	for i = 1, self:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		local _, _, _, xOfs, yOfs = line:GetPoint()

		line:ClearAllPoints()

		if i == 1 then
			line:SetPoint("TOPLEFT", pixelScale(xOfs), pixelScale(yOfs))
		else
			local key = i - 1

			while true do
				local prevLine = _G["GameTooltipTextLeft"..key]

				if prevLine and not prevLine:IsShown() then
					key = key - 1
				else
					break
				end
			end

			line:SetPoint("TOPLEFT", _G["GameTooltipTextLeft"..key], "BOTTOMLEFT", pixelScale(xOfs), pixelScale(-2))
		end
	end
end

local delay = 0
GameTooltip:HookScript("OnUpdate", function(self, elapsed)
	delay = delay + elapsed

	if delay < 0.1 then
		return
	else
		HideLines(self)
		FormatLines(self)

		self:SetBackdropColor(0, 0, 0, GetMouseFocus() == WorldFrame and 0.33 or 0.66)
	end
end)

caelUI.tooltips:RegisterEvent("PLAYER_ENTERING_WORLD")
caelUI.tooltips:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		for _, tooltip in ipairs(Tooltips) do
			tooltip:HookScript("OnShow", SetStyle)
		end

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:SetScript("OnEvent", nil)
	end
end)