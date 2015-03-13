--[[	$Id: hunter - old.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "HUNTER" then return end

gM_Macros = {
	["T1"] = {
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/cleartarget [exists]
			/assist [target=pet, exists]Pet
			/stopmacro [target=pettarget, exists]
			/click [target=pet, dead][target=pet, noexists] tabButton]=],
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["TGT"] = {
		-- Hunter's Mark, Call Pet 1, Call pet 2
		show = "sid{1130}",
		body = [=[/click [noexists][noharm][dead] tabButton
			/cast [nomodifier, nopet] sid{883};[modifier, nopet] sid{83242}
			/castsequence [harm]reset=target sid{1130}, null
			/petpassive [target=pettarget,exists]
			/stopmacro [target=pettarget,exists]
			/petattack]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	}, 
	["Foc"] = {
		--	Hunter's Mark
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/castsequence [harm] reset=0 sid{1130}, null
			/focus [help, nodead]]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["MisD"] = {
		-- Misdirection
		show = "sid{34477}",
		body = [=[/click focusButton
			/cast [help][target=focus, help][target=pet, exists, nodead] sid{34477}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["CDsHunt"] = {
		-- Rapid Fire, Readiness
		body = [=[/castsequence reset=4.5 sid{3045}, sid{23989}, null]=],
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["KillS"] = {
		-- Kill Shot
		show = "sid{53351}",
		body = [=[/stopmacro [noharm][dead]
			/stopcasting
			/castsequence reset=2 sid{53351}, sid{53351}, null]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["Tranq"] = {
		-- Tranquilizing Shot
		show = "sid{19801}",
		body = [=[/cast [target=mouseover, exists] sid{19801}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["SrS"] = {
		-- Serpent Sting
		body = [=[/castsequence reset=target sid{1978}, null]=],
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["Glaives"] = {
		-- Glaive Toss
		body = [=[/castsequence reset=14.8 sid{117050}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["Multi"] = {
		-- Multi-Shot, Steady Shot/Cobra Shot
		body = [=[/castsequence reset=5.5 sid{2643}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}]=],
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["BmR"] = {
		-- Kill Command
		show = "sid{34026}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead] gotMacros_CD
			/click [combat, harm, nodead] gotMacros_CDsBM
			/click [modifier, combat, harm, nodead] gotMacros_CDsHunt
			/click [harm, nodead] gotMacros_RotA]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1",
	},
	["RotA"] = {
		-- Auto-Shot
		body = [=[/cast !sid{75}
			/click gotMacros_SrS
			/click [target=pet, exists, nodead] gotMacros_KillC
			/click gotMacros_Glaives
			/click gotMacros_ArcSa]=],
		nosound = true,
		class = "HUNTER",
		spec = "1",
	},
	["AoEBM"] = {
		-- Multi-Shot
		show = "sid{2643}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead] gotMacros_CD
			/click [combat, harm, nodead] gotMacros_CDsBM
			/click [modifier, combat, harm, nodead] gotMacros_CDsHunt
			/click [target=pet, exists, nodead] gotMacros_KillC
			/click gotMacros_Glaives
			/click [harm, nodead] gotMacros_Multi]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1",
	},
	["KillC"] = {
		-- Kill Command, Auto-Shot
		body = [=[/castsequence reset=5.5 sid{34026}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "1",
	},
	["ArcSa"] = {
		-- Arcane Shot, Steady Shot/Cobra Shot
		body = [=[/castsequence reset=3/combat sid{3044}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}]=],
		class = "HUNTER",
		spec = "1",
	},
	["CDsBM"] = {
		-- Bestial Wrath
		body = [=[/cast [target=pettarget, exists] sid{19574}]=],
		nosound = true,
		class = "HUNTER",
		spec = "1",
	},
	["MmR"] = {
		-- Chimera Shot
		show = "sid{53209}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead] gotMacros_CD
			/click [modifier, combat, harm, nodead] gotMacros_CDsHunt
			/click [harm, nodead] gotMacros_RotB]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "2",
	},
	["RotB"] = {
		-- Auto-Shot
		body = [=[/cast !sid{75}
			/click gotMacros_SrS
			/click gotMacros_ChmS
			/click gotMacros_ArcSb]=],
		nosound = true,
		class = "HUNTER",
		spec = "2",
	},
	["ChmS"] = {
		-- Chimera Shot, Auto-Shot
		body = [=[/castsequence reset=9.3 sid{53209}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "2",
	},
	["ArcSb"] = {
		-- Steady Shot, Arcane Shot
		body = [=[/castsequence reset=3/combat sid{56641}, sid{56641}, sid{3044}, sid{56641}, sid{56641}, sid{3044}]=],
		class = "HUNTER",
		spec = "2",
	},
	["AimS"] = {
		-- Steady Shot, Aimed Shot
		show = "sid{19434}",
		body = [=[/castsequence reset=2.56 sid{56641}, sid{56641}, !sid{19434}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "2",
	},
	["SvR"] = {
		-- Explosive Shot
		show = "sid{53301}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead] gotMacros_CD
			/click [modifier, combat, harm, nodead] gotMacros_CDsHunt
			/click [harm, nodead] gotMacros_RotC]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "3",
	},
	["RotC"] = {
		-- Auto-Shot
		body = [=[/cast !sid{75}
			/click gotMacros_SrS
			/click gotMacros_ExpS
			/click gotMacros_BlkA]=],
		nosound = true,
		class = "HUNTER",
		spec = "3",
	},
	["BlkA"] = {
		-- Black Arrow, Auto-Shot
		body = [=[/castsequence reset=23.3 sid{3674}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "3",
	},
	["ExpS"] = {
		-- Explosive Shot, Steady Shot/Cobra Shot, Arcane Shot
		body = [=[/castsequence reset=5.9/combat sid{53301}, lvl{<81?sid{56641}:sid{77767}}, sid{3044}, lvl{<81?sid{56641}:sid{77767}}]=], -- body = [=[/castsequence reset=1.6 sid{53301}, sid{3044}, lvl{<81?sid{56641}:sid{77767}}, sid{3044}, lvl{<81?sid{56641}:sid{77767}}]=],
		class = "HUNTER",
		spec = "3",
	},
	["LnL"] = {
		-- Explosive Shot
		show = "sid{53301}",
		body = [=[/stopmacro [noharm][dead]
			/stopcasting
			/castsequence reset=0 sid{53301}, null]=],
		nosound = true,
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "3",
	}
}