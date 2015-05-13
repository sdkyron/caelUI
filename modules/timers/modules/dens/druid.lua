--[[	$Id: druid.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "DRUID" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(22570, "target", "debuff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 301) -- Estropier
CreateTimer(5217, "player", "buff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 286) -- Fureur du tigre
CreateTimer(1079, "target", "debuff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 271) -- Déchirure

CreateTimer(106830, "target", "debuff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 256) -- Rosser
CreateTimer(1822, "target", "debuff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 256) -- Griffure


CreateTimer(33745, "target", "debuff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 241) -- Lacérer
CreateTimer(52610, "player", "buff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 241) -- Rugissement sauvage

CreateTimer(113746, "target", "debuff", false, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 226) -- Armure affaiblie