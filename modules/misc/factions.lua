--[[	$Id: factions.lua 3536 2013-08-24 16:19:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.faction = caelUI.createModule("Faction")

local find = string.find

local factionName, factionValue
local standings = {}

local factionIncrease = FACTION_STANDING_INCREASED:gsub("%%s", "(.-)"):gsub("%%d", "(%%d+)")
local factionDecrease = FACTION_STANDING_DECREASED:gsub("%%s", "(.-)"):gsub("%%d", "(%%d+)")

local watchFaction = function(factionName, factionValue, increase)
	local current = GetWatchedFactionInfo()
	
	for i = 1, GetNumFactions() do
		local name, _, standingID, _, barMax, barValue, _, _, isHeader, _, _, _, isChild = GetFactionInfo(i)
		local repToGo = barMax - barValue
		local isGuild = false
		
		if name == factionName then
			if (isHeader and not isChild) and GetFactionInfo(i + 1) == GetGuildInfo("player") then
				name, _, standingID, _, barMax, barValue = GetFactionInfo(i + 1)
				repToGo = barMax - barValue
				isGuild = true
			end
			
			if name ~= current then
				SetWatchedFactionIndex(isGuild and i + 1 or i)
			end

			if StandingID == 8 and repToGo == 1 then
				SetFactionInactive(isGuild and i + 1 or i)
			else
				if increase then
					print(string.format("|cffD7BEA5cael|rFaction: %s: |cff559655%s%d|r (%d to |cff%02x%02x%02x%s|r)", name, "+", factionValue, repToGo, FACTION_BAR_COLORS[standingID].r * 255, FACTION_BAR_COLORS[standingID].g * 255, FACTION_BAR_COLORS[standingID].b * 255,(standingID < 8 and standings[standingID + 1] or "cap")))
				else
					print(string.format("|cffD7BEA5cael|rFaction: %s: |cffAF5050%s%d|r (%d to |cff%02x%02x%02x%s|r)", name, "-", factionValue, repToGo, FACTION_BAR_COLORS[standingID].r * 255, FACTION_BAR_COLORS[standingID].g * 255, FACTION_BAR_COLORS[standingID].b * 255,(standingID < 8 and standings[standingID + 1] or "cap")))
				end
			end
		end
	end
end

caelUI.faction:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
caelUI.faction:SetScript("OnEvent", function(self, event, msg)
	factionName, factionValue = string.match(msg, factionIncrease)
	if factionName then
		watchFaction(factionName, factionValue, true)
	end

	factionName, factionValue = string.match(msg, factionDecrease)
	if factionName then
		watchFaction(factionName, factionValue, false)
	end
end)

local ReputationMessageFilter = function(self, event, ...)
	local msg = ...

	if msg:find(factionIncrease) or msg:find(factionDecrease) then
		return true, ...
	end

	return false, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", ReputationMessageFilter)

for i = 1, 8  do
	standings[i] = _G["FACTION_STANDING_LABEL"..i]
end