--[[	$Id: autoCancelBadBuffs.lua 3981 2015-01-26 10:17:46Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

local _, caelUI = ...

--[[	Auto cancel various buffs	]]

caelUI.badbuffs = caelUI.createModule("BadBuffs")

local GetSpellName = caelUI.getspellname

local badBuffsList = {
	[GetSpellName(24732)]	= true,	-- Bat Costume
	[GetSpellName(24735)]	= true,	-- Ghost Costume female
	[GetSpellName(24736)]	= true,	-- Ghost Costume male
	[GetSpellName(44185)]	= true,	-- Jack-o'-Lanterned!
	[GetSpellName(58493)]	= true,	-- Mohawked! (69285)
	[GetSpellName(24708)]	= true,	-- Pirate Costume female
	[GetSpellName(24709)]	= true,	-- Pirate Costume male
	[GetSpellName(61716)]	= true,	-- Rabbit Costume
	[GetSpellName(24723)]	= true,	-- Skeleton Costume
	[GetSpellName(61781)]	= true,	-- Turkey Feathers
	[GetSpellName(24740)]	= true,	-- Wisp Costume
	[GetSpellName(24712)]	= true,	-- Leper Gnome Costume
	[GetSpellName(24710)]	= true,	-- Ninja Costume
	[GetSpellName(61781)]	= true,	-- Turkey Feathers
	[GetSpellName(61734)]	= false,	-- Noblegarden Bunny
	[GetSpellName(114800)]	= true,	-- Polyformic Acid Potion
	[GetSpellName(163267)]	= true,	-- Prismatic Reflection
	[GetSpellName(165860)]	= true,	-- Ready for Raiding

	[GetSpellName(1022)]		= true,	-- Hand of Protection ??
}

caelUI.badbuffs:RegisterEvent("UNIT_AURA")
caelUI.badbuffs:SetScript("OnEvent", function(_, _, unit)
	if unit ~= "player" then
		return
	end

	if not InCombatLockdown() then
		for buff, enabled in next, badBuffsList do
			if UnitAura(unit, buff) and enabled then
				CancelUnitBuff(unit, buff)
				print("|cffD7BEA5cael|rCore: removed "..buff)
			end
		end
	end
end)