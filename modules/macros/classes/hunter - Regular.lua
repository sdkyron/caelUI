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
		/click [target=focus, noexists] focusButton
		/stopmacro [harm, nodead]
		/assist [target=pet, exists] Pet
		/stopmacro [target=pettarget, exists]
		/click [target=pet, dead][target=pet, noexists] tabButton]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["PreMacro"] = {
	body = [=[/click [noexists][noharm][dead] gotMacros_T1
		/cast [target=pet, dead] sid{982}; [spec:1, nopet] sid{883}; [spec:2, nopet] sid{83242}
		/petautocaston [nogroup] sid{2649}
		/petautocastoff [group] sid{2649}
		/click [combat, harm, nodead] gotMacros_CD]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["TGT"] = {
	-- Hunter's Mark, Call Pet: IDs = 883, 83242, 83243, 83244, 83245
	icon = [=[Interface\Icons\Ability_Hunter_MasterMarksman]=],
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/dismount [harm, nodead]
		/cast [target=pet, dead] sid{982}; [spec:1, nopet] sid{883};[spec:2, nopet] sid{83242}
		/petpassive [target=pettarget,exists]
		/stopmacro [target=pettarget,exists]
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

gM_Macros["KS"] = {
	-- Kill Shot
	show = "sid{53351}",
	body = [=[/castsequence [nochanneling] reset=0 sid{53351}, null]=],
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

gM_Macros["BW"] = {
	-- Bestial Wrath, Auto Shot
	body = [=[/castsequence [nomod] reset=59 sid{19574}, !sid{75}, !sid{75}, !sid{75}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["DB"] = {
	-- Dire Beast
	body = [=[/castsequence reset=29.8 sid{120679}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1, 2, 3",
}

gM_Macros["KC"] = {
	-- Kill Command, Auto-Shot
	body = [=[/castsequence [nomod] reset=5.5 sid{34026}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["ASa"] = {
	-- Arcane Shot, Steady Shot
	body = [=[/castsequence [mod] sid{3044}; [nomod] reset=5 sid{3044}, lvl{<81?sid{56641}|sid{77767}}, lvl{<81?sid{56641}|sid{77767}}, lvl{<81?sid{56641}|sid{77767}}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["MSa"] = {
	-- Multi-Shot, Steady Shot
	body = [=[/castsequence [mod] lvl{<81?sid{56641}|sid{77767}}; [nomod] reset=5 sid{2643}, lvl{<81?sid{56641}|sid{77767}}, lvl{<81?sid{56641}|sid{77767}}, lvl{<81?sid{56641}|sid{77767}}]=],
	nosound = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["BeastST"] = {
	-- Kill Command
	show = "sid{34026}",
	body = [=[/click [nochanneling] gotMacros_PreMacro
		/click [nochanneling, target=pettarget, exists] gotMacros_BW
		/click [nochanneling] gotMacros_DB
		/click [nochanneling, target=pet, exists, nodead] gotMacros_KC
		/click [nochanneling] gotMacros_ASa]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["BeastMT"] = {
	-- Multi-Shot
	show = "sid{2643}",
	body = [=[/click [nochanneling] gotMacros_PreMacro
		/click [nochanneling, target=pettarget, exists] gotMacros_BW
		/click [nochanneling] gotMacros_DB
		/click [nochanneling, target=pet, exists, nodead] gotMacros_KC
		/click [nochanneling] gotMacros_MSa]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "1",
}

gM_Macros["MmR"] = {
	-- Chimera Shot
	show = "sid{53209}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T1
		/click [harm, nodead] gotMacros_Trick
		/click [combat, harm, nodead] gotMacros_CD
		/click [harm, nodead] gotMacros_RotB]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "2",
}
gM_Macros["RotB"] = {
	-- Auto-Shot
	body = [=[/cast !sid{75}
		/click gotMacros_ChmS
		/click gotMacros_ArcSb]=],
	nosound = true,
	class = "HUNTER",
	spec = "2",
}
gM_Macros["ChmS"] = {
	-- Chimera Shot, Auto-Shot
	body = [=[/castsequence reset=9.3 sid{53209}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
	class = "HUNTER",
	spec = "2",
}
gM_Macros["ArcSb"] = {
	-- Steady Shot, Arcane Shot
	body = [=[/castsequence reset=3/combat sid{56641}, sid{56641}, sid{3044}, sid{56641}, sid{56641}, sid{3044}]=],
	class = "HUNTER",
	spec = "2",
}
gM_Macros["AimS"] = {
	-- Steady Shot, Aimed Shot
	show = "sid{19434}",
	body = [=[/castsequence reset=2.56 sid{56641}, sid{56641}, !sid{19434}]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "2",
}
gM_Macros["SvR"] = {
	-- Explosive Shot
	show = "sid{53301}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T1
		/click [harm, nodead] gotMacros_Trick
		/click [combat, harm, nodead] gotMacros_CD
		/click [harm, nodead] gotMacros_RotC]=],
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "3",
}
gM_Macros["RotC"] = {
	-- Auto-Shot
	body = [=[/cast !sid{75}
		/click gotMacros_ExpS
		/click gotMacros_BlkA]=],
	nosound = true,
	class = "HUNTER",
	spec = "3",
}
gM_Macros["BlkA"] = {
	-- Black Arrow, Auto-Shot
	body = [=[/castsequence reset=23.3 sid{3674}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}, !sid{75}]=],
	class = "HUNTER",
	spec = "3",
}
gM_Macros["ExpS"] = {
	-- Explosive Shot, Steady Shot/Cobra Shot, Arcane Shot
	body = [=[/castsequence reset=5.9/combat sid{53301}, lvl{<81?sid{56641}|sid{77767}}, sid{3044}, lvl{<81?sid{56641}|sid{77767}}]=], -- body = [=[/castsequence reset=1.6 sid{53301}, sid{3044}, lvl{<81?sid{56641}|sid{77767}}, sid{3044}, lvl{<81?sid{56641}|sid{77767}}]=],
	class = "HUNTER",
	spec = "3",
}
gM_Macros["LnL"] = {
	-- Explosive Shot
	show = "sid{53301}",
	body = [=[/stopmacro [noharm][dead]
		/stopcasting
		/castsequence reset=0 sid{53301}, null]=],
	nosound = true,
	blizzmacro = true,
	perChar = true,
	class = "HUNTER",
	spec = "3",
}