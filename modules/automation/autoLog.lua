--[[	$Id: autoLog.lua 3648 2013-10-18 08:42:32Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.autolog = caelUI.createModule("AutoLog")

--[[	Auto enables combat logging in raid instances excluding LFR and solo	]]

caelUI.autolog:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
caelUI.autolog:SetScript("OnEvent", function(self, event, ...)
	if not caelUI.myChars then
		return
	end

	if UnitLevel("player") ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
		return
	end

	if not (IsInRaid(LE_PARTY_CATEGORY_HOME) and select(2, IsInInstance()) == "raid") then
		return
	end

	self.__isGuildGroup = ...

	if self.__isGuildGroup then
		if not LoggingCombat() then
			LoggingCombat(1)
--			print("|cffD7BEA5cael|rCore: Logging enabled")
		end
	else
		if LoggingCombat() then
			LoggingCombat(0)
--			print("|cffD7BEA5cael|rCore: Logging disabled")
		end
	end
end)