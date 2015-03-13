--[[	$Id: garrison.lua 3974 2014-12-02 15:10:13Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Force various warnings, auto accept ready checks if buffed	]]

caelUI.garrison = caelUI.createModule("Garrison")

local lastMissionID, numSucceeded, numFailed, spacer

local QueryMissions = function()
	local missions = C_Garrison.GetCompleteMissions()
	if #missions > 0 then
		if not lastMissionID then
			DEFAULT_CHAT_FRAME:AddMessage("|cffD7BEA5cael|rUI: Found "..#missions.." mission(s)")

			numSucceeded, numFailed = 0, 0
		end

		lastMissionID = missions[1].missionID
		
		C_Timer.After(1/2, function()
			C_Garrison.MarkMissionComplete(lastMissionID)
		end)
	elseif lastMissionID then
		GarrisonMissionFrame.MissionTab.MissionList.CompleteDialog:Hide()

		if numSucceeded > 0 then
			numSucceeded = numSucceeded.."|cff559655 successful|r"
		else
			numSucceeded = ""
		end

		if numFailed > 0 then
			numFailed = numFailed.."|cffAF5050 failed|r"
		else
			numFailed = ""
		end

		spacer = (numSucceeded ~= "" and numFailed ~= "") and " • " or ""

		DEFAULT_CHAT_FRAME:AddMessage("|cffD7BEA5cael|rUI: "..numSucceeded..spacer..numFailed)

		numSucceeded, numFailed, lastMissionID = nil, nil, nil
	end
end

caelUI.garrison:RegisterEvent("GARRISON_MISSION_NPC_OPENED")
caelUI.garrison:RegisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE")
caelUI.garrison:SetScript("OnEvent", function(self, event, ...)
	if event == "GARRISON_MISSION_NPC_OPENED" then
		if IsShiftKeyDown() then
			self:UnregisterEvent(event)
			self:RegisterEvent("GARRISON_MISSION_NPC_CLOSED")
		else
			QueryMissions()
		end
	elseif event == "GARRISON_MISSION_NPC_CLOSED" then
		self:RegisterEvent("GARRISON_MISSION_NPC_OPENED")
	else
		local missionID, canComplete, wasSuccessful = ...
		if missionID == lastMissionID and canComplete then
			if wasSuccessful and C_Garrison.CanOpenMissionChest(missionID) then
				numSucceeded = numSucceeded + 1
				C_Garrison.MissionBonusRoll(missionID)

				return
			end

			numFailed = numFailed + 1

			C_Timer.After(1/2, QueryMissions)
		end
	end
end)