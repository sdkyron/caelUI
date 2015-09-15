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

local timerActive = false

caelUI.rares:SetScript("OnEvent", function(self, event, addon, arg)
	if event == "VIGNETTE_ADDED" then
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
	end

	if not IsInRaid() then
		if arg == "Frogan" then
			timerActive = true
			C_LFGList.CreateListing(16, "Terrorfist", 0, " ", "Join quick !", true)
		elseif arg == "Tyrant Velhari" then
			timerActive = true
			C_LFGList.CreateListing(16, "Vengeance", 0, " ", "Join quick !", true)
		elseif arg == "Shadow-Lord Iskar" then
			timerActive = true
			C_LFGList.CreateListing(16, "Deathtalon", 0, " ", "Join quick !", true)
		elseif arg == "Siegemaster Mar\'tak" then
			timerActive = true
			C_LFGList.CreateListing(16, "Doomroller", 0, " ", "Join quick !", true)
		end
	end
end)

local total = 0
local isRaid = false

caelUI.rares:SetScript("OnUpdate", function(self, elapsed)
	if timerActive == true and not IsInRaid() then
		total = total + elapsed

		if total >= 120 then
			C_LFGList.RemoveListing()
			total = 0
			timerActive = false
			isRaid = false
		end

		if total > 5 and isRaid == false then
			isRaid = true
			ConvertToRaid()
		end
	end
end)

for _, event in next, {
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_WHISPER",
	"CHAT_MSG_MONSTER_SAY",
	"CHAT_MSG_EMOTE",
	"VIGNETTE_ADDED"
} do
	caelUI.rares:RegisterEvent(event)
end