--[[	$Id: cvarData.lua 3973 2014-12-02 15:05:17Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.cvardata = caelUI.createModule("cvarData")

local cvardata = caelUI.cvardata

cvardata.initOn = "PLAYER_ENTERING_WORLD"

local isResting

local myChars = caelUI.myChars
local herChars = caelUI.herChars

local L_FindTimber = GetSpellInfo(167898)
local L_FindFish = GetSpellInfo(43308)
local L_FindHerbs = GetSpellInfo(2383)
local L_TrackHumanoids = GetSpellInfo(5225)
local L_TrackHidden = GetSpellInfo(19885)
local L_FindMinerals = GetSpellInfo(2580)
local L_TrackPets = GetSpellInfo(122026)
local L_FindTreasure = GetSpellInfo(2481)

local ZoneChange = function(event, zone)
	local _, instanceType = IsInInstance()

	if zone == "Orgrimmar" or zone == "Stormwind" then
		SetCVar("particleDensity", 10)
		SetCVar("weatherDensity", 0)
		SetCVar("environmentDetail", 50)
		SetCVar("groundEffectDensity", 16)
		SetCVar("groundEffectDist", 70)
		SetCVar("groundEffectFade", 70)
		SetCVar("projectedTextures", 0)
	elseif instanceType ~= "none" then
		SetCVar("particleDensity", 100)
		SetCVar("weatherDensity", 3)
		SetCVar("environmentDetail", 150)
		SetCVar("groundEffectDensity", 128)
		SetCVar("groundEffectDist", 260)
		SetCVar("groundEffectFade", 260)
		SetCVar("projectedTextures", 1)
	else
		SetCVar("particleDensity", 60)
		SetCVar("weatherDensity", 1)
		SetCVar("environmentDetail", 100)
		SetCVar("groundEffectDensity", 64)
		SetCVar("groundEffectDist", 160)
		SetCVar("groundEffectFade", 160)
		SetCVar("projectedTextures", 1)
	end
end

--	Kill the profanity filter option
caelUI.kill(InterfaceOptionsSocialPanelProfanityFilter)

local trackings = {
	MINIMAP_TRACKING_DIGSITES,
	MINIMAP_TRACKING_FLIGHTMASTER,
	MINIMAP_TRACKING_MAILBOX,
	MINIMAP_TRACKING_QUEST_POIS,
	MINIMAP_TRACKING_TARGET,
	MINIMAP_TRACKING_TRIVIAL_QUESTS,
	-- MINIMAP_TRACKING_WILD_BATTLE_PET,
	L_FindTimber,
	L_FindFish,
	L_FindHerbs,
	L_FindMinerals,
	L_TrackPets,
	L_FindTreasure
}

cvardata:SetScript("OnEvent", function(self, event, unit)
	if event == "CVAR_UPDATE" then
		if GetCVar("profanityFilter") == "1" then
			SetCVar("profanityFilter", 0)
		end

		return
	end

	--	Force enable/disable "Display Only Character Achievements to Others" with each character (Interface -> Game -> Display)
	if event == "PLAYER_LOGIN" or event == "PLAYER_FLAGS_CHANGED" then
		if not AreAccountAchievementsHidden() then
			ShowAccountAchievements(false) -- True to enable the option, false otherwise.
		end

		return
	end

	if not UnitIsDeadOrGhost("player") and not UnitOnTaxi("player") and not UnitInVehicle("player") then
		if event == "PLAYER_UPDATE_RESTING" or event == "UPDATE_SHAPESHIFT_FORM" or event == "UPDATE_SHAPESHIFT_USABLE" then
			if caelUI.playerClass == "DRUID" or caelUI.playerClass == "HUNTER" then
				isResting = IsResting() and true or false

				for i = 1, GetNumTrackingTypes() do
					local name, _, active = GetTrackingInfo(i)

					if name and (isResting and active) and (name == L_TrackHidden) then
						SetTracking(i, false)
					elseif name and (not isResting and not active) and (name == L_TrackHidden) then
						SetTracking(i, true)
					end
				end
			else
				self:UnregisterEvent("PLAYER_UPDATE_RESTING")
				self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")
				self:UnregisterEvent("UPDATE_SHAPESHIFT_USABLE")
			end
		end

		if event == "PLAYER_ENTERING_WORLD" then
			for i = 1, GetNumTrackingTypes() do
				local name, _, active = GetTrackingInfo(i)

				if name ~= L_FindFish and name ~= L_FindHerbs and name ~= L_FindMinerals and name ~= L_TrackPets and name ~= L_FindTreasure then
					SetTracking(i, false)
				end

				for _, tracking in pairs(trackings) do
					if (name and tracking) and (name == tracking) then
						SetTracking(i, true)
						break
					end
				end
			end
		end
	end

	local zone = GetRealZoneText()

	if zone and zone ~= "" then
		return ZoneChange(event, zone)
	end
end)

local defaultCVarValues = {
	["hwDetect"] = 0,
	["reducedLagTolerance"] = 1,
	["scriptProfile"] = 0, -- Disables CPU profiling
	["synchronizeSettings"] = 0, -- Don't synchronize settings with the server
	["synchronizeConfig"] = 0,
	["synchronizeBindings"] = 0,
	["synchronizeMacros"] = 0,
	["checkAddonVersion"] = 0,
	["buffDurations"] = 1,
	["alwaysCompareItems"] = 1,
	["deselectOnClick"] = 1,
	["autoDismountFlying"] = 1,
	["lootUnderMouse"] = 0,
	["autoLootDefault"] = 1,
	["stopAutoAttackOnTargetChange"] = 1,
	["autoSelfCast"] = 1,
	["rotateMinimap"] = 0,
	["threatShowNumeric"] = 0,
	["threatPlaySounds"] = 0,
	["autoQuestWatch"] = 1,
	["autoQuestProgress"] = 1,
	["profanityFilter"] = 0,
	["chatBubbles"] = 1,
	["chatBubblesParty"] = 1,
	["spamFilter"] = 0,
	["guildMemberNotify"] = 0,
	["chatMouseScroll"] = 1,
	["chatStyle"] = "classic",
	["conversationMode"] = "inline",
	["WhisperMode"] = "inline",
	["BnWhisperMode"] = "inline",
	["WholeChatWindowClickable"] = 0,
	["lockActionBars"] = 1,
	["alwaysShowActionBars"] = 1,
	["secureAbilityToggle"] = 1,
	["showPartyBackground"] = 0,
	["UnitNameOwn"] = 0,
	["UnitNameNPC"] = 1,
	["UnitNameNonCombatCreatureName"] = 0,
	["UnitNamePlayerGuild"] = 0,
	["UnitNamePlayerPVPTitle"] = 0,
	["UnitNameFriendlyPlayerName"] = 1,
	["UnitNameFriendlyPetName"] = 0,
	["UnitNameFriendlyGuardianName"] = 0,
	["UnitNameFriendlyTotemName"] = 0,
	["UnitNameEnemyPlayerName"] = 1,
	["UnitNameEnemyPetName"] = 1,
	["UnitNameEnemyGuardianName"] = 1,
	["UnitNameEnemyTotemName"] = 1,
	["CombatDamage"] = 0,
	["CombatHealing"] = 0,
	["fctSpellMechanics"] = 0,
	["enableCombatText"] = 0,
	["showArenaEnemyFrames"] = 0,
	["autoInteract"] = myChars and 1 or herChars and 1,
	["showTutorials"] = 0,
	["showNPETutorials"] = 0,
	["uberTooltips"] = 1,
	["scriptErrors"] = 1,
	["consolidateBuffs"] = 0,
	["alternateResourceText"] = 1,
	["lossOfControl"] = 0,

	["showToastOnline"] = 0,
	["showToastOffline"] = 0,
	["showToastBroadcast"] = 0,
	["showToastFriendRequest"] = 0,
	["showToastConversation"] = 0,
	["showToastWindow"] = 0,
	["toastDuration"] = 0,

	["gxApi"] = "D3D11",
	["gxWindow"] = 1,
	["gxMaximize"] = 1,
	["gxFixLag"] = 1,
	["gxCursor"] = 1,
	["gxVSync"] = 1,
	["maxFps"] = 0,
	["maxFpsBk"] = 0,

	["violenceLevel"] = 5, -- 0-5 Level of violence, 0 == none, 1 == green blood 2-5 == red blood

	["textureFilteringMode"] = myChars and 5 or herChars and 0,

	["terrainMipLevel"] = myChars and 0 or herChars and 0,
	["componentTextureLevel"] = myChars and 0 or herChars and 0,
	["worldBaseMip"] = myChars and 0 or herChars and 1,

	["farclip"] = myChars and 1300 or herChars and 800,
	["wmoLodDist"] = myChars and 650 or herChars and 400,
	["terrainLodDist"] = myChars and 650 or herChars and 450,
	["terrainTextureLod"] = myChars and 0 or herChars and 1,

	["horizonFarclipScale"] = myChars and 6 or herChars and 3,

	["skyCloudLod"] = 3,

	["ffxGlow"] = 0,

	["gxTripleBuffer"] = 0,

	["ffxAntiAliasingMode"] = herChars and 3,
	["MSAAQuality"] =  myChars and  "3,0",

	["shadowMode"] = 0,
	["waterdetail"] = myChars and 3 or herChars and 1,
	["rippleDetail"] = myChars and 2 or herChars and 1,
	["reflectionmode"] = myChars and 3 or herChars and 0,
	["sunshafts"] = myChars and 2 or herChars and 1,
	["ssao"] = myChars and 1 or herChars and 0,
	["ssaoBlur"] = myChars and 2 or herChars and 0,

	["disableServerNagle"] = 1,
	["useIPv6"] = 1,
	["advancedCombatLogging"] = 1,

	["Sound_NumChannels"] = myChars and 64 or herChars and 24, -- 24, 32, 64
	["Sound_EnableSoftwareHRTF"] = 0, -- Enables headphone designed sound subsystem
	["Sound_AmbienceVolume"] = 0.5,
	["Sound_EnableErrorSpeech"] = 0,
	["Sound_EnableMusic"] = 0,
	["Sound_EnableSoundWhenGameIsInBG"] = 1,
	["Sound_MasterVolume"] = 0.043,
	["Sound_MusicVolume"] = 0,
	["Sound_SFXVolume"] = 0.34,
	["Sound_DialogVolume"] = 0.5,

--[[
	0.043264415115118,
	0.10000000149012,
	0.14400000870228,
	0.20000000298023,
	0.24450522661209,
	0.30972743034363,
	0.34512624144554,
	0.50790667533875,
--]]

	["cameraDistanceMax"] = 50,
	["cameraDistanceMaxFactor"] = 3.4,
	["cameraDistanceMoveSpeed"] = 50,
	["cameraViewBlendStyle"] = 2,

	["cameraSmoothStyle"] = 1,
	["cameraSmoothTrackingStyle"] = 1,

	["nameplateShowFriends"] = 0,
	["nameplateShowFriendlyPets"] = 0,
	["nameplateShowFriendlyGuardians"] = 0,
	["nameplateShowFriendlyTotems"] = 0,

	["nameplateShowEnemies"] = 0,
	["nameplateShowEnemyPets"] = 0,
	["nameplateShowEnemyGuardians"] = 0,
	["nameplateShowEnemyTotems"] = 0,

	["bloattest"] = 1, -- 1 might make nameplates larger but it fixes the disappearing ones.
	["bloatnameplates"] = 0, -- 1 makes nameplates larger depending on threat percentage.
	["bloatthreat"] = 0, -- 1 makes nameplates resize depending on threat gain/loss. Only active when a mob has multiple units on its threat table.
}

function cvardata:init()
	if not self.db.cvarValues then
		self.db.cvarValues = {}
	end

	setmetatable(self.db.cvarValues, {__index = defaultCVarValues})

	if UIScale then
		SetCVar("useUiScale", 1)
		SetCVar("uiScale", UIScale)

		WorldFrame:SetUserPlaced(false)
		WorldFrame:ClearAllPoints()
		WorldFrame:SetHeight(GetScreenHeight() * UIScale)
		WorldFrame:SetWidth(GetScreenWidth() * UIScale)
		WorldFrame:SetPoint("CENTER", UIParent)
	else
		SetCVar("useUiScale", 0)
		print("Your resolution is not supported, UI Scale has been disabled.")
	end

	for cvar in next, defaultCVarValues do
		SetCVar(cvar, self.db.cvarValues[cvar])
	end

	ConsoleExec("pitchlimit 89") -- 89, 449. 449 allows doing flips, 89 will not
	ConsoleExec("characterAmbient -0.1") -- -0.1-1 use ambient lighting for character. <0 == off

	if (tonumber(GetCVar("ScreenshotQuality")) < 10) then SetCVar("ScreenshotQuality", 10) end

	hooksecurefunc("SetCVar", function(cvar, value, event)
		if event then
			cvardata.db.cvarValues[cvar] = value
		end
	end)

	hooksecurefunc(SlashCmdList, "CONSOLE", function(msg)
		local cvar, value = (" "):split(msg)
		if (cvar and value) then
			cvardata.db.cvarValues[cvar] = value
		end
	end)
end

for _, event in next, {
	"CVAR_UPDATE",
	"PLAYER_LOGIN",
	"WORLD_MAP_UPDATE",
	"PLAYER_FLAGS_CHANGED",
	"ZONE_CHANGED_NEW_AREA",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_UPDATE_RESTING",
	"UPDATE_SHAPESHIFT_FORM",
	"UPDATE_SHAPESHIFT_USABLE"
} do
	cvardata:RegisterEvent(event)
end