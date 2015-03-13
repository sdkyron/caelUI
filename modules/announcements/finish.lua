--[[	$Id: finish.lua 3980 2015-01-26 10:16:58Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Sound warning at execute range	]]

caelUI.execute = caelUI.createModule("Execute")

local executeRange, playerClass, soundPlayed = 0, caelUI.playerClass, false

-- Specs from left to right and execute percentage value, 0 to disable.
local executeList = {
	["HUNTER"]		=	{20, 20, 0},
	["PALADIN"]		=	{20, 20, 20},
	["PRIEST"]		=	{20, 20, 20},
	["ROGUE"]		=	{35, 0, 0},
	["WARLOCK"]		=	{0, 0, 20},
	["WARRIOR"]		=	{20, 20, 20},
}

local validUnitTypes = {
	minus			=	false,
	trivial		=	false,
	normal		=	false,
	elite			=	true,
	rare			=	false,
	rareelite	=	true,
	worldboss	=	true,
}

local UpdateExecuteRange = function()
	executeRange = executeList[playerClass] and executeList[playerClass][GetSpecialization()] or 0
end

caelUI.execute:SetScript("OnEvent", function(self, event)
	if event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
		UpdateExecuteRange()
	elseif event == "PLAYER_TARGET_CHANGED" then
		SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, _)

		soundPlayed = false
	elseif event == "UNIT_HEALTH_FREQUENT" then
		if soundPlayed or CanExitVehicle() or UnitIsDeadOrGhost("target") or UnitIsFriend("player", "target") then
			return
		end

		local currentHealth = UnitHealth("target") / UnitHealthMax("target") * 100

		if validUnitTypes[UnitClassification("target")] or UnitIsPlayer("target") then
			if currentHealth < executeRange then
				if UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] and UnitLevel("target") >= (UnitLevel("player") + 2) or UnitLevel("target") == -1 then
					PlaySoundFile(caelMedia.files.soundFinish, "Master")
					soundPlayed = true
				end

				-- self, spellID, texturePath, location, scale, r, g, b, info.vFlip, info.hFlip
				SpellActivationOverlay_ShowOverlay(SpellActivationOverlayFrame, _, "TEXTURES\\SPELLACTIVATIONOVERLAYS\\GENERICARC_02.BLP", "LEFT", 1, 255, 255, 255, false, false)
				SpellActivationOverlay_ShowOverlay(SpellActivationOverlayFrame, _, "TEXTURES\\SPELLACTIVATIONOVERLAYS\\GENERICARC_02.BLP", "RIGHT", 1, 255, 255, 255, false, true)
			else
				SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, _)
			end
		end
	end
end)

caelUI.execute:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "target")

for _, event in next, {
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_SPECIALIZATION_CHANGED",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_TARGET_CHANGED",
} do
	caelUI.execute:RegisterEvent(event)
end