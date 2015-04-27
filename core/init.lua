--[[	$Id: init.lua 3978 2015-01-09 18:43:18Z sdkyron@gmail.com $	]]

local _, caelUI = ...

_G["caelUI"] = caelUI

caelUI.dummy = function() return end
caelUI.playerName = UnitName("player")
caelUI.playerClass = select(2, UnitClass("player"))
caelUI.playerSpec = GetSpecialization()
caelUI.playerRealm = GetRealmName()

caelUI.resolution = GetCVar("gxResolution")
caelUI.screenHeight = string.match(caelUI.resolution, "%d+x(%d+)")
caelUI.screenWidth = string.match(caelUI.resolution, "(%d+)x+%d")

local defaultScales = {
	["720"] = { ["576"] = 0.65},
	["800"] = { ["600"] = 0.7},
	["960"] = { ["600"] = 0.84},
	["1024"] = { ["600"] = 0.89, ["768"] = 0.7},
	["1152"] = { ["864"] = 0.7},
	["1176"] = { ["664"] = 0.93},
	["1280"] = { ["800"] = 0.84, ["720"] = 0.93, ["768"] = 0.87, ["960"] = 0.7, ["1024"] = 0.65},
	["1360"] = { ["768"] = 0.93},
	["1366"] = { ["768"] = 0.93},
	["1440"] = { ["900"] = 0.84},
	["1600"] = { ["1200"] = 0.7, ["1024"] = 0.82, ["900"] = 0.93},
	["1680"] = { ["1050"] = 0.84},
	["1768"] = { ["992"] = 0.93},
	["1920"] = { ["1440"] = 0.7, ["1200"] = 0.84, ["1080"] = 0.93},
	["2048"] = { ["1536"] = 0.7},
	["2560"] = { ["1600"] = 0.84, ["1440"] = 0.93},
	["5760"] = { ["1080"] = 0.93},
	["6060"] = { ["1080"] = 0.93},
}

UIScale = defaultScales[caelUI.screenWidth] and defaultScales[caelUI.screenWidth][caelUI.screenHeight] or min(2, max(0.64, 768/string.match(caelUI.resolution, "%d+x(%d+)")))

local ScaleFix = (768/tonumber(caelUI.resolution:match("%d+x(%d+)"))) / UIScale

local Scale = function(value)
    return ScaleFix * math.floor(value / ScaleFix + 0.5)
end

caelUI.scale = function(value) return Scale(value) end

caelUI.KillFrame = CreateFrame("Frame", nil, UIParent)
caelUI.KillFrame:Hide()

caelUI.kill = function(object)
    local objectReference = object

    if type(object) == "string" then
        objectReference = _G[object]
    else
        objectReference = object
    end

    if not objectReference then return end

	if objectReference.IsProtected then 
		if objectReference:IsProtected() then
			error("Attempted to kill a protected object: <"..objectReference:GetName()..">")
		end
	end

	if type(objectReference) == "Frame" then
		objectReference:UnregisterAllEvents()
		objectReference:SetParent(caelUI.KillFrame)
	elseif objectReference:GetObjectType() == "Texture" then
		objectReference:SetTexture(nil)
	else
		objectReference.Show = objectReference.Hide
	end

    objectReference:Hide()
end

caelUI.round = function(number, precision) -- return math.floor(value * (10 ^ 2) + 0.5) / 10 ^ 2
	precision = precision or 0

	local decimal = string.find(tostring(number), ".", nil, true)

	if decimal then
		local power = 10 ^ precision

		if number >= 0 then
			number = math.floor(number * power + 0.5) / power
		else
			number = math.ceil(number * power - 0.5) / power
		end

		-- convert number to string for formatting
		number = tostring(number)

		-- set cutoff
		local cutoff = number:sub(decimal + 1 + precision)

		-- delete everything after the cutoff
		number = number:gsub(cutoff, "")
	else
		-- number is an integer
		if precision > 0 then
			number = tostring(number)

			number = number .. "."

			for i = 1, precision do
				number = number .. "0"
			end
		end
	end

	number = tonumber(number)

	return number
end

caelUI.getspellname = function(id)
	local spellName = GetSpellInfo(id)

	return spellName or "NOT_FOUND"
end

