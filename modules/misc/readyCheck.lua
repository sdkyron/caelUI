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

	-- Draenor
	GetSpellName(156070),	-- Draenic Intellect Flask
	GetSpellName(156071),	-- Draenic Strength Flask
	GetSpellName(156073),	-- Draenic Agility Flask
	GetSpellName(156077),	-- Draenic Stamina Flask

	GetSpellName(156064),	-- Greater Draenic Agility Flask
	GetSpellName(156079),	-- Greater Draenic Intellect Flask
	GetSpellName(156080),	-- Greater Draenic Strength Flask
	GetSpellName(156084),	-- Greater Draenic Stamina Flask
}

ReadyCheckListenerFrame:SetScript("OnShow", nil)

local isGuildGroup

caelUI.readycheck:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		hooksecurefunc(GuildInstanceDifficulty, "Show", function()
			isGuildGroup = true
		end)

		hooksecurefunc(GuildInstanceDifficulty, "Hide", function()
			isGuildGroup = false
		end)
	elseif event == "READY_CHECK" then
		PlaySoundFile([[Sound\Interface\ReadyCheck.wav]], "Master")

		local food = UnitBuff("player", GetSpellName(104280))

		local flask

		for i = 1, #flasks do
			flask = UnitBuff("player", flasks[i])
		end

		if (not isGuildGroup and food) or (isGuildGroup and flask and food) then
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