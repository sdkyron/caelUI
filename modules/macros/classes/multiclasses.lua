--[[	$Id: multiclasses.lua 3961 2014-12-02 08:25:22Z sdkyron@gmail.com $	]]

--[==[ 1.36 with 2.47 base speed (1.3 with 2.37)
	gM_Macros = {
		name = {		Macroname, these need to be unique
			body,		Macrobody, 1023 chars max. Use either linebreaks in long comments [=[ ]=] or \n.
			blizzmacro,	1/nil - Specifies whether or not you want to create a /click macro for it.
			perChar,	1/nil - Specifies whether you want the macro to be char specific.
					If char specific macros are full, it will be created as general by default.
			show,		When set uses #showtooltip in combination with the value of this field.
					You should NOT include #showtooltip, just the condition.
			char,		List the playernames (case-sensitive) of the characters for whom this macro
					should be used. Defaults to all chars when not set.
			icon,		Texture path or macro icon index. Defaults to 1 (question mark) when not set or invalid.
		},
	}

	example:
	
	gM_Macros = {
		["test"] = {
			body = [=[/run print("Hi!")
				/run print("Apples!")]=],
			blizzmacro = true,
		},
		["someothertest"] = {
			body = "/run print('apples')\n/run print('oranges')",
			blizzmacro = true,
			perChar = true,
		},
	}
]==]--

local multiClasses

multiClasses = {
	["T2"] = {
		body = [=[/cleartarget [exists]
			/click tabButton]=],
	},
	["PreMount"] = {
		body = [=[/cancelform
			/leavevehicle
			/dismount]=],
	},
	["GWM"] = {
	-- Goblin Weather Machine - Prototype 01-B
		body = [=[/use iid{35227}]=],
	},
	["CD"] = {
		-- Blood Fury, Berserking, Arcane Torrent, Lifeblood
		body = [=[/click gotMacros_GWM
				/cast sid{20572}
				/cast sid{26297}
				/cast sid{80483}
				/cast sid{81708}
				/use [mod] 13; [nomod] 14]=], -- 10 Gloves, 13 Trinket 1, 14 Trinket 2
		nosound = true,
	},
	["Mark"] = {
		body = [=[/script if IsInGroup() and not UnitIsPlayer("target") then if GetRaidTargetIndex("target") ~= 8 then SetRaidTargetIcon("target", 8) end end]=],
	},
}

if multiClasses then
	if not gM_Macros then
		gM_Macros = {}
	end

	for k, v in pairs(multiClasses) do
		gM_Macros[k] = v
	end

	multiClasses = nil
end