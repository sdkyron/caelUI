--[[	$Id: emote.lua 3943 2014-10-19 22:07:52Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.emote = caelUI.createModule("Emote")

local FILTER_MINE = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER) -- Matches any "unit" under the player's control
local GUID_TYPE_MASK = 0x7
local GUID_TYPE_PLAYER = 0x0

local locale = GetLocale()
local band, tonumber = bit.band, tonumber
local oldState, player, playerFaction, pvpZone
local recentKills = setmetatable({}, { __mode = "kv" })

local targets = {}

local randomEmote = {
	[1]	=	"GLOAT",
	[2]	=	"GRIN",
	[3]	=	"CACKLE",
	[4]	=	"GLARE",
	[5]	=	"MOURN",
	[6]	=	"GRIN",
	[7]	=	"GUFFAW",
}

local thankSpells = {
	[2006]	= true,	-- Resurrection
	[2008]	= true,	-- Ancestral Spirit
	[7328]	= true,	-- Redemption
	[20484]	= true,	-- Rebirth
	[20707]	= true,	-- Soulstone
	[50769]	= true,	-- Revive
	[61999]	= true,	-- Raise Ally
	[115178]	= true,	-- Resuscitate
}

local alertSpells = {
	[76577]	= true,	-- Smoke Bomb
}
--[[
local procSpells = {
	[127802]	= true,	-- Touch of the Grave
}
--]]
local msg = locale == "frFR" and "a fait couler le premier sang" or "drew first blood"
local blow = locale == "frFR" and "COUP FATAL" or "KILLING BLOW"
local thankMsg = locale == "frFR" and "Merci pour %s" or "Thank you for %s"
local alertMsg = locale == "frFR" and "%s sur moi !" or "%s on me !"

caelUI.emote:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...

		if addon ~= "caelUI" then
			return
		end

		if not caelAnnouncesDB then
			caelAnnouncesDB  = {}
		end

		self:UnregisterEvent("ADDON_LOADED")
	elseif event == "PLAYER_LOGIN" then
		player = UnitGUID("player")

		self:UnregisterEvent("PLAYER_LOGIN")
	elseif event == "PLAYER_ENTERING_WORLD" then
		playerFaction = UnitFactionGroup("player")

		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		local _, instanceType = IsInInstance()

		if instanceType == "arena" or instanceType == "pvp" or tostring(GetZoneText()) == "Wintergrasp" or tostring(GetZoneText()) == "Tol Barad" then
			caelAnnouncesDB.killCount = 0

			caelAnnouncesDB.lastKill = 0
			PlaySoundFile(caelMedia.files.soundEnteringPvPZone, "Master")

			pvpZone = true
		else
			pvpZone = false
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, _, _, spellId = ...

		local overkill

		if subEvent == "SWING_DAMAGE" then
			overkill = select(13, ...)
		elseif subEvent:find("_DAMAGE", 1, true) and not subEvent:find("_DURABILITY_DAMAGE", 1, true) then
			overkill = select(16, ...)
		end

		local now, previousKill = GetTime(), recentKills[destGUID]

		if (subEvent == "PARTY_KILL" or (overkill and overkill >= 0)) and (not previousKill or now - previousKill > 1.0) then
			local dashPos = destName and destName:find("-")

			if dashPos then
				destName = destName:sub(0, dashPos - 1)
			end

			if targets[destName] then
				if sourceGUID == PLAYER_GUID or band(sourceFlags, FILTER_MINE) == FILTER_MINE then
					if pvpZone then
						DoEmote(randomEmote[math.random(1, 7)], destName)
					else
						if UnitFactionGroup("target") == playerFaction then
							DoEmote("APOLOGIZE", destName)
						end
					end

--					PlaySoundFile(caelMedia.files.soundGodlike, "Master")

					caelAnnouncesDB.killCount = caelAnnouncesDB.killCount + 1

					if caelAnnouncesDB.killCount == 1 then
						PlaySoundFile(caelMedia.files.firstblood, "Master")
					elseif caelAnnouncesDB.killCount == 2 then
						PlaySoundFile(caelMedia.files.doublekill, "Master")
					elseif caelAnnouncesDB.killCount == 3 then
						PlaySoundFile(caelMedia.files.multikill, "Master")
					elseif caelAnnouncesDB.killCount == 4 then
						PlaySoundFile(caelMedia.files.dominating, "Master")
					elseif caelAnnouncesDB.killCount == 5 then
						PlaySoundFile(caelMedia.files.rampage, "Master")
					elseif caelAnnouncesDB.killCount == 6 then
						PlaySoundFile(caelMedia.files.megakill, "Master")
					elseif caelAnnouncesDB.killCount == 7 then
						PlaySoundFile(caelMedia.files.unstoppable, "Master")
					elseif caelAnnouncesDB.killCount == 8 then
						PlaySoundFile(caelMedia.files.ultrakill, "Master")
					elseif caelAnnouncesDB.killCount == 9 then
						PlaySoundFile(caelMedia.files.monsterkill, "Master")
					else
						PlaySoundFile(caelMedia.files.godlike, "Master")
					end

					caelCombatTextAddText("|cffAF5050"..blow.." ("..caelAnnouncesDB.killCount..")|r", nil, nil, true, "Notification")

					if caelAnnouncesDB.lastKill == 0 then
						SendChatMessage(msg, "EMOTE", GetDefaultLanguage("player"))
						caelAnnouncesDB.lastKill = 1
					end
				end

				targets[destName] = nil
				recentKills[destGUID] = now
			end
		end

		if subEvent == "SPELL_CAST_SUCCESS" then
			if sourceGUID == player then
				if spellId == 69041 then
					local sex = UnitSex("player")

                    local message = {
                        [2] = "montre son gros missile à ", -- Male
                        [3] = "montre son gros missile à ", -- Female
                    }

                    if sex ~= 1 then
                        SendChatMessage((message[sex]..destName), "EMOTE", GetDefaultLanguage("player"))
                    end
				end

				for k, v in pairs(alertSpells) do
					if spellId == k and v == true then
						local sayMsg = alertMsg:format(GetSpellLink(spellId))

						SendChatMessage(sayMsg, "SAY", GetDefaultLanguage("player"))
					end
				end
			end
		end

		if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_CAST_SUCCESS" then
			for k, v in pairs(thankSpells) do
				if spellId == k and v == true and sourceGUID ~= player and destGUID == player then
					local whisperMsg = thankMsg:format(GetSpellLink(spellId))

					SendChatMessage(whisperMsg, "WHISPER", GetDefaultLanguage("player"), sourceName)
				end
			end
		end

--		if subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_HEAL" then
--			for k, v in pairs(procSpells) do
--				if spellId == k and v == true and sourceGUID == player then
--					DoEmote("GUFFAW", target)
--				end
--			end
--		end
	elseif event == "PLAYER_DEAD" then
		caelAnnouncesDB.killCount = 0
	elseif event == "UNIT_AURA" then
		local unit, target = ...
		if  unit == "player" then
			local newState = UnitBuff(unit, "Lifeblood")
			if newState and not oldState then
				DoEmote("GROWL", target)
			end

			oldState = newState
		end
	elseif event == "LOSS_OF_CONTROL_ADDED" then
		local i = C_LossOfControl.GetNumEvents()
		local _, _, text, _, _, _, duration = C_LossOfControl.GetEventInfo(i)

		caelCombatTextAddText("|cffAF5050"..string.upper(text).."|r", nil, nil, true, "Warning")
	end
end)

