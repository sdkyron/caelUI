--[[	$Id: warlock.lua 3805 2013-12-24 12:49:21Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "WARLOCK" then return end

gM_Macros = {
	["T1"] = {
		body = [=[/cleartarget [exists]
			/assist [target=pet, exists]Pet
			/stopmacro [target=pettarget, exists]
			/click [target=pet, dead][target=pet, noexists] tabButton]=],
		class = "WARLOCK",
	},
	["TGT"] = {
		show = "[pet:Imp] Summon Imp; [pet:Voidwalker] Summon Voidwalker; Auto Attack",
		body = [=[/targetenemy [noexists][noharm][dead]
			/cast [nomodifier, nopet]Summon Imp; [modifier, nopet]Summon Voidwalker
			/petpassive [target=pettarget,exists]
			/stopmacro [target=pettarget,exists]
			/petassist
			/petattack]=],
		blizzmacro = true,
		perChar = true,
		class = "WARLOCK",
	}
}