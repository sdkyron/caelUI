--[[	$Id: actionButtons.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.buttons = caelUI.createModule("ActionButtons")

local _G = getfenv(0)

local find, format, kill, pixelScale = string.find, string.format, caelUI.kill, caelUI.scale

local color = RAID_CLASS_COLORS[caelUI.playerClass]

local hideCount = false
local hideHotkeys = true

local backdrop = {
	bgFile = caelMedia.files.buttonGloss,
	insets = {top = pixelScale(-1), left = pixelScale(-1), bottom = pixelScale(-1), right = pixelScale(-1)},
}

local StyleButton = function(button)

	if not button or (button and button.styled) then
		return
	end

	if button:GetFrameLevel() < 1 then
		button:SetFrameLevel(1)
	end

	local action = button.action
	local buttonName = button:GetName()

	if buttonName:match("MultiCast") or buttonName:match("ExtraActionButton") then
		return
	end

	local isPet			=	buttonName:find("PetActionButton")
	local isShapeshift	=	buttonName:find("StanceButton")

	local button		=	_G[buttonName]
	local name			=	_G[format("%sName", buttonName)]
	local icon			=	_G[format("%sIcon", buttonName)]
	local flash			=	_G[format("%sFlash", buttonName)]
	local floating		=	_G[format("%sFloatingBG", buttonName)]
	local flyoutb		=	_G[format("%sFlyoutBorder", buttonName)]
	local flyoutbshadow	=	_G[format("%sFlyoutBorderShadow", buttonName)]
	local count			=	_G[format("%sCount", buttonName)]
	local border		=	_G[format("%sBorder", buttonName)]
	local hotkey		=	_G[format("%sHotKey", buttonName)]
	local cooldown		=	_G[format("%sCooldown", buttonName)]
	local autocast		=	_G[format("%sAutoCastable", buttonName)]
	local shine			=	_G[format("%sShine", buttonName)]
	local texture		=	(isPet or isShapeshift) and _G[format("%sNormalTexture2", buttonName)] or _G[format("%sNormalTexture", buttonName)]

	button:SetNormalTexture(caelMedia.files.buttonNormal)

	button.pushed = button:CreateTexture("Frame", nil, self)
	button.pushed:SetTexture(caelMedia.files.buttonPushed)
	button.pushed:SetVertexColor(color.r, color.g, color.b)
	button.pushed:SetAllPoints()

	button.checked = button:CreateTexture("Frame", nil, self)
	button.checked:SetTexture(caelMedia.files.buttonChecked)
	button.checked:SetVertexColor(color.r, color.g, color.b)
	button.checked:SetAllPoints()

	button.highlight = button:CreateTexture("Frame", nil, self)
	button.highlight:SetTexture(caelMedia.files.buttonHighlight)
	button.highlight:SetVertexColor(color.r, color.g, color.b)
	button.highlight:SetAllPoints()

	button:SetPushedTexture(button.pushed)
	button:SetCheckedTexture(button.checked)
	button:SetHighlightTexture(button.highlight)

	if not texture then
		texture = button:GetNormalTexture()
	end

	texture:SetAllPoints()
	texture:SetVertexColor(0.5, 0.5, 0.5, 1)

	hooksecurefunc(button, "SetNormalTexture", function(self, texture)
		if texture and texture ~= caelMedia.files.buttonNormal then
			self:SetNormalTexture(caelMedia.files.buttonNormal)
		end
	end)

	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetPoint("TOPLEFT", button, pixelScale(4.5), pixelScale(-4.5))
	icon:SetPoint("BOTTOMRIGHT", button, pixelScale(-4.5), pixelScale(4.5))

	kill(border)
--	border:SetPoint("TOPLEFT", button, pixelScale(-1), pixelScale(1))
--	border:SetPoint("BOTTOMRIGHT", button, pixelScale(1), pixelScale(-1))
--	border:SetTexture(caelMedia.files.buttonNormal)

	flash:SetTexture(caelMedia.files.buttonFlash)

	if autocast then
		autocast:SetTexCoord(0.24, 0.75, 0.24, 0.75)
		autocast:SetPoint("TOPLEFT", pixelScale(2), pixelScale(-2))
		autocast:SetPoint("BOTTOMRIGHT", pixelScale(-2), pixelScale(2))
		autocast:SetAlpha(0)
	end

	if shine then
		shine:SetAllPoints(autocast)
		shine:SetFrameStrata("HIGH")
	end

	cooldown:SetParent(button)
	cooldown:ClearAllPoints()
	cooldown:SetAllPoints(icon)

	button.backdrop = CreateFrame("Frame", nil, button)
	button.backdrop:SetFrameLevel(button:GetFrameLevel() - 1)
	button.backdrop:SetPoint("TOPLEFT", isPet and pixelScale(-1.5) or pixelScale(-1), isPet and pixelScale(1.5) or pixelScale(1))
	button.backdrop:SetPoint("BOTTOMRIGHT", isPet and pixelScale(1.5) or pixelScale(1), isPet and pixelScale(-1.5) or pixelScale(-1))
	button.backdrop:SetBackdrop(caelMedia.borderTable)
	button.backdrop:SetBackdropBorderColor(0, 0, 0, 0.85)

	button.gloss = CreateFrame("Frame", nil, button)
	button.gloss:SetAllPoints()
	button.gloss:SetBackdrop(backdrop)
	button.gloss:SetBackdropColor(0.25, 0.25, 0.25, 0.5)

	if not hideCount then
		count:SetParent(button.gloss)
		count:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 12, "OUTLINEMONOCHROME")
		count:SetPoint("BOTTOMRIGHT", pixelScale(3), pixelScale(-1))
	else
		count:Hide()
	end

	hotkey:SetParent(button.gloss)
	hotkey:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 12, "OUTLINEMONOCHROME")
	hotkey:ClearAllPoints()
	hotkey:SetPoint("TOPRIGHT", pixelScale(3), pixelScale(1))

	if name then
		name:Hide()
	end

	if floating then
		floating:Hide()
	end