caelUI.emote:HookScript("OnEvent", function(self, event)
	if event == "PLAYER_TARGET_CHANGED" then
		if UnitExists("target") and UnitIsPlayer("target") and UnitIsEnemy("player", "target") then -- and UnitFactionGroup("target") ~= playerFaction then
			targets[UnitName("target")] = true
		end
	end
end)

for _, event in next, {
	"ADDON_LOADED",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"LOSS_OF_CONTROL_ADDED",
	"PLAYER_DEAD",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_LOGIN",
	"PLAYER_TARGET_CHANGED",
	"UNIT_AURA",
	"ZONE_CHANGED_NEW_AREA"
} do
	caelUI.emote:RegisterEvent(event)
end

--[[
Only Alliance to Horde!
-----------------------
À 3 ƒ ƒ Ä 3 Í ƒ ƒ = Kiss my ass (Kyss my ass)
Ð ' • 2 3 ' 0 Ç Í 'ƒ ƒ = Love your Anus
Ð ' • 2 3 ' 0 Ç Í ƒ ƒ = Love your ass
20 Í Ð = anal
•0 20 Í Ð = go anal
0• ƒ À 3 Ð Ð = No Skill (no skyll)
Ð ' • 2 3 ' 0 Ç 3À ÇÍ Ç• = Love your mother
Ð ' • 2 3 ' 0 Ç 3À ÇÍ Ç• 'Ç ƒ = love your mother ass
Ð ' • 2 3 ' 0 Ç 3À ÇÍ Ç• •3• 3 ' 0 Ç 'Ç ƒ = love your mother and your ass
Ð ' • 2 20 Í Ð •Ð ÇÍ 3 ' 0 Ç 3À ÇÍ Ç• = love anal with your mother
3 ' 0 Í Ç 2 2' = You are KO
0• ' 'Ð '' Ð = Noob olol
•0 20 Í Ð •Ð ÇÍ •Ç = Go anal with me
•0 63636 3 ' 0 Ç Í 'ƒ ƒ = Go regen your anus
Ð ' ' ƒ 2 Ç = Looser
63636= Regen
ƒ ' Ç Ç 3 = Sorry
T i p à b AU 2 2Ð Ð 2' 00 20 = You re an e vil KO RE AN
--]]