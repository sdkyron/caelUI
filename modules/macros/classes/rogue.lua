--[[	$Id: rogue.lua 3954 2014-10-28 08:14:13Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "ROGUE" then return end

if not gM_Macros then gM_Macros = {} end

----/dump gotMacros_MacroName.CurrentAction
-- Every entry in the Sequences table defines a single sequence of macros which behave similarly to /castsequence.
-- Sequence names must be unique and contain no more than 16 characters.

-- StepFunction optionally defines how the step is incremented when pressing the button.
-- This example increments the step in the following order: 1 12 123 1234 etc. until it reaches the end and starts over.

-- PreMacro is optional macro text that you want executed before every single button press.
-- This is if you want to add something like /startattack or /stopcasting before all of the macros in the sequence.

-- PostMacro is optional macro text that you want executed after every single button press.
----
-- [stance:0] is no Stealth, Shadow Dance or Vanish
-- [stance:1] is Stealth
-- [stance:2] is Vanish
-- [stance:3] is Shadow Dance

-- [stealth] is Stealth or Vanish
-- [stance] is Stealth, Shadow Dance or Vanish

-- If you want something to use Stealth, but not Subterfuge, use [stealth].

-- If you want something to use Subterfuge, but not Stealth, use [nostealth, stance:1]

-- For both, just use [stance:1].
----

gM_Macros["TGT"] = {
	-- Shadowstep
	show = "talent{4,2?sid{36554}|sid{108212}}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/cast talent{4,2?sid{36554}|sid{108212}}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
} 

gM_Macros["Stealth"] = {
	-- Stealth, Cloak of Shadows, Vanish
	show = "[nocombat] [combat, stance:1/2/3] sid{1784}; [combat, nostance] sid{31224}",
	body = [=[/castsequence reset=59 [nocombat] [combat, stance:1/2/3] sid{1784}; [combat, nostance] sid{31224}, sid{1856}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["Trick"] = {
	-- Tricks of the Trade
	body = [=[/click focusButton
		/cast [combat, help][combat, target=focus, help] sid{57934}]=],
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["CheapSlice"] = {
	-- Cheap Shot, Slice and Dice
	show = "[stealth] sid{1833}; sid{5171}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/cast [stealth] sid{1833}; sid{5171}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["AoESap"] = {
	-- Sap, Fan of Knives
	show = "[stealth] sid{6770}; [nostealth, spec:1] sid{13877}; [nostealth, spec:2] sid{51723}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/castsequence [stealth] sid{6770}; [nostealth, spec:1] sid{13877}; [nostealth, spec:2] reset=2/target sid{51723}, sid{51723}, sid{121411}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["PickRup"] = {
	-- Pick Pocket, Rupture
	show = "[nocombat, stealth] sid{921}; sid{1943}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/cast [nocombat, stealth] sid{921}; sid{1943}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["Finish"] = {
	-- Kidney Shot, Eviscerate (Death from Above)
	show = "[modifier] sid{408}; [nomodifier] talent{7,3?sid{152150}|sid{2098}}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/castsequence [modifier, harm, nodead] sid{408}; [nomodifier, harm, nodead] reset=19 talent{7,3?sid{152150}|sid{2098}}, sid{2098}, sid{2098}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["ARVDT"] = {
	-- Adrenaline Rush, (Vendetta)
	show = "[spec:1] sid{13750}; [spec:2] sid{79140}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/cast [spec:1, harm, nodead] sid{13750}; [spec:2, harm, nodead] sid{79140}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2",
}

gM_Macros["AssaFront"] = {
	-- Garrote, Mutilate
	show = "[stance:1/2/3] sid{703}; [nostance] sid{1329}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/click [modifier, combat, harm, nodead, nostance] gotMacros_ARVDT
		/click [harm, nodead] gotMacros_Trick
		/cast [harm, nodead, stance:1/2/3] sid{703}; [harm, nodead, nostance] sid{1329}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1",
}

gM_Macros["AssaBack"] = {
	-- Ambush, Dispatch
	show = "[stance:1/2/3] sid{8676}; [nostance] sid{111240}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/click [modifier, combat, harm, nodead, nostance] gotMacros_ARVDT
		/click [harm, nodead] gotMacros_Trick
		/cast [harm, nodead, stance:1/2/3] sid{8676}; [harm, nodead, nostance] sid{111240}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1",
}

gM_Macros["CbtFront"] = {
	-- Garrote, Revealing Strike, Sinister Strike
	show = "[stance:1/2/3] sid{703}; [nostance] sid{1752}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/click [modifier, combat, harm, nodead, nostance] gotMacros_ARVDT
		/click [harm, nodead] gotMacros_Trick
		/castsequence [harm, nodead, stance:1/2/3] sid{703}; [harm, nodead, nostance] reset=target sid{84617}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "2",
}

gM_Macros["CbtBack"] = {
	-- Ambush
	show = "[stance:1/2/3] sid{8676}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/click [harm, nodead] gotMacros_Trick
		/cast [harm, nodead, stance:1/2/3] sid{8676}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "2",
}

gM_Macros["SubFront"] = {
	-- Garrote, Hemorrhage
	show = "[stealth][stance:2/3] sid{703}; [nostealth, stance:1][nostance] sid{16511}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/click [harm, nodead] gotMacros_Trick
		/cast [harm, nodead, stealth][harm, nodead, stance:2/3] sid{703}; [harm, nodead, nostealth, stance:1][harm, nodead, nostance] sid{16511}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "3",
}

gM_Macros["SubCD"] = {
	-- Shadow Reflection, Shadow Dance
	body = [=[/castsequence reset=119 sid{152151}, sid{51713}, sid{51713}]=],
	class = "ROGUE",
	spec = "3",
}

gM_Macros["SubBack"] = {

	blizzmacro = true, 
	perChar = true,
	class = "ROGUE",
	spec = "3",
	show = "[stance:1/2/3] sid{8676}; [nostance] sid{53}",

	sequence = {
		StepFunction = [[
			local repeatCount = 8
			limit = limit or 1
			repsDone = repsDone or 1

			if step == limit then
				if (limit == #macros and repsDone < repeatCount) then
					repsDone = repsDone + 1
				else
					limit = limit % #macros + 1
					step = 1
					repsDone = 1
				end
			else
				step = step % #macros + 1
			end
		]],

		PreMacro =
		[[
	/click [noexists][noharm][dead] gotMacros_T2
	/click [combat, harm, nodead, nostance] gotMacros_CD
	/click focusButton
	/click [harm, nodead] gotMacros_Trick
		]],

		-- Step 1
		-- Premeditation
		[[
	#show sid{14183}
	/console Sound_EnableSFX 0
	/cast [combat, harm, nodead, stealth][combat, harm, nodead, stance:2/3] sid{14183}
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Shadow Reflection, Shadow Dance
		[[
	/console Sound_EnableSFX 0
	/click [combat, harm, nodead, nostance] gotMacros_SubCD
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- Ambush, Hemorrhage, Backstab
		[[
	/console Sound_EnableSFX 0
	/castsequence [harm, nodead, stance:1/2/3] sid{8676}; [harm, nodead, nostance] reset=target/2 sid{16511}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}
	/console Sound_EnableSFX 1
		]],
	}
}