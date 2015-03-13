--[[	$Id: hunter.lua 3954 2014-10-28 08:14:13Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "HUNTER" then return end

gM_Macros = {
	["T1"] = {
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/cleartarget [exists]
			/assist [target=pet, exists]Pet
			/stopmacro [target=pettarget, exists]
			/click [target=pet, dead][target=pet, noexists] tabButton]=],
		nosound = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["FE"] = {
		-- Fetch
		body = [=[/targetlasttarget [noexists]
			/cast [exists] Fetch]=],
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["TGT"] = {
		-- Hunter's Mark, Call Pet: IDs = 883, 83242, 83243, 83244, 83245
		show = "sid{1130}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/cast [spec:1, nopet] sid{883};[spec:2, nopet] sid{83242}
			/castsequence [harm]reset=target sid{1130}
			/petfollow [target=pettarget,exists]
			/stopmacro [target=pettarget,exists]
			/petassist
			/petattack]=],
		blizzmacro = true,
		perChar = true,
		nosound = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["Foc"] = {
		--	Hunter's Mark
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/castsequence [harm] reset=0 sid{1130}
			/focus [help, nodead]]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["MD"] = {
		-- Misdirection
		show = "sid{34477}",
		body = [=[/click focusButton
			/cast [help][target=focus, help][target=pet, exists, nodead] sid{34477}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["CSBS"] = {
		-- Binding Shot, Concussive Shot
		show = "[modifier] sid{109248}; sid{5116}",
		body = [=[/cast [modifier] sid{109248}; sid{5116}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	}, 
	["TS"] = {
		-- Tranquilizing Shot
		show = "sid{19801}",
		body = [=[/cast [target=mouseover, exists] sid{19801}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["GT"] = {
		-- Glaive Toss
		body = [=[/castsequence reset=14.8 sid{117050}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["KS"] = {
		-- Kill Shot
		show = "sid{53351}",
		body = [=[/castsequence reset=0 sid{53351}, null]=],
		nosound = true,
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2",
	},
	["RF"] = {
		-- Rapid Fire
		body = [=[/cast sid{3045}]=],
		class = "HUNTER",
		spec = "2",
	},
	["BW"] = {
		-- Bestial Wrath
		body = [=[/cast [target=pettarget, exists] sid{19574}]=],
		nosound = true,
		class = "HUNTER",
		spec = "1",
	},
	["KC"] = {
		-- Kill Command, Auto-Shot
		body = [=[/castsequence [target=pettarget, exists] reset=5.5 sid{34026}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "1",
	},
	["ASa"] = {
		-- Arcane Shot, Steady Shot/Cobra Shot
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=2 sid{3044}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}]=],
		class = "HUNTER",
		spec = "1",
	},
	["MSa"] = {
		-- Multi-Shot, Steady Shot/Cobra Shot
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=2 sid{2643}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}]=],
		nosound = true,
		class = "HUNTER",
		spec = "1",
	},
	["BM"] = {
		-- Kill Command
		show = "sid{34026}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CD
			/click gotMacros_GT
			/click [target=pet, exists, nodead] gotMacros_KC
			/click [target=pet, exists, nodead] gotMacros_BW
			/click gotMacros_ASa]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1",
	},
	["BMAoE"] = {
		-- Multi-Shot
		show = "sid{2643}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CD
			/click gotMacros_GT
			/click [target=pet, exists, nodead] gotMacros_KC
			/click [target=pet, exists, nodead] gotMacros_BW
			/click gotMacros_MSa]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1",
	},
	["CS"] = {
		-- Chimera Shot, Auto-Shot
		body = [=[/castsequence reset=8.3 sid{53209}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "2",
	},
	["ASb"] = {
		-- Steady Shot/Cobra Shot, Aimed Shot
		body = [=[/castsequence [mod] sid{56641}; reset=2 sid{56641}, sid{56641}, sid{19434}]=],
		class = "HUNTER",
		spec = "2",
	},
	["MSb"] = {
		-- Multi-Shot, Steady Shot
		body = [=[/castsequence [mod] sid{56641}; reset=2 sid{56641}, sid{56641}, sid{2643}, sid{2643}]=],
		nosound = true,
		class = "HUNTER",
		spec = "2",
	},
	["MMR"] = {
		body = [=[/click gotMacros_GT
			/click gotMacros_CS
			/click gotMacros_RF
			/click gotMacros_ASb]=],
		nosound = true,
		class = "HUNTER",
		spec = "2",
	},
	["MM"] = {
		-- Chimera Shot
		show = "sid{53209}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CD
			/click [harm, nodead] gotMacros_MMR]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "2",
	},
	["MMAoE"] = {
		-- Multi-Shot
		show = "sid{2643}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CD
			/click gotMacros_RF
			/click gotMacros_GT
			/click gotMacros_MSb]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "2",
	},
	["BA"] = {
		-- Black Arrow, Auto-Shot
		body = [=[/castsequence reset=19.3 sid{3674}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "3",
	},
	["ES"] = {
		-- Explosive Shot, Steady Shot/Cobra Shot, Arcane Shot
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=5.9 sid{53301}, sid{3044}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}, sid{3044}]=],
		class = "HUNTER",
		spec = "3",
	},
	["MSc"] = {
		-- Multi-Shot, Steady Shot/Cobra Shot
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=2 sid{2643}, lvl{<81?sid{56641}:sid{77767}}]=],
		nosound = true,
		class = "HUNTER",
		spec = "3",
	},
	["SVR"] = {
		-- Auto-Shot
		body = [=[/click gotMacros_SS
			/click gotMacros_GT
			/click gotMacros_BA
			/click gotMacros_ES]=],
		nosound = true,
		class = "HUNTER",
		spec = "3",
	},
	["SV"] = {
		-- Explosive Shot
		show = "sid{53301}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CD
			/click [harm, nodead] gotMacros_SVR]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "3",
	},
	["SVAoE"] = {
		-- Multi-Shot
		show = "sid{2643}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CD
			/click gotMacros_GT
			/click gotMacros_BA
			/click gotMacros_MSc]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "3",
	},
	["LL"] = {
		-- Explosive Shot
		show = "sid{53301}",
		body = [=[/stopmacro [noharm][dead]
			/stopcasting
			/castsequence reset=0 sid{53301}, null]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "3",
	}
}