local levelAdjust = {
	["1"] = 8, ["373"] = 4, ["374"] = 8, ["375"] = 4, ["376"] = 4, ["377"] = 4,
	["379"] = 4, ["380"] = 4, ["446"] = 4, ["447"] = 8, ["452"] = 8, ["454"] = 4,
	["455"] = 8, ["457"] = 8, ["459"] = 4, ["460"] = 8, ["461"] = 12, ["462"] = 16,
	["466"] = 4, ["467"] = 8, ["469"] = 4, ["470"] = 8, ["471"] = 12, ["472"] = 16,
	["477"] = 4, ["478"] = 8, ["480"] = 8, ["492"] = 4, ["493"] = 8, ["495"] = 4,
	["496"] = 8, ["497"] = 12, ["498"] = 16, ["504"] = 12, ["505"] = 16, ["506"] = 20,
	["507"] = 24
}

local itemSlots = {
	"Head", "Neck", "Shoulder", "Back", "Chest", "Wrist", "Hands", "Waist",
	"Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand"
}

caelUI.iLvl = function(unit) -- math.floor(select(2, GetAverageItemLevel("player")))
	local total, item = 0, 0

	for i = 1, #itemSlots do
		local slot = GetInventoryItemLink(unit, GetInventorySlotInfo(("%sSlot"):format(itemSlots[i])))

		if slot ~= nil then
			local _, _, _, ilvl = GetItemInfo(slot)
			local upgrade = slot:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:(%d+)")

			if ilvl ~= nil then
				item = item + 1
				total = total + ilvl + (upgrade and levelAdjust[upgrade] or 0)
			end
		end
	end

	if (total < 1 or item < 15) then
		return
	end
	
	return floor(total / item)
end

caelUI.utf8sub = function(string, numChars, dots)
	assert(string, "You need to provide a string to shorten. Usage: caelUI.utf8sub(string, numChars, includeDots)")
	assert(numChars, "You need to provide a length to shorten the string to. Usage: caelUI.utf8sub(string, numChars, includeDots)")

	local bytes = string:len()

	if bytes <= numChars then
		return string
	else
		local length, pos = 0, 1

		while pos <= bytes do
			length = length + 1

			local char = string:byte(pos)

			if char > 0 and char <= 127 then
				pos = pos + 1
			elseif char >= 192 and char <= 223 then
				pos = pos + 2
			elseif char >= 224 and char <= 239 then
				pos = pos + 3
			elseif char >= 240 and char <= 247 then
				pos = pos + 4
			end

			if length == numChars then
				break
			end
		end

		if length == numChars and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

caelUI.pattern = function(text, plain)
	text = gsub(text, "%%%d?$?c", ".+")
	text = gsub(text, "%%%d?$?s", ".+")
	text = gsub(text, "%%%d?$?d", "%%d+")
	text = gsub(text, "([%(%)])", "%%%1")

	return plain and text or ("^"..text)
end

caelUI.isGuild = function(unit)
	local numGuildMembers = GetNumGuildMembers()

	for i = 1, numGuildMembers do
		local member = GetGuildRosterInfo(i)

		member = Ambiguate(member, "guild")

		if unit == member then
			return true
		end
	end

	return false
end

caelUI.isFriend = function(unit)
	for i = 1, select(2, BNGetNumFriends()) do
		for j = 1, BNGetNumFriendToons(i) do
			if unit == select(2, BNGetFriendToonInfo(i, j)) then
				return true
			end
		end
	end
			
	for i = 1, GetNumFriends() do
		if unit == GetFriendInfo(i) then
			return true
		end
	end
	
	return false
end

local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Flash")

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(0.75)
	self.anim.fadeout:SetOrder(1)

	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(-0.75)
	self.anim.fadein:SetOrder(2)

	self.anim:SetLooping("BOUNCE")
end

caelUI.flash = function(self, duration)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	if not self.anim:IsPlaying() or duration ~= self.anim.fadein:GetDuration() then
		self.anim.fadein:SetDuration(duration)
		self.anim.fadeout:SetDuration(duration)
		self.anim:Play()
	end
end

caelUI.stopflash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

