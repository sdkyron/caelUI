--[[	$Id: druid.lua 3984 2015-01-26 10:19:11Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "DRUID" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(1126,		"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, 0)		-- Mark of the Wild

CreateTimer(74245,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Landslide
CreateTimer(104510,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Windsong
CreateTimer(120032,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Dancing Steel
CreateTimer(159234,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Mark of the Thunderlord
CreateTimer(159238,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Mark of the Shattered Hand

CreateTimer(135700,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -32)	-- Clearcasting

CreateTimer(137596,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -48)	-- Capacitance
CreateTimer(177161,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -48)	-- Archmage's Incandescence

CreateTimer(139121,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Re-Origination
CreateTimer(138938,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Juju Madness
CreateTimer(162915,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -64)	-- Skull of War

CreateTimer(177597,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -80)	-- Lucky Double-Sided Coin

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------]]

CreateTimer(158792,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 280)	-- Pulverize

CreateTimer(77758,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 264)	-- Thrash

CreateTimer(69369,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 248)	-- Predatory Swiftness
CreateTimer(135288,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 248)	-- Tooth and Claw

CreateTimer(145152,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Bloodtalons
CreateTimer(155625,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Moonfire

CreateTimer(1079,		"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Rip

CreateTimer(33745,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Lacerate
CreateTimer(155722,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Rake

CreateTimer(52610,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Savage Roar
CreateTimer(132402,	"player", "buff",		true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Savage Defense

CreateTimer(102355,	"target", "debuff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Faerie Swarm