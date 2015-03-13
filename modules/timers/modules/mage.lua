--[[	$Id: mage.lua 3946 2014-10-23 14:01:39Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "MAGE" then return end

local _, caelUI = ...

local CreateTimer = caelUI.CreateTimer

CreateTimer(11426,	"player", "buff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 232)	-- Ice Barrier
CreateTimer(112965,	"player", "buff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 216)	-- Fingers of Frost
CreateTimer(44549,	"player", "buff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 200)	-- Brain Freeze
CreateTimer(80353,	"player", "buff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 184)	-- Time Warp
CreateTimer(113092,	"target", "debuff",	true, nil, nil, nil, 133, 12, "BOTTOM", UIParent, "BOTTOM", 0, 168)	-- Frozen Bomb