local MAJOR, MINOR = "LibgQuest-1.0", "$Revision: 30 $"
local LibgQuest, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not LibgQuest then return end -- No upgrade needed

local CallbackHandler = LibStub:GetLibrary("CallbackHandler-1.0")

if not LibgQuest.callbacks then
	LibgQuest.callbacks = CallbackHandler:New(LibgQuest)
end

LibgQuest.embeds = LibgQuest.embeds or {}
LibgQuest.hooks = LibgQuest.hooks or {}
LibgQuest.ishooked = LibgQuest.ishooked or {}

local callbacks = LibgQuest.callbacks
local mixins = {"RegisterCallback", "UnregisterCallback", "UnregisterAllCallbacks", 
"GetQuestLogIndexByName", "ParseObjectiveText", "GetQuestIndexByObjective",
"Quests", "Objectives"}

LibgQuest.Objectives = LibgQuest.Objectives or {}
LibgQuest.Quests = LibgQuest.Quests or {}
local Quests, Objectives = LibgQuest.Quests, LibgQuest.Objectives


-- Constants
-- Patterns
local QuestCompleted = ERR_QUEST_OBJECTIVE_COMPLETE_S
local ObjCompPattern = QuestCompleted:gsub("[()]", "%%%1"):gsub("%%s", "(%.%-)")
local maxQuestEntries = 2*MAX_QUESTS

---	Utility functions.
local ArgCheckErrorMsg = "Bad argument #%d to '%s': %s expected, got %s"
local function ArgCheck(num, arg, expectedType)
	local argType = type(arg)
	if argType ~= expectedType then
		error(ArgCheckErrorMsg:format(num, debugstack(2,3,0):match(": in function [`<](.-)['>]"), expectedType, argType), 3)
	end
end

function LibgQuest:ToggleDebug()
	self.debug = not self.debug
	print("Debugging: "..tostring(self.debug))
end

-- Hook wrapper to check if the function is hooked already. Prevents double hooking on lib update.
function LibgQuest:Hook(func, hook)
	ArgCheck(2, func, "string")
	ArgCheck(3, hook, "function")
	self.hooks[func] = hook
	if not self.ishooked[func] then
		hooksecurefunc(func, function(...) self.hooks[func](...) end)
		self.ishooked[func] = true
	end
end

function LibgQuest:HookScript(object, handler, hook, pre)
	ArgCheck(2, object, "table")
	ArgCheck(3, handler, "string")
	ArgCheck(4, hook, "function")
	
	self.hooks[object] = self.hooks[object] or {}
	self.hooks[object][handler] = hook
	if not self.ishooked[object] or not self.ishooked[object][handler] then
		if pre then
			object:SetScript(handler, function(...) self.hooks[object][handler](...) end)
		else
			object:HookScript(handler, function(...) self.hooks[object][handler](...) end)
		end
		self.ishooked[object] = self.ishooked[object] or {}
		self.ishooked[object][handler] = true
	end
end

-- Embed LibgQuest's mixins in the target.
function LibgQuest:Embed(target)
	ArgCheck(2, target, "table")
	for i,method in ipairs(mixins) do
		target[method] = self[method]
	end
	LibgQuest.embeds[target] = true
	return target
end

---	Mixins
-- Retreive the quest index for specified questname.
-- Takes a questname, returns the questIndex.
function LibgQuest:GetQuestLogIndexByName(questName)
	-- Quests in a collapsed header are found at an index higher than
	-- the numEntries returned by GetNumQuestLogEntries(). Therefore we
	-- keep going until we reach a nil result.
	local name
	for questIndex=1, maxQuestEntries do
		name = GetQuestLogTitle(questIndex)
		if not name then
			return
		elseif name == questName then
			return questIndex
		end
	end
end

-- Takes an objective without the progress part and returns questIndex.
-- GetQuestIndexByName("Restless footman killed")
function LibgQuest:GetQuestIndexByObjective(objective)
	-- Check if the quest actually exists in our table.
	if not self.Objectives[objective] then
		return
	end
	local questname = self.Objectives[objective].quest
	assert(questname, string.format("Could not find objective %q", objective))
	return self:GetQuestLogIndexByName(questname)
end

-- Takes leaderboard text, returns objective, progress, goal, isComplete.
function LibgQuest:ParseObjectiveText(objectiveText)
	if not objectiveText then
		return
	end
	
	local objective, cur, goal, isComplete = objectiveText:match("(.-): (.-)/(.+)")
	if objective then
		if cur == goal then
			isComplete = true
		end
	else
		objective = objectiveText:match(ObjCompPattern)
		if objective then
			isComplete = true
		else
			objective = objectiveText
		end
	end
	
	return objective, cur, goal, isComplete
end

---	The mumbo-jumbo that makes it all work.
-- Create a frame to monitor events.
local frame = LibgQuestFrame or CreateFrame("Frame", "LibgQuestFrame")
frame.events = frame.events or {}
frame:SetScript("OnEvent", function(self, event, ...)
	if type(self[event]) == "function" then
		return self[event](self, event, ...)
	end
end)

