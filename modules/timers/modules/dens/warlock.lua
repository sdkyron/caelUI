--[[	$Id: warlock.lua 3963 2014-12-02 08:26:37Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "WARLOCK" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(113858, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", -250, 176) -- Ame sombre

CreateTimer(116858, "target", "debuff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 230) -- Trait du chaos
CreateTimer(29341, "target", "debuff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 212) -- Brûlure de l'ombre

CreateTimer(30108, "target", "debuff", true, 0.69, 0.31, 0.31, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 230) -- Affliction instable
CreateTimer(122355, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 230) -- Coeur de la fournaise

CreateTimer(980, "target", "debuff", true, 0.69, 0.31, 0.31, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 212) -- Agonie
CreateTimer(603, "target", "debuff", true, 0.69, 0.31, 0.31, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 212) -- Destein funeste

CreateTimer(146739, "target", "debuff", true, 0.69, 0.31, 0.31, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 194) -- Corruption

CreateTimer(348, "target", "debuff", true, 0.69, 0.31, 0.31, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 194) -- Immolation
CreateTimer(108686, "target", "debuff", true, 0.69, 0.31, 0.31, 145, 14, "BOTTOM", UIParent, "BOTTOM", 0, 194) -- Immolation

CreateTimer(104232, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 265, 194) -- Pluie de feu
CreateTimer(117828, "player", "buff", true, 0.31, 0.45, 0.63, 145, 14, "BOTTOM", UIParent, "BOTTOM", 265, 176) -- Explosion de fumées

CreateTimer(108683, "player", "buff", true, 0.31, 0.45, 0.63, 90, 18, "BOTTOM", UIParent, "BOTTOM",  12, 150) -- Feu et souffre
