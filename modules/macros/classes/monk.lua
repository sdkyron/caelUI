--[[	$Id: monk.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "MONK" then return end

gM_Macros = {
	["Dps"] = {
		show = "Jab",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CD
			/cast [harm, nodead] Jab]=],
		blizzmacro = true,
		perChar = true,
		class = "MONK",
		spec = "1, 3",
	}
}