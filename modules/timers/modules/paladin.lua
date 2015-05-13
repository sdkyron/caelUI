--[[	$Id: paladin.lua 3946 2014-10-23 14:01:39Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "PALADIN" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(20217,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, 0)		-- Blessing of Kings
CreateTimer(90174,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -16)	-- Divine Purpose
CreateTimer(85416,	"player", "buff",		true, nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -32)	-- Grand Crusader

CreateTimer(74245,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -80)	-- Landslide
CreateTimer(104510,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -80)	-- Windsong
CreateTimer(120032,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -80)	-- Dancing Steel

CreateTimer(137596,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -96)	-- Capacitance
CreateTimer(139121,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -112)	-- Re-Origination
CreateTimer(138938,	"player", "buff",		true,	nil, nil, nil, 133, 12, "TOPLEFT", UIParent, "LEFT", 22, -112)	-- Juju Madness

--[[-----------------------------------------------------------------------------------------------------------------------------------------------------]]

CreateTimer(31935,	"target", "debuff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Avenger's Shield
CreateTimer(31803,	"target", "debuff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Censure
CreateTimer(114637,	"player", "buff",		true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Bastion of Glory
CreateTimer(132403,	"player", "buff",		true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Shield of the Righteous

CreateTimer(114250,	"player", "buff",		true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Selfless Healer
CreateTimer(114163,	"player", "buff",		true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Eternal Flame
CreateTimer(65148,	"player", "buff",		true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Sacred Shield