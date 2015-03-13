--[[	$Id: battleground.lua 3531 2013-08-24 06:15:23Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.battleground = caelUI.createModule("Battleground")

local battleground = caelUI.battleground

local msg = GetLocale() == "frFR" and "%s pendant %d secondes." or "%s for %d seconds."

battleground:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_DEAD" then
		local _, instanceType = IsInInstance()
		if instanceType == "pvp" or tostring(GetZoneText()) == "Wintergrasp" or tostring(GetZoneText()) == "Tol Barad" then
			RepopMe()
		end
	elseif event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" or event == "CHAT_MSG_BG_SYSTEM_HORDE" then
		for i = 1, GetNumBattlefieldScores() do
			local name, _, _, _, _, faction = GetBattlefieldScore(i)

			if faction  == GetBattlefieldArenaFaction("player") then

				local isAlliance = GetSpellInfo(23335)
				local isHorde = GetSpellInfo(23333)
				
				if UnitAura(name, isAlliance) or UnitAura(name, isHorde) then
					if GetRaidTargetIndex(name) ~= 1 then
						SetRaidTargetIcon(name, 1)
					end
				else		
					SetRaidTargetIcon(name, 0)
				end
			end
		end
	end
end)

for _, event in next, {
	"PLAYER_DEAD",
	"CHAT_MSG_BG_SYSTEM_HORDE",
	"CHAT_MSG_BG_SYSTEM_ALLIANCE",
} do
	battleground:RegisterEvent(event)
end