--[[	$Id: hunter.lua 3954 2014-10-28 08:14:13Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "HUNTER" then return end

if not gM_Macros then gM_Macros = {} end

-- Every entry in the Sequences table defines a single sequence of macros which behave similarly to /castsequence.
-- Sequence names must be unique and contain no more than 16 characters.
-- To use a macro sequence, create a blank macro in-game with the same name you picked for the sequence here and it will overwrite it.

-- StepFunction optionally defines how the step is incremented when pressing the button.
-- This example increments the step in the following order: 1 12 123 1234 etc. until it reaches the end and starts over
-- DO NOT DEFINE A STEP FUNCTION UNLESS YOU THINK YOU KNOW WHAT YOU'RE DOING

-- PreMacro is optional macro text that you want executed before every single button press.
-- This is if you want to add something like /startattack or /stopcasting before all of the macros in the sequence.

-- PostMacro is optional macro text that you want executed after every single button press.
--[==[
		StepFunction = [[
			order = newtable(1, 2, 3, 4)

			newstep = (newstep and (newstep % #order + 1)) or 2
			step = order[newstep]
		]],

		StepFunction = [[
			limit = limit or 1
			if step == limit then
				limit = limit % #macros + 1
				step = 1
			else
				step = step % #macros + 1
			end
		]],

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

		StepFunction = [[
			steps = "112"

			limit = string.len(steps) or 1

			if current == nil then
				current = 1
			end

			if current >= limit then
				current = 1
			else
				current = current + 1
			end

			step = tonumber(strsub(steps, current, current))
		]],
--]==]

--[[	MULTI SPECS	]]

gM_Macros["PreMacro"] = {
	body = [=[/cleartarget [noharm][dead]
		/cast [target=pet, dead] sid{55709}; [spec:1, nopet] sid{83242}; [spec:2, nopet, talent:7/1] sid{883}; [spec:2, nopet, talent:7/2] sid{883}
		/click [target=focus, noexists] focusButton
		/petassist [spec:1][spec:2, talent:7/1][spec:2, talent:7/2]
		/petattack [spec:1][spec:2, talent:7/1][spec:2, talent:7/2]
		/stopmacro [harm, nodead]
		/assist [target=pet, exists] Pet
		/stopmacro [target=pettarget, exists]
		/click [target=pet, dead][target=pet, noexists] tabButton]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["PostMacro"] = {
	-- Spirit Mend, Roar of Sacrifice
	body = [=[
		/petautocaston [target=focus, noexists] sid{2649}
		/petautocastoff [target=focus, exists] sid{2649}
		/cast [target=player, pet:Spirit Beast] sid{90361}
		/cast [target=player, pet] sid{53480}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["TGT"] = {
	-- Hunter's Mark, Call Pet: IDs = 883, 83242, 83243, 83244, 83245
	icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [harm, nodead] gotMacros_PreMount
		/cast [target=pet, dead] sid{55709}; [spec:1, nopet] sid{83242}; [spec:2, nopet, talent:7/2] sid{883}
		/petpassive [target=pettarget,exists]
		/petassist [target=pettarget,noexists]
		/stopmacro [target=pettarget,exists]
		/petattack [spec:1][spec:2, talent:7/2]]=],
	blizzmacro = true,
	perChar = true,
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["MD"] = {
	-- Misdirection
	show = "sid{34477}",
	body = [=[/cast [help][target=focus, help][target=pet, exists, nodead] sid{34477}]=],
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

gM_Macros["CSTS"] = {
	-- Counter Shot, Tranquilizing Shot
	show = "[mod] sid{19801}; sid{147362}",
	body = [=[/cast [mod] sid{19801}; sid{147362}]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["DB"] = {
	-- Dire Beast
	body = [=[/cast sid{120679}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["AMoC"] = {
	-- A Murder of Crows
	body = [=[/cast sid{131894}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["GT"] = {
	-- Glaive Toss
	body = [=[/cast sid{117050}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["KS"] = {
	-- Kill Shot
	show = "sid{53351}",
	body = [=[/stopcasting
		/stopcasting
		/castsequence [nochanneling] reset=0 sid{53351}, null]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1, 2",
}

--[[	BEAST MASTERY	]]

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

gM_Macros["BW"] = {
	-- Bestial Wrath
	body = [=[/cast [nomod] sid{19574}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["KC"] = {
	-- Kill Command
	body = [=[/cast [nomod] sid{34026}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["KCAS"] = {
	-- Kill Command, Arcane Shot
	body = [=[/castsequence [nomod] reset=5.8 sid{34026}, !sid{75}, sid{3044}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["KCMS"] = {
	-- Kill Command, Multi-Shot
	body = [=[/castsequence [nomod] reset=5.8 sid{2643}, sid{34026}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["FFKC"] = {
	-- Focus Fire, Kill Command
	body = [=[/castsequence [nomod] reset=19.8 sid{82692}, sid{34026}, sid{34026}, sid{34026}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["ASCS"] = {
	-- Arcane Shot, Steady Shot
	body = [=[/cast [mod] sid{3044}; [nomod] lvl{<81?sid{56641}|sid{77767}}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["MSCS"] = {
	-- Multi-Shot, Steady Shot
	body = [=[/cast [mod] sid{2643}; [nomod] lvl{<81?sid{56641}|sid{77767}}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["BeastST"] = {

	blizzmacro = true, 
	perChar = true,
	class = "HUNTER",
	spec = "1",
	show = "[mod] sid{3044}; [nomod] sid{34026}",

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
	/click [nochanneling] gotMacros_PreMacro
	/click [nochanneling, combat, harm, nodead] gotMacros_CD
		]],

		-- Step 1
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_KC
		]],

		-- Step 2
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_BW
		]],

		-- Step 3
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_KCAS
		]],

		-- Step 4
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_FFKC
		]],

		-- Step 5
		[[
	/click [nochanneling] gotMacros_ASCS
		]],

		-- Step 6
		[[
	/click [nochanneling] gotMacros_DB
		]],


		PostMacro =
		[[
	/click [combat, nochanneling] gotMacros_PostMacro
		]],
	}
}

gM_Macros["BeastMT"] = {

	blizzmacro = true, 
	perChar = true,
	class = "HUNTER",
	spec = "1",
	show = "sid{2643}",

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
	/click [nochanneling] gotMacros_PreMacro
		]],

		-- Step 1
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_KC
		]],

		-- Step 2
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_BW
		]],

		-- Step 3
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_KCMS
		]],

		-- Step 4
		[[
	/click [nochanneling, target=pettarget, exists] gotMacros_FFKC
		]],

		-- Step 5
		[[
	/click [nochanneling] gotMacros_MSCS
		]],

		-- Step 6
		[[
	/click [nochanneling] gotMacros_DB
		]],

		PostMacro =
		[[
	/click [combat, nochanneling] gotMacros_PostMacro
		]],
	}
}

--[[	MARKSMANSHIP	]]

gM_Macros["CS"] = {
	-- Focussing Shot/Steady Shot, Chimaera Shot
	body = [=[/cast [mod, talent:7/2] sid{163485}; [mod] sid{56641}; [nomod] sid{53209}]=],
	nosound = true,
	class = "HUNTER",
	spec = "2",
}

gM_Macros["AS"] = {
	-- Aimed Shot
	body = [=[/cast sid{19434}]=],
	nosound = true,
	class = "HUNTER",
	spec = "2",
}

gM_Macros["FSSS"] = {
	-- Focussing Shot/Steady Shot
	body = [=[/cast [nomod, talent:7/2] sid{163485}; [nomod] sid{56641}]=],
	nosound = true,
	class = "HUNTER",
	spec = "2",
}

gM_Macros["AimS"] = {
	-- Aimed Shot
	show = "sid{19434}",
	body = [=[/click [nochanneling] gotMacros_PreMacro
		/click [nochanneling, combat, harm, nodead] gotMacros_CD
		/cast [nochanneling, harm, nodead] sid{19434}]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "2",
}

gM_Macros["MultiS"] = {
	-- Multi-Shot
	show = "sid{2643}",
	body = [=[/click [nochanneling] gotMacros_PreMacro
		/click [nochanneling, combat, harm, nodead] gotMacros_CD
		/cast [nochanneling, harm, nodead] sid{2643}]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "2",
}

gM_Macros["Marks"] = {

	blizzmacro = true, 
	perChar = true,
	class = "HUNTER",
	spec = "2",
	show = "sid{53209}",

	sequence = {
		StepFunction = [[
			order = newtable(1, 1, 1, 2)

			newstep = (newstep and (newstep % #order + 1)) or 2
			step = order[newstep]
		]],

		PreMacro =
		[[
	/click [nochanneling] gotMacros_PreMacro
	/click [nochanneling, combat, harm, nodead] gotMacros_CD
		]],

		-- Step 1
		[[
	/click [nochanneling] gotMacros_CS
		]],

		-- Step 2
		[[
	/click [nochanneling] gotMacros_FSSS
		]],

		PostMacro =
		[[
	/click [combat, nochanneling] gotMacros_PostMacro
		]],
	}
}

--[[	SURVIVAL	]]

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
	/click [nochanneling] gotMacros_PreMacro
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
		-- A Murder of Crows
		[[
	/console Sound_EnableSFX 0
	/cast sid{131894}
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
	/click [nochanneling] gotMacros_PreMacro
		]],

		-- Step 1
		-- Black Arrow
		[[
	/console Sound_EnableSFX 0
	/castsequence reset=0 sid{3674}, null
	/console Sound_EnableSFX 1
		]],

		-- Step 3
		-- A Murder of Crows
		[[
	/console Sound_EnableSFX 0
	/cast sid{131894}
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