--	SpellFlyoutBackgroundEnd:SetAlpha(0)
--	SpellFlyoutHorizontalBackground:SetAlpha(0)
--	SpellFlyoutVerticalBackground:SetAlpha(0)

	if flyoutb then
		kill(flyoutb)
		kill(flyoutbshadow)
	end
--[[
	if not button.glow then
		button.glow = button:CreateTexture(nil, "OVERLAY")
		button.glow:SetTexture("Interface\\SpellActivationOverlay\\IconAlert")
		button.glow:SetPoint("CENTER", button)
		button.glow:SetHeight(button:GetHeight() * 1.3)
		button.glow:SetWidth(button:GetWidth() * 1.3)
		button.glow:SetTexCoord("0.00781250", "0.50781250", "0.53515625", "0.78515625")
		button.glow:SetVertexColor(1, 0, 0, 0.5)
		button.glow:SetBlendMode("ADD")
		button.glow:Hide()
	end
--]]
	button.styled = true
end

local caelButtons_ActionUsable = function(button)
	local name = button:GetName()
	local action = button.action
	local icon = _G[format("%sIcon", name)]
	local texture  = _G[format("%sNormalTexture", name)]

	if IsEquippedAction(action) then
		if texture then
			texture:SetVertexColor(0.33, 0.59, 0.33, 1)

			if button.gloss then
				button.gloss:SetBackdropColor(0.33, 0.59, 0.33, 0.5)
			end
		end
	else
		if texture then
			texture:SetVertexColor(0.5, 0.5, 0.5, 1)

			if button.gloss then
				button.gloss:SetBackdropColor(0.25, 0.25, 0.25, 0.5)
			end
		end
	end

	local isUsable, notEnoughPower = IsUsableAction(action)

	if ActionHasRange(action) and IsActionInRange(action) == 0 then
		icon:SetVertexColor(0.69, 0.31, 0.31)
		return
	elseif notEnoughPower then
		icon:SetVertexColor(0.31, 0.45, 0.63)
		return
	elseif isUsable then
		icon:SetVertexColor(1, 1, 1)
		return
	else
		icon:SetVertexColor(0.1, 0.1, 0.1)
		return
	end
