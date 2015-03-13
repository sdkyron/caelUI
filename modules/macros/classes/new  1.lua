gM_Macros["Finish"] = {
	-- Kidney Shot, Eviscerate
	show = "[modifier] sid{408}; [nomodifier] sid{2098}",
	body = [=[/click [noexists][noharm][dead] gotMacros_T2
		/click [combat, harm, nodead, nostance] gotMacros_CD
		/cast [modifier, harm, nodead] sid{408}; [nomodifier, harm, nodead] sid{2098}]=],
	blizzmacro = true,
	perChar = true,
	class = "ROGUE",
	spec = "1, 2, 3",
}

gM_Macros["SubBack"] = {

	blizzmacro = true, 
	perChar = true,
	class = "ROGUE",
	spec = "3",

	sequence = {
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
	/console Sound_EnableSFX 0
	/castsequence [harm, nodead, stance:1/2/3] reset=0 sid{14183}, null
	/console Sound_EnableSFX 1
		]],

		-- Step 1
		-- Shadow Reflection
		[[
	/castsequence [combat, harm, nodead, nostance] reset=0 sid{152151}, null
		]],

		-- Step 1
		-- Shadow Dance
		[[
	/castsequence [combat, harm, nodead, nostance] reset=0 sid{51713}, null
		]],

		-- Step 4
		-- Ambush, Hemorrhage, Backstab
		[[
	/console Sound_EnableSFX 0
	/castsequence [harm, nodead, stance:1/2/3] reset=0 sid{8676}, null; [harm, nodead, nostance] reset=target/2 sid{16511}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}, sid{53}
	/console Sound_EnableSFX 1
		]],
	}
}