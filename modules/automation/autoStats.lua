--[[	$Id: autoStats.lua 3958 2014-12-02 08:23:47Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.autostats = caelUI.createModule("Auto Stats")

--[[	Auto hide unnecessary stats from CharacterFrame	]]

PAPERDOLL_STATCATEGORIES = {
	GENERAL = {
		id = 1,
		stats = {
			"ITEMLEVEL",
			"HEALTH",
			"POWER",
			"MOVESPEED",
		},
	},
	MELEE = {
		id = 2,
		stats = {
			"MELEE_DPS",
			"MELEE_DAMAGE",
			"STRENGTH",
			"AGILITY",
			"MELEE_AP",
			"ENERGY_REGEN",
			"RUNE_REGEN",
			"CRITCHANCE",
			"MASTERY",
			"HASTE",
			"VERSATILITY",
			"MULTISTRIKE",
			"LIFESTEAL",
		},
	},
	RANGED = {
		id = 2,
		stats = {
			"RANGED_DPS",
			"RANGED_DAMAGE",
			"AGILITY",
			"RANGED_AP",
			"FOCUS_REGEN",
			"CRITCHANCE",
			"MASTERY",
			"HASTE",
			"VERSATILITY",
			"MULTISTRIKE",
			"LIFESTEAL",
		},
	},
	SPELL = {
		id = 2,
		stats = {
			"SPELL_DAMAGE",
			"SPIRIT",
			"INTELLECT",
			"SPELLDAMAGE",
			"SPELLHEALING",
			"MANAREGEN",
			"COMBATMANAREGEN",
			"SPELLCRIT",
			"MASTERY",
			"SPELL_HASTE",
			"VERSATILITY",
			"MULTISTRIKE",
			"LIFESTEAL",
		},
	},
	DEFENSE = {
		id = 3,
		stats = {
			"STAMINA",
			"ARMOR",
			"DODGE",
			"PARRY",
			"BLOCK",
			"RESILIENCE_REDUCTION",
			"PVP_POWER",
		},
	},
}

local class = select(3, UnitClass("player"))
local orig = PaperDoll_InitStatCategories

local sort = {
	{
		"GENERAL",
		"MELEE",
		"DEFENSE",
	},
	{
		"GENERAL",
		"RANGED",
		"DEFENSE",
	},
	{
		"GENERAL",
		"SPELL",
		"DEFENSE",
	},
}

local playerSpec
local specs = {
	{1, 1, 1},
	{3, 1, 1},
	{2, 2, 2},
	{1, 1, 1},
	{3, 3, 3},
	{1, 1, 1},
	{3, 1, 3},
	{3, 3, 3},
	{3, 3, 3},
	{1, 3, 1},
	{3, 1, 1, 3},
}

caelUI.autostats:RegisterEvent("PLAYER_TALENT_UPDATE")
caelUI.autostats:SetScript("OnEvent", function()
	playerSpec = GetSpecialization()

	if playerSpec then
		PaperDoll_InitStatCategories = function()
			orig(sort[specs[class][playerSpec]], nil, nil, "player")
			PaperDollFrame_CollapseStatCategory(CharacterStatsPaneCategory4)
		end
	end
end)

for index = 1, 3 do
	local toolbar = _G["CharacterStatsPaneCategory"..index.."Toolbar"]
	toolbar:SetScript("OnEnter", nil)
	toolbar:SetScript("OnClick", nil)
	toolbar:RegisterForDrag()
end

do
	local setStat = PaperDollFrame_SetStat
	function PaperDollFrame_SetStat(self, ...)
		if index == 1 and class ~= 6 and class ~= 2 and class ~= 1 then
			return self:Hide()
		end

		setStat(self, ...)
	end

	local setSpellHit = PaperDollFrame_SetSpellHitChance
	function PaperDollFrame_SetSpellHitChance(self, ...)
		if class == 5 and playerSpec ~= 3 then
			return self:Hide()
		elseif (class == 11 or class == 7) and playerSpec == 3 then
			return self:Hide()
		end

		setSpellHit(self, ...)
	end

	local setParry = PaperDollFrame_SetParry
	function PaperDollFrame_SetParry(self, ...)
		if class ~= 2 and class ~= 1 and class ~= 6 and not (class == 10 and playerSpec == 2) then
			return self:Hide()
		end

		setParry(self, ...)
	end

	local setBlock = PaperDollFrame_SetBlock
	function PaperDollFrame_SetBlock(self, ...)
		if class ~= 2 and class ~= 1 then
			return self:Hide()
		end

		setBlock(self, ...)
	end
end