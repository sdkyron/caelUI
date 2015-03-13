--[[	$Id: druid.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "DRUID" then return end

gM_Macros = {
	["TGT"] = {
		-- Faerie Fire
		show = "[nomodifier] sid{770}; [modifier, stance:1] sid{16979}; [modifier, stance:3] sid{49376}; [nostance] sid{102401}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/cast [nomodifier] sid{770}; [modifier, stance:1, harm, nodead] sid{16979}; [modifier, stance:3, harm, nodead] sid{49376}, [nostance, help] sid{102401}]=],
		blizzmacro = true,
		perChar = true,
		class = "DRUID",
		spec = "2, 3",
	},
	["FeralFront"] = {
		-- Pounce, Mangle, Rake
		show = "[stealth] sid{9005}; [nostealth] sid{33876}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/castsequence [harm, nodead, stealth] reset=combat/2 sid{49376}, Savage Roar, Ravage, null
			/castsequence [harm, nodead, stealth] reset=target Rake, null
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsDruid
			/click [combat, harm, nodead, nostealth] gotMacros_SelfHeal
			/castsequence [combat, harm, nodead, nostealth] reset=target Mangle,Rip,Rake,Thrash,Faerie Fire,Mangle,Savage Roar,Mangle,Rake]=],
		blizzmacro = true,
		perChar = true,
		class = "DRUID",
		spec = "2, 3",
	},
	["SelfHeal"] = {
		-- Healing Touch, Nature’s Swiftness
		body = [=[/console autounshift 0
			/castsequence [target=player] reset=0.5 0, sid{5185}
			/console autounshift 1
			/use [nostealth] sid{132158}]=],
		class = "DRUID",
		spec = "2",
	},
	["FeralBack"] = {
		-- Ravage, Shred
		show = "[stealth] sid{6785}; [nostealth] sid{5221}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/castsequence [harm, nodead, stealth] reset=combat/2 sid{49376}, Savage Roar, Ravage, null
			/castsequence [harm, nodead, stealth] reset=target Rake, null
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsDruid
			/click [combat, harm, nodead, nostealth] gotMacros_SelfHeal
			/castsequence [combat, harm, nodead, nostealth] reset=target Shred,Rip,Rake,Thrash,Faerie Fire,Shred,Savage Roar,Shred,Rake]=],
		blizzmacro = true,
		perChar = true,
		class = "DRUID",
		spec = "2",
	},
	["Guardian"] = {
		-- Mangle, Thrash, Lacerate
		show = "sid{33878}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/castsequence [harm, nodead] reset=target sid{770}, sid{33878}, sid{77758}, sid{33745}
			/cast [harm, nodead] !sid{6807}]=],
		blizzmacro = true,
		perChar = true,
		class = "DRUID",
		spec = "2, 3",
	},
	["Swipe"] = {
		-- Trash, Swipe, Mangle
		body = [=[/castsequence reset=target/6 [stance:1] sid{77758}, sid{779}, sid{33878}, sid{779}; [stance:3] sid{106830}, sid{62078}, sid{62078}, sid{62078}]=],
		class = "DRUID",
		spec = "2, 3",
	},
	["AoE"] = {
		-- Berserk, Swipe, Maul
		show = "[stance:1] sid{779}, [stance:3] sid{62078}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/castsequence [harm, nodead, stealth] reset=combat/2 sid{49376}, Savage Roar, Ravage, null
			/castsequence [harm, nodead, stealth] reset=target Rake, null
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [stance:3, combat, harm, nodead] gotMacros_CDsDruid
			/click [combat, harm, nodead, nostealth] gotMacros_SelfHeal
			/castsequence [combat, harm, nodead, nostealth] reset=target Swipe,Rip,Rake,Thrash,Faerie Fire,Swipe,Savage Roar,Swipe,Rake]=],
		blizzmacro = true,
		perChar = true,
		class = "DRUID",
		spec = "2, 3",
	},
	["CDsDruid"] = {
		-- Berserk, Tiger's Fury
		body = [=[/cast sid{106951}
				/cast sid{5217}]=],
		nosound = true,
		class = "DRUID",
		spec = "2",
	},
}