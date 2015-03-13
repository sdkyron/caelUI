--[[	$Id: hunter.lua 3946 2014-10-23 14:01:39Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "HUNTER" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(137596,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -0)	-- Capacitance
CreateTimer(144670,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Brutal Kinship
CreateTimer(139121,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Re-Origination
CreateTimer(138938,	"player", "buff",		true,		nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Juju Madness

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------]]

CreateTimer(53301,	"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 248)	-- Explosive Shot

CreateTimer(168980,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Lock and Load
--CreateTimer(34692,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- The Beast Within

CreateTimer(34720,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Thrill of the Hunt
CreateTimer(177668,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Steady Focus

CreateTimer(82692,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Focus Fire
CreateTimer(3674,		"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Black Arrow

CreateTimer(118253,		"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Serpent Sting

CreateTimer(1130,		"target", "debuff",	false,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Hunter's Mark