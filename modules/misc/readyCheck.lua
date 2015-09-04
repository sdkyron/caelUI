--[[	$Id: readyCheck.lua 3979 2015-01-26 10:14:37Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Force various warnings, auto accept ready checks if buffed	]]

caelUI.readycheck = caelUI.createModule("ReadyCheck")

local GetSpellName = caelUI.getspellname

local flasks = {
	-- Cataclysm
	GetSpellName(80719),		-- Flask of Steelskin
	GetSpellName(80720),		-- Flask of the Draconic Mind
	GetSpellName(80721),		-- Flask of the Winds
	GetSpellName(80723),		-- Flask of Titanic Strength
	GetSpellName(94162),		-- Flask of Flowing Water

	-- Pandaria
	GetSpellName(105694),	-- Flask of the Earth
	GetSpellName(105691),	-- Flask of the Warm Sun
	GetSpellName(105696),	-- Flask of Winter's Bite
	GetSpellName(105693),	-- Flask of Falling Leaves
	GetSpellName(105689),	-- Flask of Spring Blossoms

	GetSpellName(127230),	-- For testing purpose: Vision of Insanity

	-- Draenor
	GetSpellName(156070),	-- Draenic Intellect Flask
	GetSpellName(156071),	-- Draenic Strength Flask
	GetSpellName(156073),	-- Draenic Agility Flask
	GetSpellName(156077),	-- Draenic Stamina Flask

	GetSpellName(156064),	-- Greater Draenic Agility Flask
	GetSpellName(156079),	-- Greater Draenic Intellect Flask
	GetSpellName(156080),	-- Greater Draenic Strength Flask
	GetSpellName(156084),	-- Greater Draenic Stamina Flask

	GetSpellName(176151),	-- For testing purpose: Whispers of Insanity
}

local runes = {
	GetSpellName(175439),	-- Stout Augmentation (Strength)
	GetSpellName(175456),	-- Hyper Augmentation (Agility)
	GetSpellName(175457),	-- Focus Augmentation (Intellect)
}

local ShouldHaveRune = function()
	local factionIndex = 1
	local lastFactionName

	repeat
		local name, _, standingId = GetFactionInfo(factionIndex)

		if name == lastFactionName then
			break
		end

		lastFactionName  = name

		if name == "Vol'jin's Headhunters" and standingId == 8 then
			return true
		end

		factionIndex = factionIndex + 1

	until factionIndex > 200
end

ReadyCheckListenerFrame:SetScript("OnShow", nil)

caelUI.readycheck:SetScript("OnEvent", function(self, event, ...)

	if (event == "GUILD_PARTY_STATE_UPDATED") then
		self.__isGuildGroup = ...
	end

	if event == "READY_CHECK" then
		PlaySoundFile([[Sound\Interface\ReadyCheck.wav]], "Master")

		local food = UnitBuff("player", GetSpellName(104280))

		local flask

		for i = 1, #flasks do
			flask = UnitBuff("player", flasks[i])

			if flask then
				break
			end
		end

		local rune

		if ShouldHaveRune() then
			for i = 1, #runes do
				rune = UnitBuff("player", runes[i])

				if rune then
					break
				end
			end
		end

		if (not self.__isGuildGroup and food and rune) or (self.__isGuildGroup and flask and food and rune) then
			ReadyCheckFrame:Hide()
			ConfirmReadyCheck(1)
		end
	elseif event == "UPDATE_BATTLEFIELD_STATUS" then -- and StaticPopup_Visible("CONFIRM_BATTLEFIELD_ENTRY") then
		for i = 1, GetMaxBattlefieldID() do
			local status = GetBattlefieldStatus(i)
			if status == "confirm" then
				PlaySound("PVPTHROUGHQUEUE", "Master")
--				PlaySoundFile([[Sound\Events\gruntling_horn_bb.ogg]], "Master")
				break
			end
			i = i + 1
		end
	elseif event == "LFG_PROPOSAL_SHOW" or event == "PARTY_INVITE_REQUEST" or event == "CONFIRM_SUMMON" then
		PlaySoundFile([[Sound\Interface\ReadyCheck.wav]], "Master")
	elseif event == "RESURRECT_REQUEST" then
		PlaySoundFile([[Sound\Spells\Resurrection.wav]], "Master")
	elseif event == "PET_BATTLE_QUEUE_PROPOSE_MATCH" then
		PlaySound("PVPTHROUGHQUEUE", "Master")
	end
end)

for _, event in next, {
	"GUILD_PARTY_STATE_UPDATED",
	"PLAYER_ENTERING_WORLD",
	"READY_CHECK",
	"UPDATE_BATTLEFIELD_STATUS",
	"LFG_PROPOSAL_SHOW",
	"PARTY_INVITE_REQUEST",
	"CONFIRM_SUMMON",
	"PET_BATTLE_QUEUE_PROPOSE_MATCH",
	"RESURRECT_REQUEST"
} do
	caelUI.readycheck:RegisterEvent(event)
end