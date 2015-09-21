--[[	$Id: paladin.lua 3922 2014-03-23 10:54:32Z sdkyron@gmail.com $	]]

if not (caelUI.myChars or caelUI.herChars) then return end

if caelUI.playerClass ~= "PALADIN" then return end

if not gM_Macros then gM_Macros = {} end

----
-- Every entry in the Sequences table defines a single sequence of macros which behave similarly to /castsequence.
-- Sequence names must be unique and contain no more than 16 characters.

-- StepFunction optionally defines how the step is incremented when pressing the button.
-- This example increments the step in the following order: 1 12 123 1234 etc. until it reaches the end and starts over.

-- PreMacro is optional macro text that you want executed before every single button press.
-- This is if you want to add something like /startattack or /stopcasting before all of the macros in the sequence.

-- PostMacro is optional macro text that you want executed after every single button press.
----

gM_Macros["ASa"] = {
	-- Avenger's Shield
	show = "sid{31935}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead] gotMacros_CD
		/cast [harm, nodead] sid{31935}]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "PALADIN",
	spec = "2",
}

gM_Macros["AD"] = {
	-- Ardent Defender
	show = "sid{31850}",
	body = [=[/run print(("Ardent Defender will restore \124cff008000%d\124r HP when activated."):format((GetCombatRating(2) - 400) * UnitHealthMax("player") * (0.3 / 140)))
		/cast [combat, harm, nodead] sid{31850}]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "PALADIN",
	spec = "2",
}

gM_Macros["SotRWoG"] = {
	-- Shield of the Righteous, Word of Glory {136494} / Eternal Flame {114163}
	body = [=[/castsequence reset=combat sid{53600}, sid{53600}, sid{53600}, sid{136494}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2",
}

gM_Macros["CS"] = {
	-- Crusader Strike
	body = [=[/castsequence reset=7 sid{26573}, sid{35395}, sid{35395}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2, 3",
}

gM_Macros["HotR"] = {
	-- Hammer of the Righteous
	body = [=[/castsequence reset=7 sid{26573}, sid{53595}, sid{53595}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2, 3",
}

gM_Macros["JU"] = {
	-- Judgment
	body = [=[/cast sid{20271}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2, 3",
}

gM_Macros["EX"] = {
	-- Exorcism
	body = [=[/cast sid{122032}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2, 3",
}

gM_Macros["HW"] = {
	-- Holy Wrath
	body = [=[/cast sid{119072}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2",
}

gM_Macros["HP"] = {
	-- Holy Prism
	body = [=[/castsequence [target=player] reset=0 sid{114165}, null]=],
	nosound = true,
	class = "PALADIN",
	spec = "2, 3",
}

gM_Macros["CO"] = {
	-- Consecration
	body = [=[/castsequence sid{26573}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2, 3",
}

gM_Macros["SSDP"] = {
	-- Sacred Shield, Divine Protection
	body = [=[/castsequence reset=26.8 sid{20925}, sid{498}]=],
	nosound = true,
	class = "PALADIN",
	spec = "2, 3",
}

gM_Macros["ProtST"] = {

	blizzmacro = true, 
	perChar = true,
	class = "PALADIN",
	spec = "2",
	show = "sid{35395}",

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
	/click [combat, harm, nodead, nostance] gotMacros_CD
	/click focusButton
		]],

		-- Step 1
		[[
	/click gotMacros_SotRWoG
		]],

		-- Step 2
		[[
	/click [harm, nodead] gotMacros_CS
		]],

		-- Step 3
		[[
	/click [harm, nodead] gotMacros_JU
		]],

		-- Step 4
		[[
	/click [harm, nodead] gotMacros_HW
		]],

		-- Step 5
		[[
	/click [harm, nodead] gotMacros_HP
		]],

		-- Step 7
		[[
	/click [harm, nodead] gotMacros_SSDP
		]],

		PostMacro = [[
		]],
	}
}

gM_Macros["ProtMT"] = {

	blizzmacro = true, 
	perChar = true,
	class = "PALADIN",
	spec = "2",
	show = "sid{53595}",

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
	/click [combat, harm, nodead, nostance] gotMacros_CD
	/click focusButton
		]],

		-- Step 1
		[[
	/click gotMacros_SotRWoG
		]],

		-- Step 2
		[[
	/click [harm, nodead] gotMacros_HotR
		]],

		-- Step 3
		[[
	/click [harm, nodead] gotMacros_JU
		]],

		-- Step 4
		[[
	/click [harm, nodead] gotMacros_HW
		]],

		-- Step 5
		[[
	/click [harm, nodead] gotMacros_HP
		]],

		-- Step 7
		[[
	/click [harm, nodead] gotMacros_SSDP
		]],

		PostMacro = [[
		]],
	}
}

gM_Macros["FVDS"] = {
	-- Final Verdict, Divine Storm
	body = [=[/castsequence sid{157048}, sid{53385}]=],
	nosound = true,
	class = "PALADIN",
	spec = "3",
}

gM_Macros["RetST"] = {

	blizzmacro = true, 
	perChar = true,
	class = "PALADIN",
	spec = "3",
	show = "sid{53595}",

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
	/click [combat, harm, nodead, nostance] gotMacros_CD
	/click focusButton
		]],

		-- Step 1
		[[
	/click [harm, nodead] gotMacros_FVDS
		]],

		-- Step 2
		[[
	/click [harm, nodead] gotMacros_CS
		]],

		-- Step 3
		[[
	/click [harm, nodead] gotMacros_JU
		]],

		-- Step 4
		[[
	/click [harm, nodead] gotMacros_EX
		]],

		-- Step 5
		[[
	/cast Execution Sentence
		]],

		PostMacro = [[
		]],
	}
}