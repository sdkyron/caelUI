--[[	$Id: rogue - old.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "ROGUE" then return end

gM_Macros = {
	["TGT"] = {
		-- Shadowstep
		show = "sid{36554}",
		body = [=[/targetenemy [noexists][noharm][dead]
			/castsequence [harm] reset=0 sid{36554}, null]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	}, 
	["Stealth"] = {
		-- Stealth, Cloak of Shadows, Vanish
		show = "[nocombat, stealth] sid{1784}; [nocombat, nostealth] sid{1784}; [combat, stealth] sid{1784}; [combat, nostealth] sid{31224}",
		body = [=[/castsequence [nocombat, stealth] sid{1784}; [nocombat, nostealth] sid{1784}; [combat, stealth] sid{1784}; [combat, nostealth] sid{31224}, sid{1856}]=],
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
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["Shadowstep"] = {
		-- Shadowstep
		body = [=[/castsequence reset=target sid{36554}, null]=],
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["Stun"] = {
		-- Sap, Gouge
		show = "[stealth] sid{6770}; [nostealth] sid{1776}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/cast [harm, nodead, stealth] sid{6770}; [harm, nodead, nostealth] sid{1776}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["Finish"] = {
		-- Envenom, Eviscerate
		show = "[spec:1] sid{32645}; [spec:2] sid{2098}",
		body = [=[/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead, nostealth] gotMacros_CD
			/cast [spec:1, harm, nodead] sid{32645}; [spec:2, harm, nodead] sid{2098}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["CheapSlice"] = {
		-- Cheap Shot, Slice and Dice
		show = "[stealth] sid{1833}; [spec:2, stance:3] sid{1833}; [nostealth] sid{5171}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [harm, nodead, stealth] gotMacros_Shadowstep; [harm, nodead, spec:2, stance:3] gotMacros_Shadowstep
			/cast [harm, nodead, stealth] sid{1833}; [harm, nodead, spec:2, stance:3] sid{1833}; [nostealth] sid{5171}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["AoESap"] = {
		-- Sap, Fan of Knives
		show = "[stealth] sid{6770}; [spec:2, stance:3] sid{6770}; [nostealth] sid{51723}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead, nostealth] gotMacros_CD
			/cast [harm, nodead, stealth] sid{6770}; [harm, nodead, spec:2, stance:3] sid{6770}; [nostealth] sid{51723}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 2, 3",
	},
	["DPSFront"] = {
		-- Garrote, Mutilate/Hemorrhage
		show = "[stealth] sid{703}; [spec:2, stance:3] sid{703}; [nostealth, spec:1] sid{1329}; [nostealth, spec:2] sid{16511}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [harm, nodead] gotMacros_Trick
			/click [harm, nodead, stealth] gotMacros_Shadowstep; [harm, nodead, spec:2, stance:3] gotMacros_Shadowstep
			/click [combat, harm, nodead, nostealth] gotMacros_CD
			/cast [harm, nodead, stealth] sid{703}; [harm, nodead, spec:2, stance:3] sid{703}; [harm, nodead, nostealth, spec:1] sid{1329}; [harm, nodead, nostealth, spec:2] sid{16511}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 3",
	},
	["DPSBack"] = {
		-- Ambush, Dispatch/Backstab
		show = "[stealth] sid{8676}; [spec:2, stance:3] sid{8676}; [nostealth, spec:1] sid{111240}; [nostealth, spec:2] sid{53}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [harm, nodead] gotMacros_Trick
			/click [harm, nodead, stealth] gotMacros_Shadowstep; [harm, nodead, spec:2, stance:3] gotMacros_Shadowstep
			/click [combat, harm, nodead, nostealth] gotMacros_CD
			/cast [harm, nodead, stealth] sid{8676}; [harm, nodead, spec:2, stance:3] sid{8676}; [harm, nodead, nostealth, spec:1] sid{111240}; [harm, nodead, nostealth, spec:2] sid{53}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "1, 3",
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
			/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead, nostealth] gotMacros_CD
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
			/click [harm, nodead] gotMacros_Trick
			/click [combat, harm, nodead, nostealth] gotMacros_CD
			/cast [harm, nodead, stealth] sid{8676}; [harm, nodead, nostealth] sid{13877}]=],
		blizzmacro = true,
		perChar = true,
		class = "ROGUE",
		spec = "2",
	},
}