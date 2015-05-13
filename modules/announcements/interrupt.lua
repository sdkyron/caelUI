--[[	$Id: interrupt.lua 3528 2013-08-24 06:06:44Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.interrupt = caelUI.createModule("Interrupt")

local playerGUID = nil
local msg = "%s: %s (%s)"
local emo = GetLocale() == "frFR" and "a interrompu %s. (%s)" or "interrupted %s. (%s)"
local grouped = nil
local lastTimestamp = nil
local lastInterrupted = nil

caelUI.interrupt:RegisterEvent("PLAYER_LOGIN")
caelUI.interrupt:RegisterEvent("GROUP_ROSTER_UPDATE")
caelUI.interrupt:SetScript("OnEvent", function(self, event, timestamp, subEvent, _, sourceGUID, _, _, _, _, destName, _, _, _, spellName, _, extraSpellID, extraSpellName)

	if tostring(GetZoneText()) == "Wintergrasp" or tostring(GetZoneText()) == "Tol Barad" or QueueStatusMinimapButton.status == "active" then return end

	if event == "GROUP_ROSTER_UPDATE" then
		local numGroup = GetNumGroupMembers()
		if not grouped and numGroup > 0 then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			grouped = true
		elseif grouped and numGroup == 0 then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			grouped = nil
		end
	elseif event == "PLAYER_LOGIN" then
		playerGUID = UnitGUID("player")
	else
		if subEvent == "SPELL_INTERRUPT" and sourceGUID == playerGUID then
			if timestamp ~= lastTimestamp or extraSpellName ~= lastInterrupted then
				lastTimestamp = timestamp
				lastInterrupted = extraSpellName

				local dstName = format(destName:gsub("%-[^|]+", ""))
				local shortDestName = (string.len(dstName) > 12) and string.gsub(dstName, "%s?(.[\128-\191]*)%S+%s", "%1. ") or dstName
				local emote = emo:format(GetSpellLink(extraSpellID), caelUI.utf8sub(shortDestName, 12, true))
				SendChatMessage(emote, "EMOTE", GetDefaultLanguage("player"))
			end
		end
	end
end)