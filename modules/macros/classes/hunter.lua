--[[	$Id: hunter.lua 3954 2014-10-28 08:14:13Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "HUNTER" then return end

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

gM_Macros["T1"] = {
	body = [=[/cleartarget [exists]
		/assist [target=pet, exists]Pet
		/stopmacro [target=pettarget, exists]
		/click [target=pet, dead][target=pet, noexists] tabButton]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["TGT"] = {
	-- Hunter's Mark, Call Pet: IDs = 883, 83242, 83243, 83244, 83245
	icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/cast [target=pet, dead] sid{55709}; [spec:1, nopet, nodead] sid{883};[spec:2, nopet, nodead] sid{83242}
		/dismount [harm, nodead]
		/petfollow [target=pettarget,exists]
		/stopmacro [target=pettarget,exists]
		/petassist
		/petattack]=],
	blizzmacro = true,
	perChar = true,
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["MD"] = {
	-- Misdirection
	show = "sid{34477}",
	body = [=[/click focusButton
		/cast [help][target=focus, help][target=pet, exists, nodead] sid{34477}]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["CSBS"] = {
	-- Binding Shot, Concussive Shot
	show = "[modifier] sid{109248}; sid{5116}",
	body = [=[/cast [modifier] sid{109248}; sid{5116}]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["TS"] = {
	-- Tranquilizing Shot
	show = "sid{19801}",
	body = [=[/cast [target=mouseover, exists] sid{19801}]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["KS"] = {
	-- Kill Shot
	show = "sid{53351}",
	body = [=[/castsequence reset=0 sid{53351}, null]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1, 2",
}

gM_Macros["FF"] = {
	-- Focus Fire
	show = "sid{82692}",
	body = [=[/castsequence [nochanneling] reset=0 sid{82692}, null]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["LL"] = {
		-- Explosive Shot
		show = "sid{53301}",
		body = [=[/stopmacro [noharm][dead]
			/stopcasting
			/castsequence reset=0 sid{53301}, null]=],
		blizzmacro = true,
		perChar = true,
		class = "HUNTER",
		spec = "3",
	}

gM_Macros["SurvST"] = {

	blizzmacro = true, 
	perChar = true,
	class = "HUNTER",
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
	/click [noexists][noharm][dead] gotMacros_T1
	/click [combat, harm, nodead, nostance] gotMacros_CD
		]],

		-- Step 1
		-- Black Arrow
		[[
	/console Sound_EnableSFX 0
	/cast sid{3674}
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Explosive Shot
		[[
	/console Sound_EnableSFX 0
	/cast sid{53301}
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- A Murder of Crows, Barrage
		[[
	/console Sound_EnableSFX 0
	/castsequence reset=59 sid{131894}, sid{120360}, sid{120360}, sid{120360}
	/console Sound_EnableSFX 1
		]],

		-- Step 6
		-- Steady/Cobra shot, Arcane Shot
		[[
	/console Sound_EnableSFX 0
	/castsequence [mod] lvl{<81?sid{56641}|sid{77767}}; [nomod] reset=combat lvl{<81?sid{56641}|sid{77767}}, lvl{<81?sid{56641}|sid{77767}}, sid{3044}, lvl{<81?sid{56641}|sid{77767}}
	/console Sound_EnableSFX 1
		]],

		PostMacro = [[
		]]
	}
}
-- talent{7,2?lvl{<81?sid{56641}|sid{152245}}|lvl{<81?sid{56641}|sid{77767}}}
gM_Macros["SurvMT"] = {

	blizzmacro = true, 
	perChar = true,
	class = "HUNTER",
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
	/click [noexists][noharm][dead] gotMacros_T1
	/click [combat, harm, nodead] gotMacros_CD
		]],

		-- Step 1
		-- Black Arrow
		[[
	/console Sound_EnableSFX 0
	/castsequence reset=0 sid{3674}, null
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- A Murder of Crows, Barrage
		[[
	/console Sound_EnableSFX 0
	/castsequence reset=59 sid{131894}, sid{120360}, sid{120360}, sid{120360}
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Multi-Shot, Steady/Cobra Shot
		[[
	/console Sound_EnableSFX 0
	/castsequence [mod] lvl{<81?sid{56641}|sid{77767}}; [nomod] reset=combat lvl{<81?sid{56641}|sid{77767}}, lvl{<81?sid{56641}|sid{77767}}, sid{2643}, lvl{<81?sid{56641}|sid{77767}}
	/console Sound_EnableSFX 1
		]],

		PostMacro = [[
		]]
	}
}

gM_Macros["BeastST"] = {

	blizzmacro = true, 
	perChar = true,
	class = "HUNTER",
	spec = "1",

	sequence = {
		StepFunction = [[
			order = newtable(1, 2, 3, 4, 5, 5, 3, 4, 5)

			newstep = (newstep and (newstep % #order + 1)) or 2
			step = order[newstep]
		]],

		PreMacro =
		[[
	/click [noexists][noharm][dead] gotMacros_T1
	/click [combat, harm, nodead] gotMacros_CD
	/click focusButton
		]],

		-- Step 1
		-- Bestial Wrath
		[[
	#show sid{19574}
	/console Sound_EnableSFX 0
	/cast [nochanneling] sid{19574}
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Dire Beast
		[[
	/console Sound_EnableSFX 0
	/cast [nochanneling] sid{120679}
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- Kill Shot
		[[
	/console Sound_EnableSFX 0
	/cast [nochanneling] sid{53351}
	/console Sound_EnableSFX 1
		]],

		-- Step 4
		-- Kill Command
		[[
	/console Sound_EnableSFX 0
	/cast [nochanneling] sid{34026}
	/console Sound_EnableSFX 1
		]],

		-- Step 5
		-- Arcane Shot, Steady/Cobra Shot
		[[
	/console Sound_EnableSFX 0
	/castsequence [mod, nochanneling] sid{3044}; [nomod, nochanneling] reset=5.8/combat lvl{<81?sid{56641}|sid{77767}}, sid{3044}, lvl{<81?sid{56641}|sid{77767}}
	/console Sound_EnableSFX 1
		]],

		PostMacro = [[
		]]
	}
}

gM_Macros["BeastMT"] = {

	blizzmacro = true, 
	perChar = true,
	class = "HUNTER",
	spec = "1",

	sequence = { 
		StepFunction = [[
			order = newtable(1, 2, 3, 4, 5, 5, 3, 4, 5)

			newstep = (newstep and (newstep % #order + 1)) or 2
			step = order[newstep]
		]],

		PreMacro =
		[[
	/click [noexists][noharm][dead] gotMacros_T1
	/click [combat, harm, nodead] gotMacros_CD
		]],

		-- Step 1
		-- Bestial Wrath
		[[
	#show sid{19574}
	/console Sound_EnableSFX 0
	/cast [combat, nochanneling] sid{19574}
	/console Sound_EnableSFX 1
		]],

		-- Step 2
		-- Dire Beast
		[[
	/console Sound_EnableSFX 0
	/cast [nochanneling] sid{120679}
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- Kill Shot
		[[
	/console Sound_EnableSFX 0
	/cast [nochanneling] sid{53351}
	/console Sound_EnableSFX 1
		]],

		-- Step 4
		-- Kill Command
		[[
	/console Sound_EnableSFX 0
	/cast [nochanneling] sid{34026}
	/console Sound_EnableSFX 1
		]],

		-- Step 5
		-- Multi-Shot, Steady/Cobra Shot
		[[
	/console Sound_EnableSFX 0
	/castsequence [mod, nochanneling] sid{2643}; [nomod, nochanneling] reset=5.8/combat lvl{<81?sid{56641}|sid{77767}}, sid{2643}, lvl{<81?sid{56641}|sid{77767}}
	/console Sound_EnableSFX 1
		]],

		PostMacro = [[
		]]
	}
}