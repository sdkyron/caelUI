--[[	$Id: autoLog.lua 3648 2013-10-18 08:42:32Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.autolog = caelUI.createModule("AutoLog")

--[[	Auto enables combat logging in raid instances excluding LFR and solo	]]

local isGuildGroup

caelUI.autolog:RegisterEvent("PLAYER_ENTERING_WORLD")
caelUI.autolog:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" and caelUI.myChars then
		if UnitLevel("player") ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
			return
		end

		hooksecurefunc(GuildInstanceDifficulty, "Show", function()
			isGuildGroup = true
		end)

		hooksecurefunc(GuildInstanceDifficulty, "Hide", function()
			isGuildGroup = false
		end)

		local _, instanceType = IsInInstance()

		print(isGuildGroup, instanceType, IsInRaid(LE_PARTY_CATEGORY_HOME))

		if instanceType == "raid" and IsInRaid(LE_PARTY_CATEGORY_HOME) and isGuildGroup then
			if not LoggingCombat() then
				LoggingCombat(1)
				print("|cffD7BEA5cael|rCore: Logging enabled")
			end
		else
			if LoggingCombat() then
				LoggingCombat(0)
				print("|cffD7BEA5cael|rCore: Logging disabled")
			end
		end
	end
end)