--[[	$Id: monk.lua 3956 2014-11-28 07:01:01Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "MONK" then return end

gM_Macros = {
	["Cpd"] = {
		--Coup direct
		show = "sid{100780}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/cast [harm, nodead] sid{100780}]=],
		blizzmacro = true,
		perChar = true,
		class = "MONK",
		spec = "1, 3",
	},
	["Cpdsl"] = {
		--Coup de pied du soleil levant
		show = "sid{107428}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/cast [harm, nodead] sid{107428}]=],
		blizzmacro = true,
		perChar = true,
		class = "MONK",
		spec = "1, 3",
	},
	["Pdt"] = {
		--Paume du tigre
		show = "sid{100787}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/cast [harm, nodead] sid{100787}]=],
		blizzmacro = true,
		perChar = true,
		class = "MONK",
		spec = "1, 3",
	},
	["Fvn"] = {
		--Frappe du voile noir
		show = "sid{100784}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/cast [harm, nodead] sid{100784}]=],
		blizzmacro = true,
		perChar = true,
		class = "MONK",
		spec = "1, 3",
	},
	["Onde"] = {
		-- Onde de chi, Extraction du mal
		show = "sid{115098}",
		body = [=[/castsequence reset=target sid{115098}, sid{115072}]=],
		blizzmacro = true,
		perChar = true,
		class = "MONK",
		spec = "1, 3",
	},
}