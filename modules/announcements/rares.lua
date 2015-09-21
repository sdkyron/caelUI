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

local champions = {"Shadow-Lord Iskar", "Deathtalon", tostring(95053), "Siegemaster Mar\'tak", "Doomroller", tostring(95056), "Frogan", "Terrorfist", tostring(95044), "Tyrant Velhari", "Vengeance", tostring(95054)}

local msgAlert = GetLocale() == "frFR" and "%s trouvé !" or "%s found !"

local textColor = {r = 0.84, g = 0.75, b = 0.65}

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

	if event == "CHAT_MSG_MONSTER_YELL" and not IsInRaid() then
		for caller = 1, #champions - 1, 3 do
			if arg == champions[caller] and not IsQuestFlaggedCompleted(champions[caller + 2]) then

				self:RegisterEvent("PLAYER_TARGET_CHANGED")

				DEFAULT_CHAT_FRAME:AddMessage("|cffD7BEA5cael|rUI: "..champions[caller + 1].." found !")
				RaidNotice_AddMessage(RaidWarningFrame, msgAlert:format(champions[caller + 1]), ChatTypeInfo["RAID_WARNING"])
			end
		end
	end

	if event == "PLAYER_TARGET_CHANGED" then
		for name = 1, #champions - 1, 3 do
			if UnitName("target") == champions[name + 1] and not UnitIsDead("target") then

				self:RegisterEvent("LOOT_OPENED")

				-- C_LFGList.CreateListing(Category ID, "groupName", itemLevel, "voiceChat", "comment", autoAccept)
				C_LFGList.CreateListing(16, UnitName("target"), 0, "", "Join quick !", true)

				C_Timer.After(3, function()
					ConvertToRaid()
				end)

				self:UnregisterEvent("PLAYER_TARGET_CHANGED")
			end
		end
	end

	if event == "LOOT_OPENED" then
		for i = 1, GetNumLootItems() do
			local GUID = GetLootSourceInfo(i)

			for id = 1, #champions - 1, 3 do
--				if string.find(GUID, champions[id + 2]) then
				if string.match(GUID, "%-(%d+)%-[^-]+$") == champions[id + 2] then
					C_Timer.After(5, function()
						C_LFGList.RemoveListing()
						LeaveParty()
					end)
				end
			end
		end

		self:UnregisterEvent("LOOT_OPENED")
	end
end)

for _, event in next, {
	"CHAT_MSG_MONSTER_YELL",
	"VIGNETTE_ADDED"
} do
	caelUI.rares:RegisterEvent(event)
end