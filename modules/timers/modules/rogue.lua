--[[	$Id: rogue.lua 3984 2015-01-26 10:19:11Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "ROGUE" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(2823,		"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, 0)		-- Deadly Poison
CreateTimer(157584,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, 0)		-- Instant Poison
CreateTimer(8679,		"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, 0)		-- Wound Poison

CreateTimer(3408,		"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Crippling Poison
CreateTimer(108211,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Leeching Poison

CreateTimer(115189,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -32)	-- Anticipation

CreateTimer(32645,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -48)	-- Envenom
CreateTimer(84745,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -48)	-- Shallow Insight
CreateTimer(84746,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -48)	-- Moderate Insight
CreateTimer(84747,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -48)	-- Deep Insight

CreateTimer(74245,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Landslide
CreateTimer(104510,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Windsong
CreateTimer(120032,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Dancing Steel
CreateTimer(159234,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Mark of the Thunderlord
CreateTimer(159676,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Mark of the Frostwolf

CreateTimer(159238,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -96)	-- Mark of the Shattered Hand

CreateTimer(137596,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -112)	-- Capacitance
CreateTimer(177161,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -112)	-- Archmage's Incandescence

CreateTimer(139121,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -128)	-- Re-Origination
CreateTimer(138938,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -128)	-- Juju Madness
CreateTimer(162915,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -128)	-- Skull of War

CreateTimer(177597,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -144)	-- Lucky Double-Sided Coin

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------]]

CreateTimer(73651,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 312)	-- Recuperate

CreateTimer(1330,		"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 296)	-- Garrote - Silence

CreateTimer(115189,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 280)	-- Anticipation

CreateTimer(31224,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 264)	-- Cloak of Shadow

CreateTimer(1966,		"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 248)	-- Feint

CreateTimer(91023,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Find Weakness

CreateTimer(84617,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Revealing Strike
CreateTimer(16511,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Hemorrhage
CreateTimer(121153,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Blindside

CreateTimer(703,		"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Garrote

CreateTimer(1943,		"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Rupture

CreateTimer(5171,		"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Slice and Dice