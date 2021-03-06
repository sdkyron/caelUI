--[[	$Id: hunter.lua 3946 2014-10-23 14:01:39Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "HUNTER" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(137596,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -0)	-- Capacitance
CreateTimer(177161,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -0)	-- Archmage's Incandescence
CreateTimer(177176,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -0)	-- Archmage's Greater Incandescence
CreateTimer(187620,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -0)	-- Maalus

CreateTimer(144670,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Brutal Kinship
CreateTimer(139121,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Re-Origination
CreateTimer(138938,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Juju Madness
CreateTimer(162915,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Skull of War
CreateTimer(177067,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Humming Blackiron Trigger

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------]]

CreateTimer(53301,	"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Explosive Shot

CreateTimer(188202,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Rapid Fire (2p T18)
CreateTimer(168980,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Lock and Load
CreateTimer(115939,	"pet",	 "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Beast Cleave

CreateTimer(34720,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Thrill of the Hunt
CreateTimer(177668,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Steady Focus

CreateTimer(82692,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Focus Fire
CreateTimer(35110,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Bombardment
CreateTimer(3674,		"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Black Arrow

CreateTimer(19615,	"player", "buff",		false,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Frenzy
CreateTimer(168811,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Sniper Training
CreateTimer(118253,	"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Serpent Sting

CreateTimer(1130,		"target", "debuff",	false,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Hunter's Mark