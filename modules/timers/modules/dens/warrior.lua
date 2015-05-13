--[[	$Id: warrior.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "WARRIOR" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(85739,	"player", "buff", true, 0.31, 0.45, 0.63, 145, 11, "BOTTOM", UIParent, "BOTTOM", -250, 192) 	-- Fendoir a viande
CreateTimer(86346,	"target", "debuff", true, nil, nil, nil, 145, 11, "BOTTOM", UIParent, "BOTTOM", -250, 176) 		-- Frappe du colosse

CreateTimer(46916,	"player", "buff", true, 0.31, 0.45, 0.63, 145, 11, "BOTTOM", UIParent, "BOTTOM", 0, 272) 		-- Afflux de sang
CreateTimer(131116,	"player", "buff", true, nil, nil, nil, 145, 11, "BOTTOM", UIParent, "BOTTOM", 0, 256) 			-- Coup déchainé

CreateTimer(12292,	"player", "buff", true, 0.31, 0.45, 0.63, 145, 11, "BOTTOM", UIParent, "BOTTOM", 260, 192) 		-- Bain de sang