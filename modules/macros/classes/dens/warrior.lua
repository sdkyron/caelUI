--[[	$Id: warrior.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "WARRIOR" then return end

gM_Macros = {
	["Initiate"] = {
		-- Intervene, Charge
		show = "[help] sid{3411}; sid{100}",
		body = [=[/click [noexists][nohelp, noharm][dead] gotMacros_T2
			/click [nodead] gotMacros_Range]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
	},
	["Range"] = {
		-- Defensive Stance, Intervene, Charge
		body = [=[/cast [stance:1/3, help] sid{71}; [stance:2, help] sid{3411}; [stance:1/2/3, harm] sid{100}]=],
		class = "WARRIOR",
	},
	["Fury"] = {
		-- Bloodthirst
		show = "sid{23881}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsFury
			/click [modifier, harm, nodead] gotMacros_MainFuryAoE
			/click [nomodifier, harm, nodead] gotMacros_MainFuryST]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
		spec = "2",
	},
	["MainFuryST"] = {
		-- Bloodthirst, Heroic Strike
		body = [=[/startattack
			/cast sid{23881}]=],
		class = "WARRIOR",
		spec = "2",
	},
	["MainFuryAoE"] = {
		-- Bloodthirst, Cleave
		body = [=[/startattack
			/castsequence reset=3 sid{23881}, sid{23881}, sid{845}, sid{23881}, sid{845}]=],
		class = "WARRIOR",
		spec = "2",
	},
	["CDsFury"] = {
		-- Rage de berserker, Bain de sang
		body = [=[/cast sid{18499}
					/cast sid{12292}]=],
		class = "WARRIOR",
		spec = "2",
	},
	["RBlow"] = {
		-- Raging Blow
		show = "sid{85288}",
		body = [=[/cast sid{85288}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
		spec = "2",
	},
	["Whirl"] = {
		-- Whirlwind
		show = "sid{1680}",
		body = [=[/cast sid{1680}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
		spec = "1, 2",
	},
	["Arms"] = {
		-- Berserker Stance, Mortal Strike
		show = "sid{12294}",
		body = [=[/cast [nostance:3] sid{2458}
			/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsArms
			/click [harm, nodead] gotMacros_MainArms]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
		spec = "1",
	},
	["MainArms"] = {
		-- Mortal Strike, Slam, Heroic Strike
		body = [=[/startattack
			/castsequence reset=4.5 sid{12294}, sid{1464}, sid{1464}, sid{78}]=],
		class = "WARRIOR",
		spec = "1",
	},
	["CDsArms"] = {
		-- Berserker Rage, Sweeping Strikes
		body = [=[/cast sid{18499}
			/Cast sid{12328}]=],
		class = "WARRIOR",
		spec = "1",
	},
	["Protection"] = {
		-- Shield Slam
		show = "sid{23922}",
		body = [=[/cast [nostance:2] Defensive Stance
			/click [noexists][noharm][dead] gotMacros_T2
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [modifier, combat, harm, nodead] gotMacros_CDsProtection
			/click [harm, nodead] gotMacros_MainProtection]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
		spec = "3",
	},
	["Mark"] = {
		body = [=[/script if IsInGroup() and not UnitIsPlayer("target") then if GetRaidTargetIndex("target") ~= 8 then SetRaidTargetIcon("target", 8) end end]=],
		class = "WARRIOR",
		spec = "3",
	},
	["MainProtection"] = {
		-- Shield Slam, Devastate
		body = [=[/startattack
			/castsequence reset=combat/4.5 sid{23922}, sid{20243}, sid{20243}, sid{20243}]=],
		class = "WARRIOR",
		spec = "3",
	},
	["CDsProtection"] = {
		-- Shield Block
		body = [=[/cast sid{2565}]=],
		class = "WARRIOR",
		spec = "3",
	},
	["OverRev"] = {
		-- Overpower, Revenge
		show = "[stance:1] sid{7384}; [stance:2] sid{6572}",
		body = [=[/cast [stance:1, noequipped:Shields] sid{7384}; [stance:1, equipped:Shields] sid{71}; [stance:2, noequipped:Shields] sid{2457}; [stance:2, equipped:Shields] sid{6572}; [stance:3, noequipped:Shields] sid{2457}; [stance:3, equipped:Shields] sid{71}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
		spec = "1, 3",
	},
	["Taunt"] = {
		-- Taunt
		show = "sid{355}",
		body = [=[/cast [nostance:2] sid{71}; sid{355}]=],
		blizzmacro = true,
		perChar = true,
		class = "WARRIOR",
		spec = "1, 2, 3",
	},
}