--[[	$Id: experience.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

if UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then return end

local _, caelDataFeeds = ...

caelDataFeeds.experience = caelDataFeeds.createModule("Experience")

local experience = caelDataFeeds.experience

experience.text:SetPoint("BOTTOM", caelPanel3, "BOTTOM", 0, caelUI.scale(3))
experience.text:SetParent(caelPanel3)
experience:SetFrameStrata("MEDIUM")

experience:RegisterEvent("UNIT_LEVEL")
experience:RegisterEvent("UNIT_EXPERIENCE")
experience:RegisterEvent("PLAYER_XP_UPDATE")
experience:RegisterEvent("PLAYER_ENTERING_WORLD")
experience:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")

local format, find, tonumber = string.format, string.find, tonumber

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local lastXp, a, b = 0
local OnEvent = function(retVal, self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		_, _, lastXp = find(select(1, ...), ".*gain (.*) experience.*")
		lastXp = tonumber(lastXp)
		return
	end
	
	local xp = UnitXP("player")
	local maxXp = UnitXPMax("player")
	local restedXp = GetXPExhaustion()

	experience.text:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 10, "OUTLINE")
	experience.text:SetText(format("|cffD7BEA5xp|r "..(restedXp and "|cffffffff%.1f%%|r |cffD7BEA5-|r |cff5073a0%.1f%%|r" or "|cffffffff%.1f%%|r"), ((xp/maxXp)*1e2), restedXp and ((restedXp/maxXp)*1e2)))

	if retVal then
		return format("|cffD7BEA5Current:|r |cffffffff%s|r |cffD7BEA5Total:|r |cffffffff%s|r", ShortValue(xp), ShortValue(maxXp))
	end
end

experience:SetScript("OnEvent", function(...) OnEvent(false, ...) end)

experience:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, caelUI.scale(4))
	local playerXp = OnEvent(true)

	GameTooltip:AddLine(playerXp)
	GameTooltip:Show()
end)