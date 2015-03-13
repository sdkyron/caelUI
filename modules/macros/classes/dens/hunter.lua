--[[	$Id: hunter.lua 3956 2014-11-28 07:01:01Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

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
		-- Marque du chasseur, Call Pet: IDs = 883, 83242, 83243, 83244, 83245
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
		--	Marque du chasseur
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/castsequence [harm] reset=0 sid{1130}
			/focus [help, nodead]]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["MD"] = {
		-- Détournement
		show = "sid{34477}",
		body = [=[/click focusButton
			/cast [help][target=focus, help][target=pet, exists, nodead] sid{34477}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	},
	["CSBS"] = {
		-- Tir de lien, Trait de choc
		show = "[modifier] sid{109248}; sid{5116}",
		body = [=[/cast [modifier] sid{109248}; sid{5116}]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2, 3",
	}, 
	["TS"] = {
		-- Tir tranquillisant
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
		-- Tir mortel
		show = "sid{53351}",
		body = [=[/castsequence reset=0 sid{53351}, null]=],
		nosound = true,
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "1, 2",
	},
	["RF"] = {
		-- tir rapide
		body = [=[/cast sid{3045}]=],
		class = "HUNTER",
		spec = "2",
	},
	["BW"] = {
		-- Couroux bestial
		body = [=[/cast [target=pettarget, exists] sid{19574}]=],
		nosound = true,
		class = "HUNTER",
		spec = "1",
	},
	["KC"] = {
		-- Ordre de tuer, Tir-auto
		body = [=[/castsequence [target=pettarget, exists] reset=5.5 sid{34026}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "1",
	},
	["ASa"] = {
		-- Tir de arcanes, Tir assuré/Tir du cobra
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=2 sid{3044}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}]=],
		class = "HUNTER",
		spec = "1",
	},
	["MSa"] = {
		-- Flèches multiples, Tir assuré/Tir du cobra
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=2 sid{2643}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}]=],
		nosound = true,
		class = "HUNTER",
		spec = "1",
	},
	["BM"] = {
		-- Ordre de tuer
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
		-- Flèches multiples
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
		-- Tir de la chimère, Tir-auto
		body = [=[/castsequence reset=8.3 sid{53209}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "2",
	},
	["ASb"] = {
		-- Tir assuré/Tir du cobra, Visée
		body = [=[/castsequence [mod] sid{56641}; reset=2 sid{56641}, sid{56641}, sid{19434}]=],
		class = "HUNTER",
		spec = "2",
	},
	["MSb"] = {
		-- Flèches multiples, Tir assuré
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
		-- Tir de la chimère
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
		-- Flèches multiples
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
		-- Flèche noire, Auto-Shot
		body = [=[/castsequence reset=19.3 sid{3674}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
		class = "HUNTER",
		spec = "3",
	},
	["ES"] = {
		-- Tir explosif, Tir assuré/Tir du cobra, Tir de arcanes
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=5.9 sid{53301}, sid{3044}, lvl{<81?sid{56641}:sid{77767}}, lvl{<81?sid{56641}:sid{77767}}, sid{3044}]=],
		class = "HUNTER",
		spec = "3",
	},
	["MSc"] = {
		-- Flèches multiples, Tir assuré/Tir du cobra
		body = [=[/castsequence [mod] lvl{<81?sid{56641}:sid{77767}}; [nomod] reset=2 sid{2643}, lvl{<81?sid{56641}:sid{77767}}]=],
		nosound = true,
		class = "HUNTER",
		spec = "3",
	},
	["SVR"] = {
		-- Tir-Auto
		body = [=[/click gotMacros_SS
			/click gotMacros_GT
			/click gotMacros_BA
			/click gotMacros_ES]=],
		nosound = true,
		class = "HUNTER",
		spec = "3",
	},
	["SV"] = {
		-- Tir explosif
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
		-- Flèches multiples
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
		-- Tir explosif
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