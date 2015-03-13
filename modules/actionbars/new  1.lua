--[[	$Id: actionBars.lua 3945 2014-10-23 14:00:04Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.bars = caelUI.createModule("ActionBars")

local dummy, kill, pixelScale = caelUI.dummy, caelUI.kill, caelUI.scale

--[[ Setup button grid ]]
----------------------

local buttonGrid = CreateFrame("Frame")
buttonGrid:RegisterEvent("PLAYER_ENTERING_WORLD")
buttonGrid:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	ActionButton_HideGrid = dummy

	for i = 1, 12 do
		local button = _G[format("ActionButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

--		button = _G[format("BonusActionButton%d", i)]
--		button:SetAttribute("showgrid", 1)
--		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)

		button = _G[format("MultiBarBottomRightButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
		
		button = _G[format("MultiBarBottomLeftButton%d", i)]
		button:SetAttribute("showgrid", 1)
		ActionButton_ShowGrid(button)
	end

	PetActionBarFrame:UnregisterEvent("PET_BAR_SHOWGRID")
	PetActionBarFrame:UnregisterEvent("PET_BAR_HIDEGRID")

--	PetActionBar_ShowGrid()
end)

--[[ MainMenuBar ]]

local bar1 = CreateFrame("Frame", "caelUI_bar1", UIParent, "SecureHandlerStateTemplate")
bar1:ClearAllPoints()
bar1:SetAllPoints(caelPanel5)

MainMenuBarArtFrame:SetParent(bar1)
MainMenuBarArtFrame:EnableMouse(false)

MainMenuBar.slideOut.IsPlaying = function() return true end

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["ActionButton"..i]
	button:ClearAllPoints()
	button:SetScale(0.68)
	if i == 1 then
		button:SetPoint("TOPLEFT", caelPanel5, pixelScale(4.5), pixelScale(-4.5))
	elseif i == 7 then
		button:SetPoint("TOPLEFT", _G["ActionButton1"], "BOTTOMLEFT", 0, pixelScale(-6.5))
	else
		button:SetPoint("LEFT", _G["ActionButton"..i-1], "RIGHT", pixelScale(5), 0)
	end
end

RegisterStateDriver(bar1, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

--[[ Bottom Left bar ]]

local bar2 = CreateFrame("Frame", "caelUI_bar2", UIParent, "SecureHandlerStateTemplate")
bar2:ClearAllPoints()
bar2:SetAllPoints(caelPanel6)

MultiBarBottomLeft:SetParent(bar2)
MultiBarBottomLeft:EnableMouse(false)

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["MultiBarBottomLeftButton"..i]
	button:ClearAllPoints()
	button:SetScale(0.68)
	if i == 1 then
		button:SetPoint("TOPLEFT", caelPanel6, pixelScale(4.5), pixelScale(-4.5))
	elseif i == 7 then
		button:SetPoint("TOPLEFT", _G["MultiBarBottomLeftButton1"], "BOTTOMLEFT", 0, pixelScale(-6.5))
	else
		button:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", pixelScale(5), 0)
	end
end

RegisterStateDriver(bar2, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

--[[ Bottom Right bar ]]

local bar3 = CreateFrame("Frame", "caelUI_bar3", UIParent, "SecureHandlerStateTemplate")
bar3:ClearAllPoints()
bar3:SetAllPoints(caelPanel7)

MultiBarBottomRight:SetParent(bar3)
MultiBarBottomRight:EnableMouse(false)

for i= 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["MultiBarBottomRightButton"..i]
	button:ClearAllPoints()
	button:SetScale(0.68)
	if i == 1 then
		button:SetPoint("TOPLEFT", caelPanel7, pixelScale(4.5), pixelScale(-4.5))
	elseif i == 7 then
		button:SetPoint("TOPLEFT", _G["MultiBarBottomRightButton1"], "BOTTOMLEFT", 0, pixelScale(-6.5))
	else
		button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", pixelScale(5), 0)
	end
end

RegisterStateDriver(bar3, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

--[[ Right bar 1 ]]

local bar4 = CreateFrame("Frame", "caelUI_bar4", UIParent, "SecureHandlerStateTemplate")
bar4:ClearAllPoints()
bar4:SetAllPoints(caelPanel4)

MultiBarRight:SetParent(bar4)
MultiBarRight:EnableMouse(false)

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["MultiBarRightButton"..i]
	button:ClearAllPoints()
	button:SetScale(0.68)
	if i == 1 then
		button:SetPoint("TOPLEFT", caelPanel4, pixelScale(4.5), pixelScale(-4.5))
	elseif i == 7 then
		button:SetPoint("TOPLEFT", _G["MultiBarRightButton1"], "BOTTOMLEFT", 0, pixelScale(-6.5))
	else
		button:SetPoint("LEFT", _G["MultiBarRightButton"..i-1], "RIGHT", pixelScale(5), 0)
	end
end

RegisterStateDriver(bar4, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

--[[ Right bar 2 ]]

local bar5 = CreateFrame("Frame", "caelUI_bar5", UIParent, "SecureHandlerStateTemplate")
bar5:ClearAllPoints()
bar5:SetAllPoints(caelPanel9)

MultiBarLeft:SetParent(bar5)
MultiBarLeft:EnableMouse(false)

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["MultiBarLeftButton"..i]
	button:ClearAllPoints()
	button:SetScale(0.68)
	if i == 1 then
		button:SetPoint("TOPLEFT", caelPanel9, pixelScale(4.5), pixelScale(-4.5))
	else
		local previous = _G["MultiBarLeftButton"..i-1]
		button:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, pixelScale(-4.5))
	end
end

RegisterStateDriver(bar5, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

-- [[ Override bar ]]

local numOverride = 7

local override = CreateFrame("Frame", "caelUI_OverrideBar", UIParent, "SecureHandlerStateTemplate")
override:SetWidth(323)
override:SetHeight(26)
override:SetPoint("BOTTOM", bar2, "TOP", 0, 1)

OverrideActionBar:SetParent(override)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil)

local leaveButtonPlaced = false

for i = 1, numOverride do
	local bu = _G["OverrideActionBarButton"..i]
	if not bu and not leaveButtonPlaced then
		bu = OverrideActionBar.leaveButton
		leaveButtonPlaced = true
	end
	if not bu then
		break
	end
	bu:ClearAllPoints()
	bu:SetScale(0.68)
	if i == 1 then
		bu:SetPoint("BOTTOMLEFT", override, "BOTTOMLEFT")
	else
		local previous = _G["OverrideActionBarButton"..i-1]
		bu:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
end

RegisterStateDriver(override, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

-- [[ Hide stuff ]]

local frames = {MainMenuBar, MainMenuBarPageNumber, ActionBarDownButton,
	ActionBarUpButton, OverrideActionBarExpBar, OverrideActionBarHealthBar,
	OverrideActionBarPowerBar, OverrideActionBarPitchFrame, CharacterMicroButton,
	SpellbookMicroButton, TalentMicroButton, AchievementMicroButton, QuestLogMicroButton,
	GuildMicroButton, PVPMicroButton, LFDMicroButton, CompanionsMicroButton, EJMicroButton,
	MainMenuMicroButton, HelpMicroButton, StoreMicroButton, MainMenuBarBackpackButton
}

for _, frame in pairs(frames) do
	frame:SetParent(caelUI.KillFrame)
end

StanceBarLeft:SetTexture("")
StanceBarMiddle:SetTexture("")
StanceBarRight:SetTexture("")
SlidingActionBarTexture0:SetTexture("")
SlidingActionBarTexture1:SetTexture("")
PossessBackground1:SetTexture("")
PossessBackground2:SetTexture("")
MainMenuBarTexture0:SetTexture("")
MainMenuBarTexture1:SetTexture("")
MainMenuBarTexture2:SetTexture("")
MainMenuBarTexture3:SetTexture("")
MainMenuBarLeftEndCap:SetTexture("")
MainMenuBarRightEndCap:SetTexture("")

local textureList = {"_BG","EndCapL","EndCapR","_Border","Divider1","Divider2","Divider3","ExitBG","MicroBGL","MicroBGR","_MicroBGMid","ButtonBGL","ButtonBGR","_ButtonBGMid"}

for _, tex in pairs(textureList) do
	OverrideActionBar[tex]:SetAlpha(0)
end

for i = 0, 3 do
	_G["CharacterBag"..i.."Slot"]:SetParent(caelUI.KillFrame)
end

--[[ Pet bar ]]

local numpet = NUM_PET_ACTION_SLOTS

local setPetButtonAlpha = function(alpha)
	for i = 1, numpet do
		local button = _G["PetActionButton" .. i]
		button:SetAlpha(alpha)

		button.cooldown:SetSwipeColor(0, 0, 0, 0.8 * alpha)
		button.cooldown:SetDrawBling(alpha == 1)
	end
end

local function showPetButtons()
	setPetButtonAlpha(1)
end

local function hidePetButtons()
	setPetButtonAlpha(0)
end

local petbar = CreateFrame("Frame", "caelUI_PetBar", UIParent, "SecureHandlerStateTemplate")
petbar:ClearAllPoints()
petbar:SetWidth(pixelScale(120))
petbar:SetHeight(pixelScale(50))
petbar:SetPoint("BOTTOM", UIParent, pixelScale(-337), pixelScale(360))

PetActionBarFrame:SetParent(petbar)
PetActionBarFrame:SetHeight(0.001)

for i = 1, numpet do
	local button = _G["PetActionButton"..i]
	local cd = _G["PetActionButton"..i.."Cooldown"]

	button:ClearAllPoints()
	button:SetParent(petBar)
	button:SetScale(0.71) 

	if i == 1 then
		button:SetPoint("TOPLEFT", petbar, pixelScale(1), pixelScale(-1))
	elseif i == ((numpet / 2) + 1) then -- Get our middle button + 1 to make the rows even
		button:SetPoint("TOPLEFT", _G["PetActionButton1"], "BOTTOMLEFT", 0, pixelScale(-1))
	else
		local previous = _G["PetActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", pixelScale(1), 0)
	end

	button:HookScript("OnEnter", showPetButtons)
	button:HookScript("OnLeave", hidePetButtons)

	cd:SetAllPoints(button)
end

hidePetButtons()

caelUI.bars:RegisterEvent("PLAYER_LOGIN", hidePetButtons)
caelUI.bars:RegisterEvent("PLAYER_ENTERING_WORLD", hidePetButtons)

RegisterStateDriver(petbar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists,nomounted] show; hide")

--[[ Stance/possess bar]]

local stancebar = CreateFrame("Frame", "caelUI_StanceBar", UIParent, "SecureHandlerStateTemplate")
stancebar:SetPoint("BOTTOMLEFT", bar1, "TOPLEFT",  pixelScale(3), pixelScale(-4))

StanceBarFrame:SetParent(stancebar)
StanceBarFrame:EnableMouse(false)

for i = 1, NUM_STANCE_SLOTS do
	local button = _G["StanceButton"..i]
	button:ClearAllPoints()
	button:SetSize(ActionButton1:GetSize())
	button:SetScale(0.68)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", stancebar, 0, pixelScale(6.5))
	else
		local previous = _G["StanceButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", pixelScale(6), 0)
	end
end

PossessBarFrame:SetParent(stancebar)
PossessBarFrame:EnableMouse(false)

for i = 1, NUM_POSSESS_SLOTS do
	local button = _G["PossessButton"..i]
	button:ClearAllPoints()
	button:SetSize(ActionButton1:GetSize())
	button:SetScale(0.68)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", stancebar, 0, pixelScale(6.5))
	else
		local previous = _G["PossessButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", pixelScale(6), 0)
	end
end

RegisterStateDriver(stancebar, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

local cachedNumForms = 0

local function setStancebarWidth()
	stancebar:SetWidth(cachedNumForms * 27 - 1)
end

local delayedPositioner = CreateFrame("Frame")
delayedPositioner:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	setStancebarWidth()
end)

hooksecurefunc("StanceBar_Update", function()
	local numForms = GetNumShapeshiftForms()

	if cachedNumForms ~= numForms then
		cachedNumForms = numForms

		if not InCombatLockdown() then
			setStancebarWidth()
		else
			delayedPositioner:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	end
end)

--[[ Right bars on mouseover ]]

bar5:EnableMouse(true)

local function setButtonAlpha(alpha)
	bar5:SetAlpha(alpha)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local ab1 = _G["MultiBarLeftButton"..i]

		ab1.cooldown:SetSwipeColor(0, 0, 0, 0.8 * alpha)
		ab1.cooldown:SetDrawBling(alpha == 1)
	end
end

local function showButtons()
	setButtonAlpha(1)
end

local function hideButtons()
	setButtonAlpha(0)
end

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local ab1 = _G["MultiBarLeftButton"..i]

	ab1:HookScript("OnEnter", showButtons)
	ab1:HookScript("OnLeave", hideButtons)
end

bar5:HookScript("OnEnter", showButtons)
bar5:HookScript("OnLeave", hideButtons)

hideButtons()

-- dumb fix for cooldown spirals not playing nice with alpha settings
caelUI.bars:RegisterEvent("PLAYER_LOGIN", hideButtons)
caelUI.bars:RegisterEvent("PLAYER_ENTERING_WORLD", hideButtons)

--[[ Extra bar ]]

local barextra = CreateFrame("Frame", "caelUI_ExtraActionBar", UIParent, "SecureHandlerStateTemplate")
barextra:SetSize(ExtraActionBarFrame:GetSize())
barextra:SetPoint("BOTTOM", caelPanel1, "TOP", 0, pixelScale(26))

ExtraActionBarFrame:SetParent(barextra)
ExtraActionBarFrame:EnableMouse(false)

ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER")
ExtraActionBarFrame.ignoreFramePositionManager = true

RegisterStateDriver(barextra, "visibility", "[extrabar] show; hide")

-- [[ Leave vehicle ]]

local leave = CreateFrame("Frame", "caelUI_LeaveVehicle", UIParent, "SecureHandlerStateTemplate")
leave:SetSize(18, 18)

leave:SetPoint("BOTTOM", pixelScale(-146), pixelScale(268.5))

local leaveBu = CreateFrame("Button", nil, leave, "SecureHandlerClickTemplate, SecureHandlerStateTemplate")
leaveBu:SetAllPoints()
leaveBu:RegisterForClicks("AnyUp")
leaveBu:SetScript("OnClick", VehicleExit)

caelMedia.createBackdrop(leaveBu)

leaveBu.t = leaveBu:CreateFontString(nil, "OVERLAY")
leaveBu.t:SetFont(caelMedia.fonts.ADDON_FONT, 9)
leaveBu.t:SetPoint("CENTER")
leaveBu.t:SetTextColor(0.33, 0.59, 0.33)
leaveBu.t:SetText("•")

leaveBu:SetScript("OnEnter", function(self)
	if self:IsEnabled() then
		leaveBu.t:SetTextColor(0.69, 0.31, 0.31)
	end
end)

leaveBu:SetScript("OnLeave", function(self)
	leaveBu.t:SetTextColor(0.33, 0.59, 0.33)
end)

RegisterStateDriver(leaveBu, "visibility", "[petbattle][vehicleui][overridebar] hide; [@vehicle,exists][possessbar] show; hide")
RegisterStateDriver(leave, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")