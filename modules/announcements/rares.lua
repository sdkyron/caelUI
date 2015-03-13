--[[	$Id: rares.lua 3960 2014-12-02 08:24:50Z sdkyron@gmail.com $	]]

local _, caelUI = ...

local pixelScale = caelUI.scale

caelUI.rares = caelUI.createModule("Rares")
--[[
local button = rareButton or CreateFrame("BUTTON", "rareButton", UIParent, "SecureActionButtonTemplate")
button:SetAttribute("type", "macro")

local macroText = "/target "
--]]

local blacklist = {
	[971] = true, -- Alliance garrison
	[976] = true, -- Horde garrison
}
local msgAlert = GetLocale() == "frFR" and "%s trouvé !" or "%s spotted !"

local textColor = {r = 0.84, g = 0.75, b = 0.65}

caelUI.rares:RegisterEvent("VIGNETTE_ADDED")
caelUI.rares:SetScript("OnEvent", function()
	if blacklist[GetCurrentMapAreaID()] then return end

	local numVignettes = C_Vignettes.GetNumVignettes()

	for i = 1, numVignettes do
		local vigInstanceID = C_Vignettes.GetVignetteGUID(i)
		local _, _, name = C_Vignettes.GetVignetteInfoFromInstanceID(vigInstanceID)

--[[
		if name and not name:find("Chest") then
			macroText = macroText..name
			button:SetAttribute("macrotext", macroText)
		end
--]]
		PlaySoundFile(caelMedia.files.soundAlert, "Master")
		RaidNotice_AddMessage(RaidWarningFrame, msgAlert:format(name and name or "Rare"), ChatTypeInfo["RAID_WARNING"])
	end
end)