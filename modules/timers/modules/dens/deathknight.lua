--[[	$Id: deathknight.lua 3963 2014-12-02 08:26:37Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "DEATHKNIGHT" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(81136, "player", "buff", true, 0.31, 0.45, 0.63, 145, 12, "BOTTOM", UIParent, "BOTTOM", -250, 192) -- Fléau cramoisi
CreateTimer(59052, "player", "buff", true, 0.31, 0.45, 0.63, 145, 12, "BOTTOM", UIParent, "BOTTOM", -250, 192) -- Brouillard givrant
CreateTimer(49509, "player", "buff", true, 0.31, 0.45, 0.63, 145, 12, "BOTTOM", UIParent, "BOTTOM", -250, 176) -- Odeur de sang
CreateTimer(51124, "player", "buff", true, 0.31, 0.45, 0.63, 145, 12, "BOTTOM", UIParent, "BOTTOM", -250, 176) -- Machine à tuer
CreateTimer(57330, "player", "buff", true, 0.31, 0.45, 0.63, 145, 12, "BOTTOM", UIParent, "BOTTOM", -250, 160) -- Cor de l'hiver

CreateTimer(69409, "target", "debuff", true, nil, nil, nil, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 256) -- Faucheur d'âme
CreateTimer(49222, "player", "buff", true, 0.31, 0.45, 0.63, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 241) -- bouclier d'os
CreateTimer(51271, "player", "buff", true, 0.31, 0.45, 0.63, 145, 12, "BOTTOM", UIParent, "BOTTOM", 0, 241) -- Pilier de givre
