--[[	$Id: monk.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "MONK" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(130320, "target", "debuff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 248) -- coup de pied du soleil
CreateTimer(125359, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 230) -- Puissance du tigre

CreateTimer(125195, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 176) -- Infusion