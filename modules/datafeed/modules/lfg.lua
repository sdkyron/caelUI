--[[	$Id: lfg.lua 3732 2013-11-19 14:00:35Z sdkyron@gmail.com $	]]

local _, caelDataFeeds = ...

caelDataFeeds.lfg = caelDataFeeds.createModule("LFG")

local lfg = caelDataFeeds.lfg

lfg.text:SetPoint("CENTER", caelPanel8, "CENTER", caelUI.scale(-150), 0)

local format = string.format

local red, green = "AF5050", "559655"

local playerName = caelUI.playerName

local assistMsg = GetLocale() == "frFR" and "Salut, peux-tu me mettre assistant stp." or "Hi, can you give me an assist plz."

AlertFrame:UnregisterEvent("LFG_COMPLETION_REWARD") -- Dont Show the Dungeon Complete Frame

local delay = 0
local expiryTime, deserterExpiration
local lfg_OnUpdate = function(self, elapsed)
    delay = delay - elapsed
    if delay < 0 then
		expiryTime = GetLFGRandomCooldownExpiration()
		deserterExpiration = GetLFGDeserterExpiration()

		if deserterExpiration then
			self.text:SetFormattedText("%s|cff%s%s|r", "|cffD7BEA5lfg|r ", red, SecondsToTime(deserterExpiration - GetTime()))
		elseif expiryTime then
			self.text:SetFormattedText("%s|cff%s%s|r", "|cffD7BEA5lfg|r ", red, SecondsToTime(expiryTime - GetTime()))
		else
			self:SetScript("OnUpdate", nil)
			self.text:SetText("|cffD7BEA5lfg|r Standby")
		end

		delay = 1
	end
end

local mode, category
local GetMode = function()
	for i = 1, NUM_LE_LFG_CATEGORYS do
		mode = GetLFGMode(i)
		if mode then
			return mode, i
		end
	end
end

