--[[	$Id: priest.lua 3963 2014-12-02 08:26:37Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "PRIEST" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(17, "player", "buff", true, 0.31, 0.45, 0.63, 145, 10, "BOTTOM", UIParent, "BOTTOM", -250, 160) -- Mot de pouvoir : Bouclier

CreateTimer(109175, "player", "buff", true, 0.31, 0.45, 0.63, 145, 10, "BOTTOM", UIParent, "BOTTOM", 0, 256) -- Clairvoyance divine
CreateTimer(126083, "player", "buff", true, 0.31, 0.45, 0.63, 145, 10, "BOTTOM", UIParent, "BOTTOM", 0, 226) -- Vague de ténèbres

CreateTimer(34914, "target", "debuff", true, nil, nil, nil, 145, 10, "BOTTOM", UIParent, "BOTTOM", 260, 176) -- Toucher vampirique
CreateTimer(589, "target", "debuff", true, nil, nil, nil, 145, 10, "BOTTOM", UIParent, "BOTTOM", 260, 160) -- Mot de l'ombre : Douleur