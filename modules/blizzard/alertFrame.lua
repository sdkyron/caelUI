--[[	$Id: alertFrame.lua 3763 2013-12-01 10:56:18Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Move and reverse the Alert Frame	]]

caelUI.alertframe = caelUI.createModule("AlertFrame")

------------
-- Config --
------------

local POSITION = "TOP"
local ANCHOR_POINT = "BOTTOM"
local YOFFSET = -10
local SCALE = 1.1
local AlertFramePos = {"TOP", UIParent, "TOP", 0, -18}

----------
-- Code --
----------

UIPARENT_MANAGED_FRAME_POSITIONS["AchievementAlertFrame1"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["AchievementAlertFrame2"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["DungeonCompletionAlertFrame1"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["GuildChallengeAlertFrame"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["AlertFrame"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["ChallengeModeAlertFrame1"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["ScenarioAlertFrame1"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["GarrisonFollowerAlertFrame"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["GarrisonMissionAlertFrame"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["GarrisonBuildingAlertFrame"] = nil;
UIPARENT_MANAGED_FRAME_POSITIONS["MissingLootFrame"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil;  
UIPARENT_MANAGED_FRAME_POSITIONS["StorePurchaseAlertFrame"] = nil; 
UIPARENT_MANAGED_FRAME_POSITIONS["DigsiteCompleteToastFrame"] = nil; 

for i=1, MAX_ACHIEVEMENT_ALERTS do
	UIPARENT_MANAGED_FRAME_POSITIONS["AchievementAlertFrame"..i] = nil; 
end

for i=1, MAX_ACHIEVEMENT_ALERTS do
	UIPARENT_MANAGED_FRAME_POSITIONS["CriteriaAlertFrame"..i] = nil; 
end

for i=1, #LOOT_WON_ALERT_FRAMES do
	UIPARENT_MANAGED_FRAME_POSITIONS[LOOT_WON_ALERT_FRAMES[i]] = nil;  
end

for i=1, #LOOT_UPGRADE_ALERT_FRAMES do
	UIPARENT_MANAGED_FRAME_POSITIONS[LOOT_UPGRADE_ALERT_FRAMES[i]] = nil;  
end

for i=1, #MONEY_WON_ALERT_FRAMES do
	UIPARENT_MANAGED_FRAME_POSITIONS[MONEY_WON_ALERT_FRAMES[i]] = nil;  
end

local MoveAlertFrame = CreateFrame("Frame", "MoveAlertFrame", UIParent)
MoveAlertFrame:SetWidth(180)
MoveAlertFrame:SetHeight(20)
MoveAlertFrame:SetPoint(unpack(AlertFramePos))

-- Needs to be moved seperately because it isnt attached to the AlertFrame
GarrisonRandomMissionAlertFrame:ClearAllPoints()
GarrisonRandomMissionAlertFrame:SetPoint("BOTTOM", 2, 210)
GarrisonRandomMissionAlertFrame:SetScale(SCALE)
	
local function ReverseStorePurchaseFrame(alertAnchor)
	local frame = StorePurchaseAlertFrame
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()	
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		frame:SetScale(SCALE)
		return frame
	end
	return alertAnchor
end

local function ReverseLootWonFrame(alertAnchor)
	for i=1, #LOOT_WON_ALERT_FRAMES do
		local frame = LOOT_WON_ALERT_FRAMES[i]
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
			frame:SetScale(SCALE)
			alertAnchor = frame
		end
	end
	return alertAnchor
end

function ReverseLootUpgradeFrame(alertAnchor)
	for i=1, #LOOT_UPGRADE_ALERT_FRAMES do
		local frame = LOOT_UPGRADE_ALERT_FRAMES[i]
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
			frame:SetScale(SCALE)
			alertAnchor = frame
		end
	end
	return alertAnchor
end
	
local function ReverseMoneyWonFrame(alertAnchor)
	for i=1, #MONEY_WON_ALERT_FRAMES do
		local frame = MONEY_WON_ALERT_FRAMES[i]
		if ( frame:IsShown() ) then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
			frame:SetScale(SCALE)
			alertAnchor = frame
		end
	end
	return alertAnchor
end
		
local function ReverseAchievementFrame(alertAnchor)
	if ( AchievementAlertFrame1 ) then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]
			if ( frame and frame:IsShown() ) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
				frame:SetScale(SCALE)
				alertAnchor = frame
			end
		end
	end
	return alertAnchor
end

local function ReverseCriteriaFrame(alertAnchor)
	if ( CriteriaAlertFrame1 ) then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["CriteriaAlertFrame"..i]
			if ( frame and frame:IsShown() ) then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
				frame:SetScale(SCALE)
				alertAnchor = frame
			end
		end
	end
	return alertAnchor
end
 
local function ReverseChallengeModeFrame(alertAnchor)
	local frame = ChallengeModeAlertFrame1;
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		frame:SetScale(SCALE)
		alertAnchor = frame
	end
	return alertAnchor
end
 
local function ReverseDungeonCompletionFrame(alertAnchor)
	local frame = DungeonCompletionAlertFrame1;
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		frame:SetScale(SCALE)
		alertAnchor = frame
	end
	return alertAnchor
end
 
local function ReverseScenarioFrame(alertAnchor)
	local frame = ScenarioAlertFrame1
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		frame:SetScale(SCALE)
		alertAnchor = frame
	end
	return alertAnchor
end
 
local function ReverseGuildChallengeFrame(alertAnchor)
	local frame = GuildChallengeAlertFrame
	if ( frame:IsShown() ) then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		frame:SetScale(SCALE)
		alertAnchor = frame
	end
	return alertAnchor
end
 
local function ReverseDigsiteCompleteToastFrame(alertAnchor)
	if ( DigsiteCompleteToastFrame and DigsiteCompleteToastFrame:IsShown() ) then
		DigsiteCompleteToastFrame:ClearAllPoints()
		DigsiteCompleteToastFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		DigsiteCompleteToastFrame:SetScale(SCALE)
		alertAnchor = DigsiteCompleteToastFrame
	end
	return alertAnchor
end

local function ReverseGarrisonBuildingAlertFrame(alertAnchor)
	if ( GarrisonBuildingAlertFrame and GarrisonBuildingAlertFrame:IsShown() ) then
		GarrisonBuildingAlertFrame:ClearAllPoints()
		GarrisonBuildingAlertFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 2, YOFFSET)
		GarrisonBuildingAlertFrame:SetScale(SCALE)
		alertAnchor = GarrisonBuildingAlertFrame
	end
	return alertAnchor
end

local function ReverseGarrisonMissionAlertFrame(alertAnchor)
	if ( GarrisonMissionAlertFrame and GarrisonMissionAlertFrame:IsShown() ) then
		GarrisonMissionAlertFrame:ClearAllPoints()
		GarrisonMissionAlertFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 1, YOFFSET)
		GarrisonMissionAlertFrame:SetScale(SCALE)
		alertAnchor = GarrisonMissionAlertFrame
	end
	return alertAnchor
end

function ReverseGarrisonShipMissionAlertFrame(alertAnchor)
	if ( GarrisonShipMissionAlertFrame and GarrisonShipMissionAlertFrame:IsShown() ) then
		GarrisonShipMissionAlertFrame:ClearAllPoints()
		GarrisonShipMissionAlertFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 1, YOFFSET)
		GarrisonShipMissionAlertFrame:SetScale(SCALE)
		alertAnchor = GarrisonShipMissionAlertFrame
	end
	return alertAnchor
end

local function ReverseGarrisonFollowerAlertFrame(alertAnchor)
	if ( GarrisonFollowerAlertFrame and GarrisonFollowerAlertFrame:IsShown() ) then
		GarrisonFollowerAlertFrame:ClearAllPoints()
		GarrisonFollowerAlertFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 1, YOFFSET)
		GarrisonFollowerAlertFrame:SetScale(SCALE)
		alertAnchor = GarrisonFollowerAlertFrame
	end
	return alertAnchor
end

function ReverseGarrisonShipFollowerAlertFrame(alertAnchor)
	if ( GarrisonShipFollowerAlertFrame and GarrisonShipFollowerAlertFrame:IsShown() ) then
		GarrisonShipFollowerAlertFrame:ClearAllPoints()
		GarrisonShipFollowerAlertFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 1, YOFFSET)
		GarrisonShipFollowerAlertFrame:SetScale(SCALE)
		alertAnchor = GarrisonShipFollowerAlertFrame
	end
	return alertAnchor
end

local function ReverseAlertFrame()
	local alertAnchor = AlertFrame
	alertAnchor:ClearAllPoints()
	alertAnchor:SetAllPoints(MoveAlertFrame)
	
	GroupLootContainer:ClearAllPoints()
	GroupLootContainer:SetPoint(POSITION, AlertFrame, ANCHOR_POINT)
	GroupLootContainer:SetScale(SCALE)
   
	MissingLootFrame:ClearAllPoints()
	MissingLootFrame:SetPoint(POSITION, AlertFrame, ANCHOR_POINT)
	MissingLootFrame:SetScale(SCALE)
end
hooksecurefunc("AlertFrame_FixAnchors", ReverseAlertFrame)

hooksecurefunc("AlertFrame_SetStorePurchaseAnchors", ReverseStorePurchaseFrame)
hooksecurefunc("AlertFrame_SetLootWonAnchors", ReverseLootWonFrame)
hooksecurefunc("AlertFrame_SetLootUpgradeFrameAnchors", ReverseLootUpgradeFrame)
hooksecurefunc("AlertFrame_SetMoneyWonAnchors", ReverseMoneyWonFrame)
hooksecurefunc("AlertFrame_SetAchievementAnchors", ReverseAchievementFrame)
hooksecurefunc("AlertFrame_SetCriteriaAnchors", ReverseCriteriaFrame)
hooksecurefunc("AlertFrame_SetChallengeModeAnchors", ReverseChallengeModeFrame)
hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", ReverseDungeonCompletionFrame)
hooksecurefunc("AlertFrame_SetScenarioAnchors", ReverseScenarioFrame)
hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", ReverseGuildChallengeFrame)
hooksecurefunc("AlertFrame_SetDigsiteCompleteToastFrameAnchors", ReverseDigsiteCompleteToastFrame)
hooksecurefunc("AlertFrame_SetGarrisonBuildingAlertFrameAnchors", ReverseGarrisonBuildingAlertFrame)
hooksecurefunc("AlertFrame_SetGarrisonMissionAlertFrameAnchors", ReverseGarrisonMissionAlertFrame)
hooksecurefunc("AlertFrame_SetGarrisonShipMissionAlertFrameAnchors", ReverseGarrisonShipMissionAlertFrame)
hooksecurefunc("AlertFrame_SetGarrisonFollowerAlertFrameAnchors", ReverseGarrisonFollowerAlertFrame)
hooksecurefunc("AlertFrame_SetGarrisonShipFollowerAlertFrameAnchors", ReverseGarrisonShipFollowerAlertFrame)

--[[
SlashCmdList.TEST_ACHIEVEMENT = function()
	PlaySound("LFG_Rewards")
	AchievementFrame_LoadUI()
	AchievementAlertFrame_ShowAlert(5780)
	AchievementAlertFrame_ShowAlert(5000)
	GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
	ChallengeModeAlertFrame_ShowAlert()
	CriteriaAlertFrame_GetAlertFrame()
	GarrisonBuildingAlertFrame_ShowAlert(GARRISON_TOWN_HALL_ALLIANCE)
	GarrisonMissionAlertFrame_ShowAlert(C_Garrison.GetAvailableMissions()[1].missionID)
	GarrisonRandomMissionAlertFrame_ShowAlert(C_Garrison.GetAvailableMissions()[1].missionID)
	--GarrisonFollowerAlertFrame_ShowAlert(followerID)
	--GarrisonShipFollowerAlertFrame_ShowAlert(followerID)
	AlertFrame_AnimateIn(CriteriaAlertFrame1)
	AlertFrame_AnimateIn(DungeonCompletionAlertFrame1)
	AlertFrame_AnimateIn(ScenarioAlertFrame1)
	AlertFrame_FixAnchors()
end
SLASH_TEST_ACHIEVEMENT1 = "/testalerts"
--]]