lfg:SetScript("OnEvent", function(self, event, msg, author)
	local proposalExists, _, _, _, _, _, _, _, totalEncounters, completedEncounters = GetLFGProposal()

	if event == "UPDATE_BATTLEFIELD_STATUS" or event == "LFG_PROPOSAL_SHOW" then
		if event == "LFG_PROPOSAL_SHOW" then
			if proposalExists then
				if completedEncounters > 0 then
					RaidNotice_AddMessage(RaidWarningFrame, format("|cff%s%s: %d/%d|r", red, "Instance IN PROGRESS", completedEncounters, totalEncounters), ChatTypeInfo["RAID_WARNING"])
				end

				self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			end
		elseif event == "UPDATE_BATTLEFIELD_STATUS" then
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end
	end

	if event == "ZONE_CHANGED_NEW_AREA" then
		local _, instanceType = IsInInstance()

		if instanceType == "pvp" or (instanceType == "party" and select(8, GetInstanceInfo() ~= 1153)) or instanceType == "scenario" or instanceType == "raid" then
			self:RegisterEvent("CHAT_MSG_TEXT_EMOTE")

			DoEmote("Hail", "none")
			self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
--[[
			if (caelUI.myChars or caelUI.herChars) then
				local total = GetNumGroupMembers()

				for i = 1, total do
					local name, rank = GetRaidRosterInfo(i)

					if name and name ~= playerName and rank == 2 then
						SendChatMessage(assistMsg, "WHISPER", GetDefaultLanguage("player"), name)
					end
				end
			end
--]]
		end
	end

	if event == "CHAT_MSG_TEXT_EMOTE" then
		if author == playerName then
			self:UnregisterEvent("CHAT_MSG_TEXT_EMOTE")
		end
	end
--[[
	if UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
		if event == "LFG_COMPLETION_REWARD" then
			self:RegisterEvent("CHAT_MSG_TEXT_EMOTE")

			DoEmote("Bye", "none")
		elseif event == "CHAT_MSG_TEXT_EMOTE" then
			if author == playerName then
				LeaveParty()

				self:UnregisterEvent("CHAT_MSG_TEXT_EMOTE")
			end
		end
	end
--]]
	mode, category = GetMode()

	if mode == "queued" then
		local inParty, joined, queued, noPartialClear, achievements, lfgComment, slotCount, category, leader, tank, healer, dps = GetLFGInfoServer(category)
		local hasData,  leaderNeeds, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, instanceType, instanceSubType, instanceName, averageWait, tankWait, healerWait, damageWait, myWait, queuedTime = GetLFGQueueStats(category)

		if not hasData then
			self.text:SetText("|cffD7BEA5lfg|r Searching")
			return
		end

		if category == LE_LFG_CATEGORY_SCENARIO then --Hide roles for scenarios
			tank, healer, dps = nil, nil, nil
			totalTanks, totalHealers, totalDPS, tankNeeds, healerNeeds, dpsNeeds = nil, nil, nil, nil, nil, nil
		end

		if tankNeeds and healerNeeds and dpsNeeds and myWait then
			self.text:SetText(
				format("|cffD7BEA5lfg |r %s%s%s%s%s %s",
					format("|cff%s%s|r", tankNeeds == 0 and green or red, "T"),
					format("|cff%s%s|r", healerNeeds == 0 and green or red, "H"),
					format("|cff%s%s|r", dpsNeeds == 3 and red or green, "D"),
					format("|cff%s%s|r", dpsNeeds >= 2 and red or green, "D"),
					format("|cff%s%s|r", dpsNeeds >= 1 and red or green, "D"),
					(myWait ~= -1 and SecondsToTime(myWait, false, false, 1) or "|cffD7BEA5Unknown|r")
				)
			)
			return
		else
			self.text:SetText("|cffD7BEA5lfg|r Scenario")
			return
		end
	elseif mode == "proposal" then
		self.text:SetText("|cffD7BEA5lfg|r Proposal")
		return
	elseif mode == "listed" then
		self.text:SetText("|cffD7BEA5LFR|r ")
		return
	elseif mode == "suspended" then
		self.text:SetText("|cffD7BEA5lfg|r Standby")
		return
	elseif mode == "rolecheck" then
		self.text:SetText("|cffD7BEA5lfg|r Role Check")
		return
	elseif mode == "abandonedInDungeon" then
		self.text:SetText("|cffD7BEA5lfg|r Abandoned")
		return
	elseif mode == "lfgparty" then
		self.text:SetText("|cffD7BEA5lfg|r In Group")
		return
	else
		self.text:SetText("|cffD7BEA5lfg|r Standby")
		return
	end

	self:SetScript("OnUpdate", lfg_OnUpdate)
end)

lfg:SetScript("OnMouseDown", function(self, button)
	if button == "RightButton" and GetMode() then
		QueueStatusMinimapButton.DropDown.point = "BOTTOM"
		QueueStatusMinimapButton.DropDown.relativePoint = "TOP"
		QueueStatusDropDown_Show(QueueStatusMinimapButton.DropDown, lfg)
	elseif button == "LeftButton" then
		PVEFrame_ToggleFrame("GroupFinderFrame", LFDParentFrame)
	end
end)

for _, event in next, {
	"LFG_UPDATE",
	"UPDATE_LFG_LIST",
	"LFG_PROPOSAL_SHOW",
	"LFG_PROPOSAL_UPDATE",
	"GROUP_ROSTER_UPDATE",
	"LFG_ROLE_CHECK_UPDATE",
--	"LFG_PROPOSAL_FAILED",
--	"LFG_PROPOSAL_SUCCEEDED",
	"PLAYER_ENTERING_WORLD",
	"LFG_COMPLETION_REWARD",
	"LFG_QUEUE_STATUS_UPDATE",
	"UPDATE_BATTLEFIELD_STATUS"
} do
	lfg:RegisterEvent(event)
end