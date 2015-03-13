--[[	$Id: mage.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if (caelUI.myChars or caelUI.herChars) then return end

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
		spec = "1, 2, 3",
	},
	["T1"] = {
		icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
		body = [=[/cleartarget [exists]
			/assist [target=pet, exists]Pet
			/stopmacro [target=pettarget, exists]
			/targetenemy [target=pet, dead][target=pet, noexists]]=],
		class = "MAGE",
		spec = "1, 2, 3",
	},
	["Int"] = {
		--Contresort
		show = "sid{2139}",
		body = [=[/stopcasting
			/cast [target=focus, exists][target=target] sid{2139}]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "1, 2, 3",
	},
	["Blink"] = {
		--Transfert
		show = "sid{1953}",
		body = [=[/stopcasting
			/cast sid{1953}]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "1, 2, 3",
	},
	["IceB"] = {
		--Bloc de glace
		show = "sid{45438}",
		body = [=[/stopcasting
			/cancelaura sid{45438},
			/cast sid{45438}]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "1, 2, 3",
	},
	["EDG"] = {
		--Eclaire de givre
		body = [=[/cast sid{116}
			/petattack]=],
		class = "MAGE",
		spec = "3",
	},
	["EDGF"] = {
		--Eclair de givrefeu
		show = "sid{44614}",
		body = [=[/cast sid{44614}]=],
		class = "MAGE",
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "3",
	},
	["JDG"] = {
		--Javelot de glace
		show = "sid{30455}",
		body = [=[/cast sid{30455}]=],
		class = "MAGE",
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "3",
	},
	["BDF"] = {
		--Boule de feu
		body = [=[/cast sid{133}]=],
		class = "MAGE",
		spec = "2",
	},
	["PYRO"] = {
		--Explosion pyrotechnique
		show = "sid{11366}",
		body = [=[/cast sid{12043},
					/cast sid{11366}]=],
		class = "MAGE",
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "2",
	},
	["DDA"] = {
		--Déflagration des Arcanes
		body = [=[/cast sid{30451}]=],
		class = "MAGE",
		spec = "1",
	},
	["CDsMage"] = {
		body = [=[/castsequence reset=0.1 Presence of Mind, null]=],
		class = "MAGE",
	},
	["Burst"] = {
		--Burst arcane, Arcane Power, Alter Time, Arcane Missiles
		show = "sid{12042}",
		body = [=[/cast sid{12042},
					/cast sid{108978},
					/cast sid{5143}]=],
		class = "MAGE",
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "1",
	},
	["DpsG"] = {
		show = "sid{116}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsMage
			/click [harm, nodead] gotMacros_EDG]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "3",
	},
	["DpsF"] = {
		show = "sid{133}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsMage
			/click [harm, nodead] gotMacros_BDF]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "2",
	},
	["DpsA"] = {
		show = "sid{30451}",
		body = [=[/click [noexists][noharm][dead] gotMacros_T1
			/click [combat, harm, nodead] gotMacros_CDsAll
			/click [combat, harm, nodead] gotMacros_CDsMage
			/click [harm, nodead] gotMacros_DDA]=],
		blizzmacro = true,
		perChar = true,
		class = "MAGE",
		spec = "1",
	},
}