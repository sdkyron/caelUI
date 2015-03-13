--[[	$Id: powersound.lua 3880 2014-02-21 10:04:44Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.powersound = caelUI.createModule("PowerSound")

caelUI.powersound:RegisterUnitEvent("UNIT_COMBO_POINTS", "player", "vehicle")
caelUI.powersound:RegisterUnitEvent("UNIT_POWER", "player")

local floor, UnitPower, UnitPowerMax = math.floor, UnitPower, UnitPowerMax

local numPrevious = 0
local MAX_POWER, POWER_TYPE_NAME, POWER_TYPE_ID

if caelUI.playerClass == "MONK" then
	POWER_TYPE_NAME = "CHI"
	POWER_TYPE_ID = SPELL_POWER_CHI
elseif caelUI.playerClass == "PALADIN" then
	POWER_TYPE_NAME = "HOLY_POWER"
	POWER_TYPE_ID = SPELL_POWER_HOLY_POWER
elseif caelUI.playerClass == "PRIEST" then
	POWER_TYPE_NAME = "SHADOW_ORBS"
	POWER_TYPE_ID = SPELL_POWER_SHADOW_ORBS
	MAX_POWER = PRIEST_BAR_NUM_ORBS
elseif caelUI.playerClass == "WARLOCK" then
	caelUI.powersound:RegisterEvent("PLAYER_LOGIN")
	caelUI.powersound:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

caelUI.powersound:SetScript("OnEvent", function(self, event, unit, powerType)
	if event == "UNIT_POWER" and powerType ~= POWER_TYPE_NAME then return end

	if event == "PLAYER_LOGIN" or event == "PLAYER_SPECIALIZATION_CHANGED" then
		local spec = GetSpecialization()

		if spec == SPEC_WARLOCK_AFFLICTION then
			POWER_TYPE_NAME = "SOUL_SHARDS"
			POWER_TYPE_ID = SPELL_POWER_SOUL_SHARDS
--		elseif spec == SPEC_WARLOCK_DEMONOLOGY then
--			POWER_TYPE_NAME = "DEMONIC_FURY"
--			POWER_TYPE_ID = SPELL_POWER_DEMONIC_FURY
		elseif spec == SPEC_WARLOCK_DESTRUCTION then
			POWER_TYPE_NAME = "BURNING_EMBERS"
			POWER_TYPE_ID = SPELL_POWER_BURNING_EMBERS
		end

		return
	end

	local num, numMax

	if event == "UNIT_COMBO_POINTS" then
		num = GetComboPoints("player", "target")
		numMax = MAX_COMBO_POINTS
	else
		num = UnitPower(unit, POWER_TYPE_ID)
		numMax = MAX_POWER or UnitPowerMax(unit, POWER_TYPE_ID)
	end

	if num > numPrevious then
		if num == numMax then
			PlaySoundFile(caelMedia.files.soundComboMax, "Master")
		else
			PlaySoundFile(caelMedia.files.soundCombo, "Master")
		end
	end

	numPrevious = num
end)