end

local caelButtons_OnUpdate = function(self, elapsed)
	local time = self.cAB_range

	if (not time) then
		self.cAB_range = 0
		return
	end

	time = time + elapsed

	if (time < TOOLTIP_UPDATE_TIME + 0.1) then
		self.cAB_range = time
		return
	else
		self.cAB_range = 0
		caelButtons_ActionUsable(self)
	end
end

ActionButton_OnUpdate = caelButtons_OnUpdate

local caelButtons_Hotkey = function(button)
	local hotkey = _G[format("%sHotKey", button:GetName())]

	if hotkey and hideHotkeys and hotkey:IsShown() then
		hotkey:Hide()
	end
end

--[[
--	Skin extra action button, needs testing
local function styleExtraActionButton(button)
	button.style:SetTexture(nil)

	hooksecurefunc(button.style, "SetTexture", function(self, texture)
		if texture then
			self:SetTexture(nil)
		end
	end)
end
--]]

caelUI.buttons:RegisterEvent("PLAYER_LOGIN")
caelUI.buttons:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_LOGIN")

    for i = 1, NUM_ACTIONBAR_BUTTONS do
		StyleButton(_G[format("ActionButton%d", i)])
		StyleButton(_G[format("MultiBarBottomLeftButton%d", i)])
		StyleButton(_G[format("MultiBarBottomRightButton%d", i)])
		StyleButton(_G[format("MultiBarRightButton%d", i)])
		StyleButton(_G[format("MultiBarLeftButton%d", i)])

--		StyleButton(_G[format("VehicleMenuBarActionButton"..i])
--		StyleButton(_G[format("BonusActionButton"..i])
    end

	for i = 1, NUM_PET_ACTION_SLOTS do
		StyleButton(_G[format("PetActionButton%d", i)])
	end

	for i = 1, NUM_STANCE_SLOTS do
		StyleButton(_G[format("StanceButton%d", i)])
	end

	for i = 1, ExtraActionBarFrame:GetNumChildren() do
		StyleButton(_G[format("ExtraActionButton%d", i)])
	end

--	for i = 1, 6 do
--		StyleButton(OverrideActionBar[format("SpellButton%d", i)])
--	end

--	for i = 1, NUM_POSSESS_SLOTS do
--		StyleButton(_G[format("PossessButton%d", i)])
--	end

	local FlyoutButtons = function()
		local NUM_FLYOUT_BUTTONS = 10
		for i = 1, NUM_FLYOUT_BUTTONS do
			StyleButton(_G[format("SpellFlyoutButton%d", i)])
		end
	end

	SpellFlyout:HookScript("OnShow", FlyoutButtons)
end)

if hideHotkeys then
	hooksecurefunc("ActionButton_UpdateHotkeys", caelButtons_Hotkey)
end

--[[	Enable glowing overlays on macros.	]]

local overlayedSpells = {}

hooksecurefunc("ActionButton_HideOverlayGlow", function(button)
	if button.action then
		local actionType, id = GetActionInfo(button.action)

		if actionType == "macro" and overlayedSpells[GetMacroSpell(id) or false] then
			return ActionButton_ShowOverlayGlow(button)
		end
	end
end)

hooksecurefunc("ActionButton_OnEvent",  function(button, event, spellId)
	if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" or event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		local spellName = GetSpellInfo(spellId)
		local actionType, id = GetActionInfo(button.action)
		local glowVisible = event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"

		overlayedSpells[spellName] = glowVisible

		if actionType == "macro" and GetMacroSpell(id) == spellName then
			if glowVisible then
				return ActionButton_ShowOverlayGlow(button)
			else
				return ActionButton_HideOverlayGlow(button)
			end
		end
	end
end)