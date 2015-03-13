--[[	$Id: stopCasting.lua 3724 2013-11-14 11:34:54Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.stopcasting = caelUI.createModule("StopCasting")

local GetSpellName = caelUI.getspellname

local auras = {
	GetSpellName(48707),	-- Anti-Magic Shell
	GetSpellName(31224),	-- Cloak of Shadows
	GetSpellName(33786),	-- Cyclone
	GetSpellName(19263),	-- Deterrence
	GetSpellName(642),	-- Divine Shield
	GetSpellName(1022),	-- Hand of Protection
	GetSpellName(45438),	-- Ice Block
	GetSpellName(47585),	-- Dispersion
	GetSpellName(76577),	-- Smoke Bomb
	GetSpellName(23920),	-- Spell Reflection
}

local IsHostile = function()
	return UnitIsPlayer("target") and (UnitIsEnemy("player", "target") or UnitCanAttack("player", "target")) and true or false
end

caelUI.stopcasting:RegisterEvent("UNIT_AURA")
caelUI.stopcasting:SetScript("OnEvent", function(_, _, unit)
	if unit ~= "target" then return end

	if IsHostile() then
		for _, buff in next, auras do
			if buff then
				local name, _, icon = UnitAura(unit, buff)

				if name then
					caelCombatTextAddText("|cffAF5050".."STOP CASTING: "..name.."|r", icon, true, true, "Warning", true)

					PlaySoundFile(caelMedia.files.soundNotification, "Master")
				end
			end
		end
	end
end)