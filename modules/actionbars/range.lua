--[[	$Id:$	]]

local _, caelUI = ...

-- Locals and speed
local _G = _G
local UPDATE_DELAY = 0.15
local ATTACK_BUTTON_FLASH_TIME = ATTACK_BUTTON_FLASH_TIME
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local ActionButton_GetPagedID = ActionButton_GetPagedID
local ActionButton_IsFlashing = ActionButton_IsFlashing
local ActionHasRange = ActionHasRange
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction
local HasAction = HasAction

local function timer_Create(parent, interval)
	local updater = parent:CreateAnimationGroup()
	updater:SetLooping("NONE")
	updater:SetScript("OnFinished", function(self)
		if parent:Update() then
			parent:Start(interval)
		end
	end)

	local a = updater:CreateAnimation("Animation"); a:SetOrder(1)

	parent.Start = function(self)
		self:Stop()
		a:SetDuration(interval)
		updater:Play()
		return self
	end

	parent.Stop = function(self)
		if updater:IsPlaying() then
			updater:Stop()
		end
		return self
	end

	parent.Active = function(self)
		return updater:IsPlaying()
	end

	return parent
end

-- Holy Power detection
local DIVINE_PURPOSE = GetSpellInfo(90174)
local isHolyPowerAbility
do
	local HOLY_POWER_SPELLS = {
		[85673] = GetSpellInfo(85673),	-- Word of Glory
		[114163] = GetSpellInfo(114163),	-- Eternal Flame
	}

	isHolyPowerAbility = function(actionId)
		local actionType, id = GetActionInfo(actionId)
		if actionType == "macro" then
			local macroSpell = GetMacroSpell(id)
			if macroSpell then
				for spellId, spellName in pairs(HOLY_POWER_SPELLS) do
					if macroSpell == spellName then
						return true
					end
				end
			end
		else
			return HOLY_POWER_SPELLS[id]
		end
		return false
	end
end

-- Main thing
local caelRange = timer_Create(CreateFrame("Frame", "caelRange"), UPDATE_DELAY)

function caelRange:Load()
	self:SetScript("OnEvent", self.OnEvent)
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
end

-- Frame Events
function caelRange:OnEvent(event, ...)
	local action = self[event]
	if action then
		action(self, event, ...)
	end
end

-- Game Events
function caelRange:PLAYER_LOGIN()
	if not caelRange_COLORS then
		self:LoadDefaults()
	end
	self.colors = caelRange_COLORS

	self.buttonsToUpdate = {}

	hooksecurefunc("ActionButton_OnUpdate", self.RegisterButton)
	hooksecurefunc("ActionButton_UpdateUsable", self.OnUpdateButtonUsable)
	hooksecurefunc("ActionButton_Update", self.OnButtonUpdate)
end

-- Actions
function caelRange:Update()
	return self:UpdateButtons(UPDATE_DELAY)
end

function caelRange:ForceColorUpdate()
	for button in pairs(self.buttonsToUpdate) do
		caelRange.OnUpdateButtonUsable(button)
	end
end

function caelRange:UpdateActive()
	if next(self.buttonsToUpdate) then
		if not self:Active() then
			self:Start()
		end
	else
		self:Stop()
	end
end

function caelRange:UpdateButtons(elapsed)
	if next(self.buttonsToUpdate) then
		for button in pairs(self.buttonsToUpdate) do
			self:UpdateButton(button, elapsed)
		end
		return true
	end
	return false
end

function caelRange:UpdateButton(button, elapsed)
	caelRange.UpdateButtonUsable(button)
	caelRange.UpdateFlash(button, elapsed)
end

function caelRange:UpdateButtonStatus(button)
	local action = ActionButton_GetPagedID(button)
	if button:IsVisible() and action and HasAction(action) and ActionHasRange(action) then
		self.buttonsToUpdate[button] = true
	else
		self.buttonsToUpdate[button] = nil
	end
	self:UpdateActive()
end

-- Button Hooking
function caelRange.RegisterButton(button)
	button:HookScript("OnShow", caelRange.OnButtonShow)
	button:HookScript("OnHide", caelRange.OnButtonHide)
	button:SetScript("OnUpdate", nil)

	caelRange:UpdateButtonStatus(button)
end

function caelRange.OnButtonShow(button)
	caelRange:UpdateButtonStatus(button)
end

function caelRange.OnButtonHide(button)
	caelRange:UpdateButtonStatus(button)
end

function caelRange.OnUpdateButtonUsable(button)
	button.caelRangeColor = nil
	caelRange.UpdateButtonUsable(button)
end

function caelRange.OnButtonUpdate(button)
	caelRange:UpdateButtonStatus(button)
end

-- Range Coloring
function caelRange.UpdateButtonUsable(button)
	local name = button:GetName()
	local action = ActionButton_GetPagedID(button)
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

	local isUsable, notEnoughMana = IsUsableAction(action)

	-- Usable
	if isUsable then
		-- Out of range
		if IsActionInRange(action) == false then
			caelRange.SetButtonColor(button, "oor")
		-- Holy Power
		elseif caelUI.playerClass == "PALADIN" and isHolyPowerAbility(action) and not (UnitPower("player", SPELL_POWER_HOLY_POWER) >= 3 or UnitBuff("player", DIVINE_PURPOSE)) then
			caelRange.SetButtonColor(button, "ooh")
		-- In range
		else
			caelRange.SetButtonColor(button, "normal")
		end
	-- Out of mana
	elseif notEnoughMana then
		caelRange.SetButtonColor(button, "oom")
	-- Unusable
	else
		caelRange.SetButtonColor(button, "unusuable")
	end
end

function caelRange.SetButtonColor(button, colorType)
	if button.caelRangeColor ~= colorType then
		button.caelRangeColor = colorType

		local r, g, b = caelRange:GetColor(colorType)
		local icon = _G[button:GetName().."Icon"]
		icon:SetVertexColor(r, g, b)
	end
end

function caelRange.UpdateFlash(button, elapsed)
	if ActionButton_IsFlashing(button) then
		local flashtime = button.flashtime - elapsed

		if flashtime <= 0 then
			local overtime = -flashtime
			if overtime >= ATTACK_BUTTON_FLASH_TIME then
				overtime = 0
			end
			flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

			local flashTexture = _G[button:GetName().."Flash"]
			if flashTexture:IsShown() then
				flashTexture:Hide()
			else
				flashTexture:Show()
			end
		end

		button.flashtime = flashtime
	end
end

-- Configuration
function caelRange:LoadDefaults()
	caelRange_COLORS = {
		normal = {1, 1, 1},
		oor = {0.69, 0.31, 0.31},
		oom = {0.31, 0.45, 0.63},
		ooh = {0.45, 0.45, 1},
		unusuable = {0.1, 0.1, 0.1}
	}
end

function caelRange:GetColor(index)
	local color = self.colors[index]
	return color[1], color[2], color[3]
end

-- Load The Thing
caelRange:Load()