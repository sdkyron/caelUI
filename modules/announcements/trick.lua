--[[	$Id: trick.lua 3528 2013-08-24 06:06:44Z sdkyron@gmail.com $	]]

if caelUI.playerClass ~= "ROGUE" then return end

local _, caelUI = ...

caelUI.trick = caelUI.createModule("Trick")

local locale = GetLocale()

local msgChannel = locale == "frFR" and "Ficelles sur " or "Tricks on "

local textColor = {r = 0.84, g = 0.75, b = 0.65}

caelUI.trick:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
caelUI.trick:SetScript("OnEvent", function(_, _, _, subEvent, _, _, sourceName, _, _, _, destName, _, _, spellId, _, _, amount, ...)

	if sourceName and sourceName == UnitName("player") then
		if UnitIsPlayer(destName) and not UnitIsUnit(destName, "pet") then
			if subEvent == "SPELL_CAST_SUCCESS" then
				if  spellId == 57934 then
--					SendChatMessage((msgWhisper), "WHISPER", GetDefaultLanguage("player"), destName)
					RaidNotice_AddMessage(RaidWarningFrame, msgChannel..destName, textColor)

				end
			end
		end
	end
end)