--[[	$Id: paladin.lua 3922 2014-03-23 10:54:32Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "PALADIN" then return end

gM_Macros = {
	["ASa"] = {
		-- Avenger's Shield
		show = "sid{31935}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CD
			/cast [harm, nodead] sid{31935}]=],
		nosound = true,
		blizzmacro = true,
		perChar = true,
		class = "PALADIN",
		spec = "2",
	},
	["AD"] = {
		-- Ardent Defender
		show = "sid{31850}",
		body = [=[/run print(("Ardent Defender will restore \124cff008000%d\124r HP when activated."):format((GetCombatRating(2) - 400) * UnitHealthMax("player") * (0.3 / 140)))
			/cast [combat, harm, nodead] sid{31850}]=],
		nosound = true,
		blizzmacro = true,
		perChar = true,
		class = "PALADIN",
		spec = "2",
	},
	["HoW"] = {
		-- Hammer of Wrath
		body = [=[/castsequence reset=0.5 0, 0, 0, 0, sid{24275}]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["HW"] = {
		-- Holy Wrath
		body = [=[/castsequence reset=0.5 0, 0, 0, sid{119072}]=],
		nosound = true,
		class = "PALADIN",
		spec = "2",
	},
	["Exo"] = {
		-- Exorcism
		body = [=[/castsequence reset=0.5 0, 0, 0, sid{122032}]=],
		nosound = true,
		class = "PALADIN",
		spec = "3",
	},
	["JU"] = {
		-- Judgment
		body = [=[/castsequence reset=0.5 0, 0, sid{20271}]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["HotR"] = {
		-- Hammer of the Righteous
		body = [=[/castsequence reset=0.5 0, sid{53595}]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["CS"] = {
		-- Crusader Strike
		body = [=[/castsequence reset=0.5 0, sid{35395}]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["SotRWoG"] = {
		-- Shield of the Righteous, Word of Glory {136494} / Eternal Flame {114163}
		body = [=[/castsequence [spec:1, nomodifier, harm, nodead] reset=combat sid{53600}, sid{53600}, sid{53600}, sid{114163}; [spec:1, modifier] sid{114163}; [spec:2, nomodifier] sid{136494}]=],
		nosound = true,
		class = "PALADIN",
		spec = "2",
	},
	["DP"] = {
		-- Divine Protection
		body = [=[/castsequence reset=0 sid{498}, null]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["HP"] = {
		-- Holy Prism
		body = [=[/castsequence [target=player] reset=0 sid{114165}, null]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["HA"] = {
		-- Holy Avenger
		body = [=[/castsequence [modifier] reset=0 sid{105809}, null]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["AW"] = {
		-- Avenging Wrath
		body = [=[/castsequence [modifier] reset=0 sid{31884}, null]=],
		nosound = true,
		class = "PALADIN",
		spec = "2, 3",
	},
	["pST"] = {
		-- Crusader Strike
		show = "sid{35395}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CD
			/click [combat, harm, nodead] gotMacros_ClassCD
			/click [harm, nodead] gotMacros_HoW
			/click [harm, nodead] gotMacros_HW
			/click [harm, nodead] gotMacros_JU
			/click [harm, nodead] gotMacros_CS
			/click gotMacros_SotRWoG
			/click [harm, nodead] gotMacros_DP
			/click [harm, nodead] gotMacros_HP
			/click [harm, nodead] gotMacros_HA
			/click [harm, nodead] gotMacros_AW]=],
		blizzmacro = true,
		perChar = true,
		class = "PALADIN",
		spec = "2",
	},
	["pAoE"] = {
		-- Crusader Strike
		show = "sid{53595}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CD
			/click [combat, harm, nodead] gotMacros_ClassCD
			/click [harm, nodead] gotMacros_HoW
			/click [harm, nodead] gotMacros_HW
			/click [harm, nodead] gotMacros_JU
			/click [harm, nodead] gotMacros_HotR
			/click gotMacros_SotRWoG
			/click [harm, nodead] gotMacros_DP
			/click [harm, nodead] gotMacros_HP
			/click [harm, nodead] gotMacros_HA
			/click [harm, nodead] gotMacros_AW]=],
		blizzmacro = true,
		perChar = true,
		class = "PALADIN",
		spec = "2",
	},
	["rST"] = {
		-- Crusader Strike
		show = "sid{35395}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CD
			/click [combat, harm, nodead] gotMacros_ClassCD
			/click [harm, nodead] gotMacros_HoW
			/click [harm, nodead] gotMacros_Exo
			/click [harm, nodead] gotMacros_JU
			/click [harm, nodead] gotMacros_CS
			/click gotMacros_SotRWoG
			/click [harm, nodead] gotMacros_DP
			/click [harm, nodead] gotMacros_HP
			/click [harm, nodead] gotMacros_HA
			/click [harm, nodead] gotMacros_AW]=],
		blizzmacro = true,
		perChar = true,
		class = "PALADIN",
		spec = "3",
	},
	["rAoE"] = {
		-- Crusader Strike
		show = "sid{53595}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CD
			/click [combat, harm, nodead] gotMacros_ClassCD
			/click [harm, nodead] gotMacros_HoW
			/click [harm, nodead] gotMacros_Exo
			/click [harm, nodead] gotMacros_JU
			/click [harm, nodead] gotMacros_HotR
			/click gotMacros_SotRWoG
			/click [harm, nodead] gotMacros_DP
			/click [harm, nodead] gotMacros_HP
			/click [harm, nodead] gotMacros_HA
			/click [harm, nodead] gotMacros_AW]=],
		blizzmacro = true,
		perChar = true,
		class = "PALADIN",
		spec = "3",
	},
}