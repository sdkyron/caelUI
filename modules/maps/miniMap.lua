--[[	$Id: miniMap.lua 3986 2015-01-26 10:23:06Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.minimap = caelUI.createModule("Minimap")

local menuFrame = CreateFrame("Frame", "BobMinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")

local menuList = {
	{text = "Character",				func = function() ToggleCharacter("PaperDollFrame") end},
	{text = "Spells",					func = function() ToggleSpellBook("spell") end},
	{text = "Talents",				func = function() ToggleTalentFrame() end},
	{text = "Achievements",			func = function() ToggleAchievementFrame() end},
	{text = "Quests",					func = function() ToggleFrame(QuestLogFrame) end},
	{text = "Friends",				func = function() ToggleFriendsFrame(1) end},
	{text = "Guild",					func = function() ToggleGuildFrame(1) end},
	{text = "Group Finder",			func = function() ToggleFrame(PVEFrame) end},
	{text = "PVP",						func = function() if(not PVPUIFrame) then LoadAddOn("Blizzard_PVPUI") end PVPUIFrame_ToggleFrame()	end},
	{text = "Dungeon Journal",		func = function() ToggleEncounterJournal() end},
	{text = "Mounts",					func = function() TogglePetJournal(1) end},
	{text = "Pets",					func = function() TogglePetJournal(2) end},
	{text = "Calendar",				func = function() if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle()	end},
	{text = "Store",					func = function()	if(not StoreFrame) then LoadAddOn("Blizzard_StoreUI") end ToggleStoreUI()	end},
	{text = "Customer Support",	func = function() ToggleHelpFrame() end},
}

for _, object in pairs({
		BattlegroundShine,
		GameTimeFrame,
		MinimapBorder,
		MinimapZoomIn,
		MinimapZoomOut,
		MinimapNorthTag,
		MinimapBorderTop,
		MiniMapWorldMapButton,
		MinimapZoneTextButton,
		MiniMapTrackingBackground,
		MiniMapTrackingIconOverlay,
		MiniMapTrackingButtonBorder,
		QueueStatusMinimapButtonBorder,
		QueueStatusMinimapButtonGroupSize,
}) do
	if object:GetObjectType() == "Texture" then
		object:SetTexture(nil)
	else
		object:Hide()
	end
end

local HideDifficultyFrame = function()
    GuildInstanceDifficulty:EnableMouse(false)
    GuildInstanceDifficulty:SetAlpha(0)

    MiniMapInstanceDifficulty:EnableMouse(false)
    MiniMapInstanceDifficulty:SetAlpha(0)
end

local instanceTexts = {
	[0] = "",
	[1] = "5",
	[2] = "5H",
	[3] = "10",
	[4] = "25",
	[5] = "10H",
	[6] = "25H",
	[7] = "RF",
	[8] = "CM",
	[9] = "40",
	[11] = "3H",
	[12] = "3",
	[16] = "M",
}

local GetDifficultyText = function()
    local _, _, difficultyIndex, _, maxPlayers, _, _, _, instanceGroupSize = GetInstanceInfo()

    local instanceText = ""

	if instanceTexts[difficultyIndex] ~= nil then
		instanceText = "|cffffffff"..instanceTexts[difficultyIndex].."|r"
	else
		if difficultyIndex == 14 then
			instanceText = "|cffffffff"..instanceGroupSize.."N|r"
		elseif difficultyIndex == 15 then
			instanceText = "|cffffffff"..instanceGroupSize.."H|r"
		end
	end

	if isGuildGroup or GuildInstanceDifficulty:IsShown() then
		instanceText = format("|cffffffffGUILD %s|r", instanceText)
	end

    return instanceText
end

local buttonBlacklist = {
	["QueueStatusMinimapButton"] = true,
	["MiniMapTracking"] = true,
	["MiniMapMailFrame"] = true,
	["HelpOpenTicketButton"] = true,
	["GameTimeFrame"] = true,
}

local buttons = {}
local button = CreateFrame("Frame", "ButtonCollectFrame", UIParent)
local maxButtons = caelUI.round(Minimap:GetWidth() / 25) -- Max buttons per minimap side

local SetStyle = function()
	button:SetSize(20, 20)
	button:SetPoint("CENTER", Minimap, "BOTTOMLEFT")

	for i = 1, #buttons do
		buttons[i]:ClearAllPoints()

		if i == 1 then
			buttons[i]:SetPoint("CENTER", button)
		elseif i == maxButtons then
			buttons[i]:SetPoint("BOTTOM", buttons[1], "TOP")
		else
			buttons[i]:SetPoint("LEFT", buttons[i-1], "RIGHT")
		end

		buttons[i].ClearAllPoints = caelUI.dummy
		buttons[i].SetPoint = caelUI.dummy
		buttons[i]:SetAlpha(0)

		buttons[i]:HookScript("OnEnter", function(self)
			securecall("UIFrameFadeIn", self, 0.235, 0, 1)
		end)

		buttons[i]:HookScript("OnLeave", function(self)
			securecall("UIFrameFadeOut", self, 0.235, 1, 0)
		end)
	end
end

Minimap.InstanceText = caelPanel3:CreateFontString(nil, "OVERLAY")
Minimap.InstanceText:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 10)
Minimap.InstanceText:SetPoint("TOP", Minimap, 0, caelUI.scale(-5))
Minimap.InstanceText:SetTextColor(1, 1, 1)
Minimap.InstanceText:SetAlpha(0)

caelUI.minimap:RegisterEvent("PLAYER_ENTERING_WORLD")
caelUI.minimap:SetScript("OnEvent", function(self)
	Minimap:EnableMouse(true)
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(Minimap, direction)
		if direction > 0 then
			Minimap_ZoomIn()
		else
			Minimap_ZoomOut()
		end
	end)

	Minimap:ClearAllPoints()
	Minimap:SetParent(caelPanel3)
	Minimap:SetFrameLevel(caelPanel3:GetFrameLevel() - 1)
	Minimap:SetPoint("CENTER")
	Minimap:SetSize(caelPanel3:GetWidth() - caelUI.scale(5), caelPanel3:GetHeight() - caelUI.scale(5))

	Minimap:SetMaskTexture(caelMedia.files.bgFile)
	Minimap:SetBlipTexture([[Interface\Addons\caelUI\media\miscellaneous\charmed.tga]])

	MinimapCluster:EnableMouse(false)

	QueueStatusMinimapButton:SetParent(Minimap)
	QueueStatusMinimapButton:SetFrameStrata("HIGH")
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint("TOPRIGHT")
	QueueStatusMinimapButton:SetHighlightTexture(nil)
	QueueStatusMinimapButton:SetAlpha(0)
	QueueStatusMinimapButton:HookScript("OnEnter", function() securecall("UIFrameFadeIn", QueueStatusMinimapButton, 0.235, 0, 1) end)
	QueueStatusMinimapButton:HookScript("OnLeave", function() securecall("UIFrameFadeOut",QueueStatusMinimapButton, 0.235, 1, 0) end)

	MiniMapTracking:SetParent(Minimap)
	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("TOPLEFT")
	MiniMapTracking:SetAlpha(0)

	MiniMapTrackingButton:SetHighlightTexture(nil)
	MiniMapTrackingButton:HookScript("OnEnter", function() securecall("UIFrameFadeIn", MiniMapTracking, 0.235, 0, 1) end)
	MiniMapTrackingButton:HookScript("OnLeave", function() securecall("UIFrameFadeOut", MiniMapTracking, 0.235, 1, 0) end)

	GarrisonLandingPageTutorialBox.Show = GarrisonLandingPageTutorialBox.Hide
	GarrisonLandingPageMinimapButton:SetParent(Minimap)
	GarrisonLandingPageMinimapButton:SetFrameStrata("HIGH")
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetPoint("BOTTOMRIGHT")
	GarrisonLandingPageMinimapButton:SetScale(0.6)
	GarrisonLandingPageMinimapButton:SetHighlightTexture(nil)
	GarrisonLandingPageMinimapButton:SetAlpha(0)
	GarrisonLandingPageMinimapButton:HookScript("OnEnter", function() securecall("UIFrameFadeIn", GarrisonLandingPageMinimapButton, 0.235, 0, 1) end)
	GarrisonLandingPageMinimapButton:HookScript("OnLeave", function() securecall("UIFrameFadeOut", GarrisonLandingPageMinimapButton, 0.235, 1, 0) end)

	DurabilityFrame:UnregisterAllEvents()
	DurabilityFrame:SetAlpha(0)

	MiniMapMailFrame:UnregisterAllEvents()

	hooksecurefunc(GuildInstanceDifficulty, "Show", function()
		isGuildGroup = true
		HideDifficultyFrame()
	end)

	hooksecurefunc(GuildInstanceDifficulty, "Hide", function()
		isGuildGroup = false
	end)

	hooksecurefunc(MiniMapInstanceDifficulty, "Show", function()
		HideDifficultyFrame()
	end)

	GuildInstanceDifficulty:HookScript("OnEvent", function(self)
		Minimap.InstanceText:SetText(GetDifficultyText())
	end)

	MiniMapInstanceDifficulty:HookScript("OnEvent", function(self)
		Minimap.InstanceText:SetText(GetDifficultyText())
	end)

	Minimap:HookScript("OnEnter", function(self)
		securecall("UIFrameFadeIn", self.InstanceText, 0.235, 0, 1)
	end)

	Minimap:HookScript("OnLeave", function(self)
		securecall("UIFrameFadeOut", self.InstanceText, 0.235, 1, 0)
	end)

	Minimap:HookScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)	
		else
			Minimap_OnClick(self)
		end
	end)

	for i, child in ipairs({Minimap:GetChildren()}) do
		if not buttonBlacklist[child:GetName()] then
			if child:GetObjectType() == "Button" and child:GetNumRegions() >= 3 and child:IsShown() then
				child:SetParent(button)
				table.insert(buttons, child)
			end
		end
	end

	if #buttons == 0 then
		button:Hide()
	end

	SetStyle()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)