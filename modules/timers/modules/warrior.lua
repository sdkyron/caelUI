--[[	$Id: warrior.lua 3946 2014-10-23 14:01:39Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "WARRIOR" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(13046,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, 0)		-- Enrage

CreateTimer(74245,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -80)	-- Landslide
CreateTimer(104510,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -80)	-- Windsong
CreateTimer(120032,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -80)	-- Dancing Steel

CreateTimer(137596,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -96)	-- Capacitance
CreateTimer(139121,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -112)	-- Re-Origination
CreateTimer(138938,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -112)	-- Juju Madness

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------]]

CreateTimer(32216,	"player", "buff",		true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Victorious
CreateTimer(115768,	"target", "debuff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Deep Wounds

CreateTimer(469,		"player", "buff",		true, nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 0, 168)	-- Commanding Shout
CreateTimer(6673,		"player", "buff",		true, nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 0, 168)	-- Battle Shout