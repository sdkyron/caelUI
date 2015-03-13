--[[	$Id: mage.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "MAGE" then return end

gM_Macros = {
	["TGT"] = {
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/targetenemy [noexists][noharm][dead]
			/cast [nomodifier, nopet]Summon Water Elemental
			/petpassive [target=pettarget,exists]
			/stopmacro [target=pettarget,exists]
			/petassist
			/petattack]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
	},
	["T1"] = {
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/cleartarget [exists]
			/assist [target=pet, exists]Pet
			/stopmacro [target=pettarget, exists]
			/targetenemy [target=pet, dead][target=pet, noexists]]=],
		class = "MAGE",
	},
	["Counterspell"] = {
		show = "Counterspell",
		body = [=[/stopcasting
			/cast [target=focus, exists][target=target] Counterspell]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
	},
	["Blink"] = {
		show = "Blink",
		body = [=[/stopcasting
			/cast Blink]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
	},
	["Frostbolt"] = {
		body = [=[/cast Frostbolt
			/petattack]=],
		class = "MAGE",
		spec = "3",
	},
	["CDsMage"] = {
		body = [=[/castsequence reset=0.1 Presence of Mind, null]=],
		class = "MAGE",
	},
	["Dps"] = {
		show = "Frostbolt",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CD
			/click [combat, harm, nodead] gotMacros_CDsMage
			/click [harm, nodead] gotMacros_Frostbolt]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "3",
	},
}