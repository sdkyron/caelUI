--[[	$Id: oUF_cConfig.lua 3968 2014-12-02 08:32:00Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

oUF_Caellian.config = oUF_Caellian.createModule("Config")

local config = oUF_Caellian.config

config.noPlayerAuras = false -- true to disable oUF buffs/debuffs on the player frame and enable default
config.noPetAuras = false -- true to disable oUF buffs/debuffs on the pet frame
config.noTargetAuras = false -- true to disable oUF buffs/debuffs on the target frame
config.noToTAuras = false -- true to disable oUF buffs/debuffs on the ToT frame

config.noParty = false -- true to disable party frames
config.noRaid = false -- true to disable raid frames
config.noArena = false -- true to disable arena frames

config.font = caelMedia.fonts.ADDON_FONT

config.scale = 1 -- scale of the unitframes (1 being 100%)

config.manaThreshold = 20 -- low mana threshold for all mana classes

config.noClassDebuffs = false -- true to show all debuffs

config.coords = {
	playerX = -278.5, -- horizontal offset for the player block frames
	playerY = 269.5, -- vertical offset for the player block frames

	targetX = 278.5, -- horizontal offset for the target block frames
	targetY = 269.5, -- vertical offset for the target block frames

	arenaX = -5, -- horizontal offset for the arena frames
	arenaY = 0, -- vertical offset for the arena frames

	partyX = 5, -- horizontal offset for the party frames
	partyY = -5, -- vertical offset for the party frames

	raidX = 5, -- horizontal offset for the raid frames
	raidY = -5, -- vertical offset for the raid frames

	bossX = -5, -- horizontal offset for the arena frames
	bossY = 0, -- vertical offset for the arena frames
}

config.clickSpell = {
	["DEATHKNIGHT"]	= 61999,		-- Raise Ally
	["DRUID"]			= 20484,		-- Rebirth
	["HUNTER"]			= 34477,		-- Misdirection
	["MAGE"]				= 475,		-- Remove Curse
	["MONK"]		  		= 115450,	-- Detox
	["PALADIN"]			= 1038,		-- Hand of Salvation
	["PRIEST"]			= 73325,		-- Leap of Faith
	["ROGUE"]			= 57934,		-- Tricks of the Trade
	["SHAMAN"]			= 546,		-- Water Walking
	["WARRIOR"]			= 3411,		-- Intervene
	["WARLOCK"]			= 80398,		-- Dark Intent
}