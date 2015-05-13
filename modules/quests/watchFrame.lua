--[[	$Id: watchFrame.lua 3726 2013-11-15 12:25:16Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.watchframe = caelUI.createModule("WatchFrame")

watchframe = caelUI.watchframe

local dummy, pixelScale = caelUI.dummy, caelUI.scale

local OT = ObjectiveTrackerFrame
local BlocksFrame = OT.BlocksFrame

watchframe:SetWidth(pixelScale(223))
watchframe:SetHeight(pixelScale(caelUI.screenHeight / 2))
watchframe:SetPoint("TOPRIGHT", UIParent, pixelScale(-5), pixelScale(-5))
watchframe:EnableMouse(false)

OT:ClearAllPoints()
OT:SetPoint("TOP", watchframe)
OT:SetHeight(pixelScale(caelUI.screenHeight / 2))

hooksecurefunc(OT, "SetPoint", function(_, _, parent, point)
	if parent ~= watchframe then
		OT:ClearAllPoints()
		OT:SetPoint("TOP", watchframe)
	end
end)

OT.HeaderMenu.MinimizeButton:SetNormalTexture([[Interface\Addons\caelUI\media\miscellaneous\watchframeCollapse]])
OT.HeaderMenu.MinimizeButton:SetPushedTexture([[Interface\Addons\caelUI\media\miscellaneous\watchframeCollapse]])

for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
	local header = BlocksFrame[headerName]

	header.Background:Hide()
	header.Text:SetFont(caelMedia.fonts.ADDON_FONT, 11)
end

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not block.headerStyled then
	block.HeaderText:SetFont(caelMedia.fonts.ADDON_FONT, 11)
		block.headerStyled = true
	end
end)

hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not block.headerStyled then
		block.HeaderText:SetFont(caelMedia.fonts.ADDON_FONT, 11)
		block.headerStyled = true
	end

	local button = block.itemButton

	if button and not button.styled then
		button:SetScale(0.85)

		button.normal = button:CreateTexture("Frame", nil, self)
		button.normal:SetTexture(caelMedia.files.buttonNormal)
		button.normal:SetPoint("TOPLEFT", pixelScale(-3.5), pixelScale(3.5))
		button.normal:SetPoint("BOTTOMRIGHT", pixelScale(3.5), pixelScale(-3.5))
		button.normal:SetVertexColor(0.25, 0.25, 0.25)

		button:SetNormalTexture(button.normal)

		button.gloss = button:CreateTexture("Frame", nil, self)
		button.gloss:SetTexture(caelMedia.files.buttonGloss)
		button.gloss:SetPoint("TOPLEFT", pixelScale(-4.5), pixelScale(4.5))
		button.gloss:SetPoint("BOTTOMRIGHT", pixelScale(4.5), pixelScale(-4.5))
		button.gloss:SetVertexColor(1, 1, 1, 0.5)

		button.pushed = button:CreateTexture("Frame", nil, self)
		button.pushed:SetTexture(caelMedia.files.buttonNormal)
		button.pushed:SetPoint("TOPLEFT", pixelScale(-3.5), pixelScale(3.5))
		button.pushed:SetPoint("BOTTOMRIGHT", pixelScale(3.5), pixelScale(-3.5))
		button.pushed:SetVertexColor(1, 1, 1)

		button:SetPushedTexture(button.pushed)

		button:SetHighlightTexture("")

		button.HotKey:ClearAllPoints()
		button.HotKey:SetPoint("TOP", itemButton, -1, 0)
		button.HotKey:SetJustifyH("CENTER")
		button.HotKey:SetFont(caelMedia.fonts.ADDON_FONT, 11)

		button.icon:SetTexCoord(.08, .92, .08, .92)

		button.styled = true
	end
end)

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
	if block.module == QUEST_TRACKER_MODULE or block.module == ACHIEVEMENT_TRACKER_MODULE then
		local line = block.currentLine

		local p1, a, p2, x, y = line:GetPoint()
		line:SetPoint(p1, a, p2, x, y - 4)
	end
end)

local function fixBlockHeight(block)
	if block.shouldFix then
		local height = block:GetHeight()

		if block.lines then
			for _, line in pairs(block.lines) do
				if line:IsShown() then
					height = height + 4
				end
			end
		end

		block.shouldFix = false
		block:SetHeight(height + 5)
		block.shouldFix = true
	end
end

hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
	if block.lines then
		for _, line in pairs(block.lines) do
			if not line.styled then
				line.Text:SetFont(caelMedia.fonts.ADDON_FONT, 11)
				line.Text:SetSpacing(2)

				if line.Dash then
					line.Dash:SetFont(caelMedia.fonts.ADDON_FONT, 11)
				end

				line:SetHeight(line.Text:GetHeight())

				line.styled = true
			end
		end
	end

	if not block.styled then
		block.shouldFix = true
		hooksecurefunc(block, "SetHeight", fixBlockHeight)
		block.styled = true
	end
end)

local BossExists = function()
	for i = 1, MAX_BOSS_FRAMES do
		if UnitExists("boss"..i) and UnitIsEnemy("player", "boss"..i) then
			return true
		end
	end
end

local ZoneChange = function(zone)
	local _, instanceType = IsInInstance()

	if instanceType == "arena" or BossExists() then
		if not OT.collapsed then
			ObjectiveTracker_MinimizeButton_OnClick(OT.HeaderMenu.MinimizeButton)
		end
	elseif OT.collapsed and not InCombatLockdown() then
		ObjectiveTracker_MinimizeButton_OnClick(OT.HeaderMenu.MinimizeButton)
	end
end

watchframe:SetScript("OnEvent", function(self, event)
	local zone = GetRealZoneText()
	if zone and zone ~= "" then
		return ZoneChange(zone)
	end
end)

for _, event in next, {
	"INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_REGEN_ENABLED",
	"UNIT_TARGETABLE_CHANGED",
} do
	watchframe:RegisterEvent(event)
end