--[[	$Id: rogue.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "ROGUE" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(5171, "player", "buff",   true, 0.65, 0.63, 0.35, 147, 10, "BOTTOM", UIParent, "BOTTOM", -250, 176) -- SliceNDice

-- CreateTimer(57934, "player", "buff",   true, 0.65, 0.63, 0.35, 147, 10, "BOTTOM", UIParent, "BOTTOM", -178, 124) -- trick
-- CreateTimer(32645, "player", "buff",   true, 1, 0, 0, 146, 10, "BOTTOM", UIParent, "BOTTOM", -178, 110) -- Envenom
-- CreateTimer(79140, "target", "debuff",   true, 1, 0, 0, 146, 10, "BOTTOM", UIParent, "BOTTOM", -178, 176) -- Vendeta

CreateTimer(84617, "target", "debuff",   true, 1, 0, 0, 148, 10, "BOTTOM", UIParent, "BOTTOM", 250, 192) -- Revelatrice
CreateTimer(1943, "target", "debuff", true, nil, nil, nil, 146, 10, "BOTTOM", UIParent, "BOTTOM", 250, 176) -- Rupture
CreateTimer(2818, "target", "debuff", true, nil, nil, nil, 146, 10, "BOTTOM", UIParent, "BOTTOM", 250, 160) -- Mortel