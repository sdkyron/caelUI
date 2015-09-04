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

gM_Macros["PreMacro"] = {
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/click [target=focus, noexists] focusButton]=],
	nosound = true,
	class = "ROGUE",
	spec = "1, 2, 3",
} 

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
	show = "[nocombat][combat, stance:1/2/3] sid{1784}; [combat, nostance] sid{31224}",
	body = [=[/castsequence [nocombat][combat, stance:1/2/3] sid{1784}; [combat, nostance] reset=119 sid{31224}, sid{1856}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["Trick"] = {
	-- Tricks of the Trade
	body = [=[/click [target=focus, noexists] focusButton
		/cast [combat, help][combat, target=focus, help] sid{57934}]=],
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["CCSnD"] = {
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
	-- Sap, Fan of Knives/Crimson Tempest
	show = "[stealth] sid{6770}; [nostealth, spec:1] sid{121411}; [nostealth, spec:2] sid{51723}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/castsequence [stealth] sid{6770}; [nostealth, spec:1] sid{121411}; [nostealth, spec:2] reset=2/target sid{51723}, sid{51723}, sid{121411}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["Finish"] = {
	-- Kidney Shot, Eviscerate/Envenom (Death from Above)
	show = "[modifier] sid{408}; [nomodifier] talent{7,3?sid{152150}|sid{2098}}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/castsequence [modifier, harm, nodead] sid{408}; [nomodifier, harm, nodead] reset=19 talent{7,3?sid{152150}|sid{2098}}, sid{2098}, sid{2098}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["AssaCD"] = {
	-- Shadow Reflection, Vendetta
	body = [=[/castsequence reset=119 sid{152151}, sid{79140}]=],
	class = "ROGUE",
	spec = "1",
}

gM_Macros["AssaFront"] = {

	blizzmacro = true, 
	perChar = true,
	class = "ROGUE",
	spec = "1",
	show = "sid{1329}",

	sequence = {
		StepFunction = [[
			limit = limit or 1
			if step == limit then
				limit = limit % #macros + 1
				step = 1
			else
				step = step % #macros + 1
			end
		]],

		PreMacro =
		[[
	/click gotMacros_PreMacro
		]],

		-- Step 1
		-- Shadow Reflection, Shadow Dance
		[[
	/console Sound_EnableSFX 0
	/click [modifier, combat, harm, nodead, nostance] gotMacros_AssaCD
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Dispatch
		[[
	/console Sound_EnableSFX 0
	/cast [harm, nodead] sid{111240}
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- Mutilate
		[[
	/console Sound_EnableSFX 0
	/cast [harm, nodead] sid{1329}
	/console Sound_EnableSFX 1
		]],
	}
}

gM_Macros["AssaBack"] = {
	-- Ambush, Dispatch
	show = "[stance:1/2/3] sid{8676}; [nostance] sid{111240}",
	body = [=[/click gotMacros_PreMacro
		/cast [harm, nodead, stance:1/2/3] sid{8676}; [harm, nodead, nostance] sid{111240}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1",
}

gM_Macros["CbtFront"] = {

	blizzmacro = true, 
	perChar = true,
	class = "ROGUE",
	spec = "2",
	show = "[stance:1/2/3] sid{703}; [nostance] sid{1752}",

	sequence = {
		StepFunction = [[
			local repeatCount = 9
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
	/click gotMacros_PreMacro
		]],

		-- Step 1
		-- Adrenaline Rush
		[[
	/console Sound_EnableSFX 0
	/cast [modifier, combat, harm, nodead, nostance] sid{13750}
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Garrote, Revealing Strike, Sinister Strike
		[[
	/console Sound_EnableSFX 0
	/castsequence [harm, nodead, stance:1/2/3] sid{703}; [harm, nodead, nostance] reset=target sid{84617}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}, sid{1752}
	/console Sound_EnableSFX 1
		]],
	}
}

gM_Macros["CbtBack"] = {
	-- Ambush, Blade Flurry
	show = "[stance:1/2/3] sid{8676}; sid{13877}",
	body = [=[/click gotMacros_PreMacro
		/cast [harm, nodead, stance:1/2/3] sid{8676}; sid{13877}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "2",
}

gM_Macros["SubFront"] = {
	-- Garrote, Hemorrhage
	show = "[stealth][stance:2/3] sid{703}; [nostealth, stance:1][nostance] sid{16511}",
	body = [=[/click gotMacros_PreMacro
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
	/click gotMacros_PreMacro
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
	/castsequence [harm, nodead, stance:1/2/3] sid{8676}; [harm, nodead, nostance] reset=target/3 sid{16511}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}
	/console Sound_EnableSFX 1
		]],
	}
}