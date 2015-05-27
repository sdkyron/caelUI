--[[	$Id: druid.lua 3961 2014-12-02 08:25:22Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "DRUID" then return end

if not gM_Macros then gM_Macros = {} end

----
-- Every entry in the Sequences table defines a single sequence of macros which behave similarly to /castsequence.
-- Sequence names must be unique and contain no more than 16 characters.
-- To use a macro sequence, create a blank macro in-game with the same name you picked for the sequence here and it will overwrite it.

-- StepFunction optionally defines how the step is incremented when pressing the button.
-- This example increments the step in the following order: 1 12 123 1234 etc. until it reaches the end and starts over
-- DO NOT DEFINE A STEP FUNCTION UNLESS YOU THINK YOU KNOW WHAT YOU'RE DOING

-- PreMacro is optional macro text that you want executed before every single button press.
-- This is if you want to add something like /startattack or /stopcasting before all of the macros in the sequence.

-- PostMacro is optional macro text that you want executed after every single button press.
----

gM_Macros["TGT"] = {
	-- Faerie Fire
	show = "[modifier, stance:1] sid{16979}; [modifier, stance:2] sid{49376}; [modifier, nostance] sid{102401};  sid{770}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/cast [modifier, stance:1] sid{16979}; [modifier, stance:2] sid{49376}; [modifier, nostance] sid{102401}; sid{770}]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "DRUID",
	spec = "2, 3",
}

gM_Macros["HT"] = {
	-- Healing Touch (Dream of Cenarius)
	body = [=[/console autounshift 0
		/cast [nomodifier, stance:2, help][nomodifier, stance:2, target=focus, help][nomodifier, stance:2, target=player] sid{5185}; [modifier, stance:2, target=player] sid{5185}
		/console autounshift 1]=],
	class = "DRUID",
	spec = "2, 3",
}

gM_Macros["ClassShortCD"] = {
	-- Tiger's Fury, Barskin
	body = [=[/cast [spec:1, stance:2] sid{5217}
		/cast [spec:2, stance:1] sid{22812}]=],
	nosound = true,
	class = "DRUID",
	spec = "2, 3",
}

gM_Macros["ClassLongCD"] = {
	-- Berserk, Incarnation: King of the Jungle
	body = [=[/castsequence [stance:1] sid{50334}; [stance:2] reset=1 sid{102543}, sid{106951}]=],
	nosound = true,
	class = "DRUID",
	spec = "2, 3",
}

-- /dump gotMacros_FeralST.CurrentAction

gM_Macros["FeralST"] = {

	blizzmacro = true, 
	perChar = true,
	class = "DRUID",
	spec = "2",
	show = "[stance:1] sid{33917}; sid{5221}",

	sequence = {
		StepFunction = [[
			local repeatCount = 5
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
	/click [combat, harm, nodead, nostealth] gotMacros_CD
	/click [modifier, combat, harm, nodead, nostealth] gotMacros_ClassLongCD
	/click focusButton
		]],

		-- Step 2
		[[
	/console Sound_EnableSFX 0
	/console autounshift 0
	/cast [nomodifier, stance:2, help][nomodifier, stance:2, target=focus, help][nomodifier, stance:2, target=player] sid{5185}; [modifier, stance:2, target=player] sid{5185}
	/console autounshift 1
	/console Sound_EnableSFX 1
		]],

		-- Step 1
		[[
	/console Sound_EnableSFX 0
	/castsequence [stance:1] sid{33917}; [stance:2] reset=target/13.8 sid{1822}, sid{5221}, sid{5221}, sid{5221}
	/console Sound_EnableSFX 1
		]],

		PostMacro = [[
	/click [combat, harm, nodead, nostealth] gotMacros_ClassShortCD
		]]
	}
}

gM_Macros["FeralMT"] = {

	blizzmacro = true, 
	perChar = true,
	class = "DRUID",
	spec = "2",
	show = "[stance:1] sid{77758}; sid{106785}",

	sequence = {
		StepFunction = [[
			local repeatCount = 5
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
	/click [combat, harm, nodead, nostealth] gotMacros_CD
	/click [modifier, combat, harm, nodead, nostealth] gotMacros_ClassLongCD
	/click focusButton
		]],

		-- Step 2
		[[
	/console Sound_EnableSFX 0
	/console autounshift 0
	/cast [nomodifier, stance:2, help][nomodifier, stance:2, target=focus, help][nomodifier, stance:2, target=player] sid{5185}; [modifier, stance:2, target=player] sid{5185}
	/console autounshift 1
	/console Sound_EnableSFX 1
		]],

		-- Step 1
		[[
	/console Sound_EnableSFX 0
	/castsequence [stance:1] sid{77758}; [stance:2] reset=13.8 sid{106830}, sid{106785}, sid{106785}, sid{106785}
	/console Sound_EnableSFX 1
		]],

		PostMacro = [[
	/click [combat, harm, nodead, nostealth] gotMacros_ClassShortCD
		]]
	}
}

gM_Macros["GuardST"] = {

	blizzmacro = true, 
	perChar = true,
	class = "DRUID",
	spec = "3",

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
	/click [noexists][noharm][dead] gotMacros_T2
	/click [combat, harm, nodead, nostealth] gotMacros_CD
	/click [modifier, combat, harm, nodead, nostealth] gotMacros_ClassLongCD
	/click focusButton
		]],

		-- Step 1
		-- Pulverize, Thrash
		[[
	/console Sound_EnableSFX 0
	/castsequence reset=target/combat sid{80313}, sid{77758}
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Mangle
		[[
	/console Sound_EnableSFX 0
	/cast sid{33917}
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- Savage Defense
		[[
	/console Sound_EnableSFX 0
	/cast sid{62606}
	/console Sound_EnableSFX 1
		]],

		-- Step 4
		-- Lacerate
		[[
	/console Sound_EnableSFX 0
	/cast sid{33745}
	/console Sound_EnableSFX 1
		]],

		-- Step 5
		-- Healing Touch
		[[
	/console autounshift 0
	/console Sound_EnableSFX 0
	/cast [nomodifier, help][nomodifier, target=focus, help][nomodifier, target=player] sid{5185}; [modifier, target=player] sid{5185}
	/console Sound_EnableSFX 1
	/console autounshift 1
		]],

		PostMacro = [[
	/click [combat, harm, nodead, nostealth] gotMacros_ClassShortCD
		]]
	}
}