local myToons = {
	["Illidan"] = {
		["Deathknot"]	=	"DEATHKNIGHT",

		["Ailuran"]		=	"DRUID",
		["Hugadarn"]	=	"DRUID",
		["Killdozer"]	=	"DRUID",
		["Mahigan"]		=	"DRUID",
		["Therian"]		=	"DRUID",
		["Wachabe"]		=	"DRUID",

		["Boneshot"]	=	"HUNTER",	-- Undead 1, 9, 1, 10, 11
		["Caelash"]		=	"HUNTER",	-- Orc 4, 6, 1, 1, 2
		["Gajutar"]		=	"HUNTER",	-- Orc 4, 6, 1, 1, 2
		["Caellian"]	=	"HUNTER",	-- Night Elf 6, 1, 4, 5, 1
		["Deadaim"]		=	"HUNTER",	-- Undead 1, 9, 1, 10, 11
		["Faradrim"]	=	"HUNTER",	-- Blood Elf 6, 1, 11, 6, 1
		["Alsahim"]		=	"HUNTER",	-- Blood Elf 6, 1, 11, 6, 1

		["Archmagus"]	=	"MAGE",		-- Pandaren 6, 7, 1, 1

		["Daruma"]		=	"MONK",		-- Troll 6, 3, 5, 5, 6
		["Moopheus"]	=	"MONK",		-- Tauren 1, 2, 3, 1, 1
		["Shaohao"]		=	"MONK",		-- Pandaren 6, 7, 1, 1

		["Aequitas"]	=	"PALADIN",	-- Blood Elf 6, 2, 11, 6, 1
		["Pythol"]		=	"PALADIN",	-- Blood Elf 6, 2, 11, 6, 1

		["Erebos"]		=	"ROGUE",		-- Undead 1, 9, 1, 10, 11
		["Gorotsuki"]	=	"ROGUE",		-- Night Elf 6, 1, 4, 5, 1
		["Kinjutsu"]	=	"ROGUE",		-- Pandaren 6, 7, 1, 1
		["Kobalos"]		=	"ROGUE",		-- Goblin 9, 3, 1, 3, 10
		["Ragnuk"]		=	"ROGUE",		-- Goblin 9, 3, 1, 3, 10
		["Ursakuma"]	=	"ROGUE",		-- Pandaren 6, 7, 1, 1

		["Pimicow"]		=	"SHAMAN",
		["Shenren"]		=	"SHAMAN",	-- Draenei 4, 3, 9, 3, 1

		["Erebos"]		=	"WARLOCK",	-- Orc 4, 6, 1, 1, 2

		["Exoskell"]	=	"WARRIOR",	-- Undead 1, 9, 1, 10, 11
		["Pandahuan"]	=	"WARRIOR",	-- Pandaren 6, 7, 1, 1
		["Qiulong"]		=	"WARRIOR",	-- Pandaren 6, 7, 1, 1
	},
	["Dalaran"] = {
		["Kobalos"]		=	"ROGUE",		-- Gnome 5, 4, 3, 2, 1
		["Therian"]		=	"ROGUE",		-- Worgen 3, 3, 4, 1, 1
	},
	["Hyjal"] = {
		["Hugadarn"]	=	"DRUID",
	}
}

local herToons = {
	["Illidan"] = {
		["Mâjandrâ"]	=	"DRUID",
		["Malivaya"]	=	"DRUID",

		["Liiam"]		=	"HUNTER",
		["Lliiam"]		=	"HUNTER",
		["Mâjandra"]	=	"HUNTER",
		["Vâlandra"]	=	"HUNTER",
		["Khalysto"]	=	"HUNTER",

		["Maêjandra"]	=	"MONK",
		["Vaélendra"]	=	"MONK",

		["Malivaya"]	=	"PRIEST",

		["Callysto"]	=	"PRIEST",

		["Maajandra"]	=	"ROGUE",
		["Vàlàndrà"]	=	"ROGUE",

		["Khaleesia"]	=	"WARLOCK",
		["Vaélandra"]	=	"WARLOCK",

		["Valimaya"]	=	"WARRIOR",
	}
}

caelUI.myToons = myToons[caelUI.playerRealm]
caelUI.myChars = myToons[caelUI.playerRealm] and myToons[caelUI.playerRealm][caelUI.playerName]
caelUI.herChars = herToons[caelUI.playerRealm] and herToons[caelUI.playerRealm][caelUI.playerName]
--[[
if (caelUI.myChars or caelUI.herChars) then
	function GetLocale()
		return "frFR"
	end
end
--]]