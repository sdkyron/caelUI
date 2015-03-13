--[[	$Id: rogue.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "ROGUE" then return end

gM_Macros = {
	["TGT"] = {
		-- Shadowstep, Burst of Speed
		show = "[spec:1] sid{36554}; [spec:2] sid{108212}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/cast [spec:1] sid{36554}; [spec:2] sid{108212}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	}, 
	["Stealth"] = {
		-- Stealth, Cloak of Shadows, Vanish
		show = "[nocombat, stealth] sid{1784}; [nocombat, nostealth] sid{1784}; [combat, stealth] sid{1784}; [combat, nostealth] sid{31224}",
		body = [=[/castsequence reset=60 [nocombat, stealth] sid{1784}; [nocombat, nostealth] sid{1784}; [combat, stealth] sid{1784}; [combat, nostealth] sid{31224}, sid{1856}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["Trick"] = {
		-- Tricks of the Trade
		show = "sid{57934}",
		body = [=[/click focusButton
			/cast [help][target=focus, help] sid{57934}]=],
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["Shadowstep"] = {
		-- Shadowstep
		body = [=[/castsequence reset=target sid{36554}, null]=],
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["CheapSlice"] = {
		-- Cheap Shot, Slice and Dice
		show = "[stealth] sid{1833}; [nostealth] sid{5171}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [spec:1, harm, nodead, stealth] gotMacros_Shadowstep
			/cast [harm, nodead, stealth] sid{1833}; [nostealth] sid{5171}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["FoKSapStun"] = {
		-- Sap, Fan of Knives, Gouge
		show = "[stealth] sid{6770}; [spec:1, nostealth] sid{51723}; [spec:2, nostealth] sid{1776}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [spec:1, modifier, harm, nodead, stealth] gotMacros_Shadowstep
			/click [combat, harm, nodead, nostealth] gotMacros_CDsAll
			/cast [harm, nodead, stealth] sid{6770}; [spec:1, nostealth] sid{51723}; [spec:2, nostealth] sid{1776}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["Finish"] = {
		-- Envenom
		show = "sid{32645}",
		body = [=[/click [combat, harm, nodead, nostealth] gotMacros_CDsAll
			/cast [harm, nodead] sid{32645}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1",
	},
	["AssaFront"] = {
		-- Garrote, Mutilate
		show = "[stealth] sid{703}; [nostealth] sid{1329}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [modifier, harm, nodead] gotMacros_Trick
			/click [spec:1, modifier, harm, nodead, stealth] gotMacros_Shadowstep
			/click [combat, harm, nodead, nostealth] gotMacros_CDsAll
			/cast [harm, nodead, stealth] sid{703}; [harm, nodead, nostealth] sid{1329}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1",
	},
	["AssaBack"] = {
		-- Ambush, Dispatch
		show = "[stealth] sid{8676}; [nostealth] sid{111240}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [modifier, harm, nodead] gotMacros_Trick
			/click [spec:1, modifier, harm, nodead, stealth] gotMacros_Shadowstep
			/click [combat, harm, nodead, nostealth] gotMacros_CDsAll
			/cast [harm, nodead, stealth] sid{8676}; [harm, nodead, nostealth] sid{111240}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1",
	},
	["RevStrike"] = {
		-- Revealing Strike
		body = [=[/castsequence reset=target sid{84617}, null]=],
		class = "ROGUE",
		spec = "2",
	},
	["CbtFront"] = {
		-- Garrote, Sinister Strike
		show = "[stealth] sid{703}; [nostealth] sid{1752}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [modifier, harm, nodead] gotMacros_Trick
			/click [modifier, harm, nodead, stealth] gotMacros_Shadowstep
			/click [combat, harm, nodead, nostealth] gotMacros_CDsAll
			/click [harm, nodead] gotMacros_RevStrike
			/cast [harm, nodead, stealth] sid{703}; [harm, nodead, nostealth] sid{1752}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "2",
	},
	["CbtBack"] = {
		-- Ambush, Blade Flurry
		show = "[stealth] sid{8676}; [nostealth] sid{13877}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [modifier, harm, nodead] gotMacros_Trick
			/click [modifier, harm, nodead, stealth] gotMacros_Shadowstep
			/click [combat, harm, nodead, nostealth] gotMacros_CDsAll
			/cast [harm, nodead, stealth] sid{8676}; [harm, nodead, nostealth] sid{13877}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "2",
	},
}