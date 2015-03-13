--[[	$Id: priest.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "PRIEST" then return end

gM_Macros = {
	["SWP"] = {
		show = "Shadow Word: Pain",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/cast [harm, nodead] Shadow Word: Pain]=],
		blizzmacro = true,
		perChar = true,
		class = "PRIEST",
		spec = "1, 2, 3",
	},
	["MF"] = {
		show = "Mind Flay",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/stopmacro [channeling]
			/click [combat, harm, nodead] gotMacros_CDsAll
			/cast [harm, nodead, nochanneling] Mind Flay]=],
		blizzmacro = true,
		perChar = true,
		class = "PRIEST",
		spec = "3",
	},
	["DevP"] = {
		show = "Devouring Plague",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/cast [harm, nodead] Devouring Plague]=],
		blizzmacro = true,
		perChar = true,
		class = "PRIEST",
		spec = "3",
	}
}