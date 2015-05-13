--[[	$Id: mage.lua 3963 2014-12-02 08:26:37Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "MAGE" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(12042, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", -250, 194) -- Pouvoir des arcanes
CreateTimer(110909, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", -250, 178) -- Altérer le temps
CreateTimer(11426, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", -250, 160) -- Barriére de glace


CreateTimer(112965, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 260) -- Doigts de givre
CreateTimer(44549, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 241) -- Gel mental


CreateTimer(44457, "target", "debuff", true, 0.69, 0.31, 0.31, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 280) -- Bombe vivante
CreateTimer(36032, "player", "debuff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 262) -- Charge arcanique
CreateTimer(79683, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 244) -- Projectiles des Arcanes
CreateTimer(145252, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 225) -- Magie profonde


CreateTimer(116014, "player", "buff", true, 0.31, 0.45, 0.63, 90, 18, "BOTTOM", UIParent, "BOTTOM",  12, 150) -- Rune de puissance

CreateTimer(113092, "target", "debuff", true, nil, nil, nil, 145, 14, "BOTTOM", UIParent, "BOTTOM", 265, 192) -- Bombe de givre
CreateTimer(114923, "target", "debuff", true, nil, nil, nil, 145, 14, "BOTTOM", UIParent, "BOTTOM", 265, 192) -- Tempête du Néant
