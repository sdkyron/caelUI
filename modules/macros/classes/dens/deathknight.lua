--[[	$Id: deathknight.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "DEATHKNIGHT" then return end

gM_Macros = {
	["ANEAN"] = {
		show = "Anéantissement",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsDK
			/cast [harm, nodead] sid{49020}]=],
		blizzmacro = true,
		perChar = true,
		class = "DEATHKNIGHT",
		spec = "2",
	},
	["FDG"] = {
		show = "Frappe de givre",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsDK
			/cast [harm, nodead] sid{49143}]=],
		blizzmacro = true,
		perChar = true,
		class = "DEATHKNIGHT",
		spec = "2",
	},
	["RaH"] = {
		show = "Rafale hurlante",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsDK
			/cast [harm, nodead] sid{49184}]=],
		blizzmacro = true,
		perChar = true,
		class = "DEATHKNIGHT",
		spec = "2",
	},
	["CDsDK"] = {
		-- Pillier de givre
		body = [=[/cast sid{51271}]=],
		nosound = true,
		class = "DEATHKNIGHT",
		spec = "2",
	}
}