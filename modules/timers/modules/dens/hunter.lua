--[[	$Id: hunter.lua 3963 2014-12-02 08:26:37Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "HUNTER" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer


CreateTimer(53301,	"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 248)	-- Tir explosif

CreateTimer(168980,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Prêt à tirer

CreateTimer(34720,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Frisson de la chasse
CreateTimer(177668,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Focalisation assurée

CreateTimer(82692,	"player", "buff",		true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Tir focalisé
CreateTimer(3674,		"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Flèche noire

CreateTimer(118253,		"target", "debuff",	true,		nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Morsure du serpent

CreateTimer(1130,		"target", "debuff",	false,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Marque du chasseur