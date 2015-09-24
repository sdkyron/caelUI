--[[	$Id: stopCasting.lua 3724 2013-11-14 11:34:54Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.dispel = caelUI.createModule("Dispel")

local GetSpellName = caelUI.getspellname

local auras = {
	GetSpellName(184359),	-- Gurtogg Bloodboil (Fury)
}

local IsHostile = function()
	return (UnitIsEnemy("player", "target") or UnitCanAttack("player", "target")) and true or false
end

caelUI.dispel:RegisterEvent("UNIT_AURA")
caelUI.dispel:SetScript("OnEvent", function(_, _, unit)
	if unit ~= "target" then return end

	if IsHostile() then
		for _, buff in next, auras do
			if buff then
				local name, _, icon = UnitAura(unit, buff)
				local _, tranqUp = GetSpellCooldown(19801)

				if name and tranqUp == 0 then
					caelCombatTextAddText("|cffAF5050".."DISPELL: "..name.."|r", icon, true, true, "Warning", true)

					PlaySoundFile(caelMedia.files.soundNotification, "Master")
				end
			end
		end
	end
end)