-- Parse quest data and enter into tables.
local function HandleQuest(questIndex)
	local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
	if not questLogTitleText then
		return true
	end
	if not isHeader then
		LibgQuest.Quests[questLogTitleText] = LibgQuest.Quests[questLogTitleText] or {}
		LibgQuest.Quests[questLogTitleText].isComplete = isComplete
		
		local objectiveText, objectiveType, objectiveFinished
		local objectivesTable
		local objective, cur, goal
		local numObjectives = GetNumQuestLeaderBoards(questIndex)
		if numObjectives > 0 then
			LibgQuest.Quests[questLogTitleText].objectives = LibgQuest.Quests[questLogTitleText].objectives or {}
			for leaderboardIndex=1, numObjectives do
				objectiveText, objectiveType, objectiveFinished = GetQuestLogLeaderBoard(leaderboardIndex, questIndex)
				objective, cur, goal = LibgQuest:ParseObjectiveText(objectiveText)
				if objective then -- Some quests apparently do not have objectiveText.
					LibgQuest.Quests[questLogTitleText].objectives[leaderboardIndex] = objective
					objectivesTable = LibgQuest.Objectives[objective] or {}
					
					-- Insert values into objective table.
					objectivesTable.quest = questLogTitleText
					objectivesTable.isComplete = objectiveFinished
					if not objectiveFinished then
						objectivesTable.cur = cur
						objectivesTable.goal = goal
					end
					LibgQuest.Objectives[objective] = objectivesTable
					objectivesTable = nil
				end
			end
		end
	end
end

local function UpdateObjective(objective, cur, goal, isComplete)
	Objectives[objective].cur = cur
	Objectives[objective].goal = goal
	Objectives[objective].isComplete = isComplete
	
	if isComplete then
		local quest = Quests[Objectives[objective].quest]
		for i=1, #quest.objectives do
			if not Objectives[quest.objectives[i]].isComplete then
				isComplete = nil
			end
		end
		quest.isComplete = isComplete
	end
end

local function RemoveQuestByName(questName)
	ArgCheck(2, questName, "string")
	if Quests[questName].objectives then
		local objectiveName
		for i=1, #Quests[questName].objectives do
			objectiveName = Quests[questName].objectives[i]
			Objectives[objectiveName] = nil
		end
		Quests[questName].objectives = nil
	end
	
	Quests[questName] = nil
end
	
-- Populate quest table.
function frame:QUEST_LOG_UPDATE()
	for questIndex=1, maxQuestEntries do
		local EndOfQuests = HandleQuest(questIndex)
		if EndOfQuests then
			break
		end
	end
	
	self:UnregisterEvent("QUEST_LOG_UPDATE")
end
frame:RegisterEvent("QUEST_LOG_UPDATE")

function frame:QUEST_ACCEPTED(event, questIndex)
	HandleQuest(questIndex)
end
frame:RegisterEvent("QUEST_ACCEPTED")

function frame:UI_INFO_MESSAGE(event, msg)
	local objective, cur, goal, isComplete = LibgQuest:ParseObjectiveText(msg)
	if objective then
		local index = LibgQuest:GetQuestIndexByObjective(objective)
		if not index then
			return LibgQuest.debug and print(msg, objective, cur, goal, isComplete)
		end
		UpdateObjective(objective, cur, goal, isComplete)
		if isComplete then
			callbacks:Fire("QUEST_OBJECTIVE_COMPLETED", index, objective)
			
			local quest = Quests[Objectives[objective].quest]
			
			if quest.isComplete then
				callbacks:Fire("QUEST_COMPLETED", index)
			end
		else
			callbacks:Fire("QUEST_OBJECTIVE_PROGRESS", index, objective, cur, goal)
		end
	end
end
frame:RegisterEvent("UI_INFO_MESSAGE")

local CompleteQuestPending = {}
LibgQuest:Hook("QuestRewardCompleteButton_OnClick", function()
	CompleteQuestPending[1] = GetTitleText()
	CompleteQuestPending[2] = time() + 5
end)
	
-- GetAbandonQuestName() only returns valid results between SetAbandonQuest and AbandonQuest calls.
-- There also isn't any QUEST_ABANDONED event, so in order to avoid having to scan the entire log,
-- we hook SetAbandonQuest to get the name, and AbandonQuest to know when the quest is abandoned.
LibgQuest:Hook("SetAbandonQuest", function()
	AbandonQuestName = GetAbandonQuestName()
end)

LibgQuest:Hook("AbandonQuest", function()
	callbacks:Fire("QUEST_ABANDONED", AbandonQuestName)
	
	-- Remove entries from Quest and Objectives tables.
	RemoveQuestByName(AbandonQuestName)

	AbandonQuestName = nil
end)

LibgQuest:HookScript(QuestLogFrame, "OnEvent", function(self, event)
	if event == "QUEST_LOG_UPDATE" then
		if CompleteQuestPending[1] then
			if time() > CompleteQuestPending[2] then
				CompleteQuestPending[1] = nil
				CompleteQuestPending[2] = nil
			elseif not LibgQuest:GetQuestLogIndexByName(CompleteQuestPending[1]) then
				callbacks:Fire("QUEST_HANDED_IN", CompleteQuestPending[1])
				CompleteQuestPending[1] = nil
				CompleteQuestPending[2] = nil
				
				RemoveQuestByName(CompleteQuestPending[1])
			end
		end
	end
end)

-- Update old embeds.
for target, v in pairs(LibgQuest.embeds) do
	LibgQuest:Embed(target)
end