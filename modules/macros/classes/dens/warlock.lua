--[[	$Id: warlock.lua 3956 2014-11-28 07:01:01Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "WARLOCK" then return end

gM_Macros = {
	["T1"] = {
		body = [=[/cleartarget [exists]
			/assist [target=pet, exists]Pet
			/stopmacro [target=pettarget, exists]
			/click [target=pet, dead][target=pet, noexists] tabButton]=],
		class = "WARLOCK",
	},
	["TGT"] = {
		show = "[pet:Imp] Summon Imp; [pet:Voidwalker] Summon Voidwalker; Auto Attack",
		body = [=[/targetenemy [noexists][noharm][dead]
			/cast [nomodifier, nopet]Summon Imp; [modifier, nopet]Summon Voidwalker
			/petpassive [target=pettarget,exists]
			/stopmacro [target=pettarget,exists]
			/petassist
			/petattack]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "1, 2, 3",
	},
	["DpsDestru"] = {
		show = "sid{29722}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsWarlock
			/click [modifier, harm, nodead] gotMacros_INC
			/click [nomodifier, harm, nodead] gotMacros_INC]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "3",
	},
	["INC"] = {
		--Incinérer
		body = [=[/cast sid{29722}]=],
		class = "WARLOCK",
		spec = "3",
	},
	["INCM"] = {
		--Incinérer Modifier
		body = [=[/cast sid{114654}]=],
		class = "WARLOCK",
		spec = "3",
	},
	["IMMO"] = {
		--Immolation
		show = "sid{348}",
		body = [=[/cast sid{348}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "3",
	},
	["CONF"] = {
		--Conflagration
		show = "sid{17962}",
		body = [=[/cast sid{17962}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "3",
	},
	["BRUL"] = {
		--Brûlure de l'ombre
		show = "sid{17877}",
		body = [=[/stopcasting
			/cast sid{17877}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "3",
	},
	["TDC"] = {
		--Trait du chaos
		show = "sid{116858}",
		body = [=[/cast sid{116858}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "3",
	},
	["DpsDemono"] = {
		show = "sid{686}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsWarlock
			/click [modifier, harm, nodead] gotMacros_TDL
			/click [nomodifier, harm, nodead] gotMacros_TDL]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "2",
	},
	["TDL"] = {
		--Trait de l'ombre
		body = [=[/cast sid{686}]=],
		class = "WARLOCK",
		spec = "2",
	},
	["FDL"] = {
		--Feu de l'âme
		show = "sid{6353}",
		body = [=[/cast sid{6353}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "2",
	},
	["MDG"] = {
		--Main de Gul'dan
		show = "sid{105174}",
		body = [=[/cast sid{105174}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "2",
	},
	["COR"] = {
		--Corruption
		show = "sid{172}",
		body = [=[/cast sid{172}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
		spec = "2",
	},
}