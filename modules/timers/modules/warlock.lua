--[[	$Id: warlock.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "WARLOCK" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(131737,	"target", "debuff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)		-- Agony
CreateTimer(172,	"target", "debuff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Corruption
CreateTimer(131736,	"target", "debuff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Unstable Affliction
CreateTimer(108370,	"player", "buff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Soul Leech