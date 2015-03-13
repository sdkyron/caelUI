--[[	$Id: quests.lua 3965 2014-12-02 08:28:26Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.quests = caelUI.createModule("Quests")

local find, format, gsub, match = string.find, string.format, string.gsub, string.match

local questIndex = 0
local questId = 0
--local completeCount = 0

local QuestCompleted = ERR_QUEST_OBJECTIVE_COMPLETE_S
local ObjCompPattern = QuestCompleted:gsub("[()]", "%%%1"):gsub("%%s", "(%.%-)")

local UIErrorsFrame_OldOnEvent = UIErrorsFrame:GetScript("OnEvent")
UIErrorsFrame:SetScript("OnEvent", function(self, event, msg, ...)
	if event == "UI_INFO_MESSAGE" then
--		if msg:match("(.-): (.-)/(.+)") or msg:find(ObjCompPattern) or msg:find("Objective Complete.") then
		local objective, cur, goal, isComplete = msg:match("(.-): (.-)/(.+)")
--		local questObjective = gsub(msg, "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$", "%1", 1)
--		local _, _, itemName, numItems, numTotal = find(msg, "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$")

		if objective then
			if cur == goal then
				isComplete = true
			end
		else
			objective = msg:match(ObjCompPattern)
			if objective then
				isComplete = true
			else
				objective = msg
			end
		end

		if isComplete then -- Objective complete
			RaidNotice_AddMessage(RaidWarningFrame, format("%s: %s", objective, "Objective complete"), ChatTypeInfo["SYSTEM"])
			PlaySoundFile("Sound\\Creature\\Peon\\PeonYes3.ogg")
		elseif cur and goal then -- Objective progression
				RaidNotice_AddMessage(RaidWarningFrame, format("%s: %s", objective, cur.."/"..goal), ChatTypeInfo["SYSTEM"])
		else
			return UIErrorsFrame_OldOnEvent(self, event, msg, ...)
		end
	end
end)

local CountCompleteObjectives = function(index)
	local n = 0
	for i = 1, GetNumQuestLeaderBoards(index) do
		local _, _, finished = GetQuestLogLeaderBoard(i, index)

		if finished then
			n = n + 1
		end
	end

	return n
end

local SetQuest = function(index)
	questIndex = index

	if index > 0 then
		local _, _, _, _, _, _, _, _, id = GetQuestLogTitle(index)

		questId = id

--		if id and id > 0 then
--			completeCount = CountCompleteObjectives(index)
--		end
	end
end

local CheckQuest = function()
	if questIndex > 0 then
		local index = questIndex

		questIndex = 0

		local title, level, _, _, _, _, complete, daily, id = GetQuestLogTitle(index)

		if id == questId then
			if id and id > 0 then
				local objectivesComplete = CountCompleteObjectives(index)

				if complete then -- Quest complete
					RaidNotice_AddMessage(RaidWarningFrame, format("%s: %s", GetQuestLogTitle(index), "Quest complete"), ChatTypeInfo["SYSTEM"])
					PlaySoundFile("Sound\\Creature\\Peon\\PeonBuildingComplete1.ogg")
--[[			elseif objectivesComplete > completeCount then -- Objective complete
					RaidNotice_AddMessage(RaidWarningFrame, format("%s %s %s", GetQuestLogTitle(index), objectivesComplete.."/"..GetNumQuestLeaderBoards(index), "complete"), ChatTypeInfo["SYSTEM"])
					PlaySoundFile("Sound\\Creature\\Peon\\PeonYes3.ogg")
				else -- Objective progression + objective complete
					PlaySoundFile("Sound\\Creature\\Peon\\PeonReady1.ogg") --]]
				end
			end
		end
	end
end

local MostValuable = function()
	local bestPrice, bestItem = 0

	for i = 1, GetNumQuestChoices() do
		local link = GetQuestItemLink("choice", i)
		local quality = select(4, GetQuestItemInfo("choice", i))
		local price = link and select(11, GetItemInfo(link))

		if not price then
			return
		elseif (price * (quality or 1)) > bestPrice then
			bestPrice, bestItem = (price * (quality or 1)), i
		end
	end

	if bestItem then
		local button = _G["QuestInfoItem"..bestItem]
		if button and button.type == "choice" then
			button:Click()
		end
	end
end

caelUI.quests:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_QUEST_LOG_CHANGED" then
		local unit = ...

		if unit == "player" then
			CheckQuest()
		end
	elseif event == "QUEST_WATCH_UPDATE" then
		local index = ...

		SetQuest(index)
	elseif event == "QUEST_DETAIL" then
		CompleteQuest()
	elseif event == "QUEST_COMPLETE" then
		if GetNumQuestChoices() and GetNumQuestChoices() < 1 then
			GetQuestReward()
		else
			MostValuable()
		end
    elseif event == "QUEST_ACCEPT_CONFIRM" then
		ConfirmAcceptQuest()
	end
end)

local tags = {Elite = "+", Group = "G", Dungeon = "D", Raid = "R", PvP = "P", Daily = "•", Heroic = "H", Repeatable = "∞"}

local GetTaggedTitle = function(i)
	local name, level, tag, group, header, _, complete, daily = GetQuestLogTitle(i)
	if header or not name then return end

	if not group or group == 0 then
		group = nil
	end

	return format("[%s%s%s%s] %s", level, tag and tags[tag] or "", daily and tags.Daily or "",group or "", name), tag, daily, complete
end
--[[
local QuestLog_Update = function()
	for i, button in pairs(QuestLogScrollFrame.buttons) do
		local QuestIndex = button:GetID()
		local title, tag, daily, complete = GetTaggedTitle(QuestIndex)

		if title then
			button:SetText("  "..title)
		end

		if (tag or daily) and not complete then
			button.tag:SetText("")
		end

		QuestLogTitleButton_Resize(button)
	end
end

hooksecurefunc("QuestLog_Update", QuestLog_Update)
hooksecurefunc(QuestLogScrollFrame, "update", QuestLog_Update)
--]]
for _, event in next, {
	"QUEST_ACCEPT_CONFIRM",
	"QUEST_COMPLETE",
	"QUEST_DETAIL",
	"QUEST_WATCH_UPDATE",
	"UNIT_QUEST_LOG_CHANGED",
} do
	caelUI.quests:RegisterEvent(event)
end