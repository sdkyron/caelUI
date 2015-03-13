--[[	$Id: Monk.lua 3946 2014-10-23 14:01:39Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "MONK" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(118864,	"player", "buff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Combo Breaker
CreateTimer(116768,	"player", "buff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Combo Breaker
CreateTimer(125359,	"player", "buff",	true,	nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Tiger Power
