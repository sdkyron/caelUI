--[[	$Id: oUF_cFunctions.lua 3708 2013-11-10 17:01:54Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

local floor, format = math.floor, string.format

local pixelScale, playerClass, playerSpec = caelUI.scale, caelUI.playerClass, GetSpecialization()

local execThreshold = {
	["HUNTER"] = 20,
	["PALADIN"] = 20,
	["PRIEST"] = 20,
	["ROGUE"] = { [1] = 35},
	["WARLOCK"] = { [3] = 20},
	["WARRIOR"] = 20
}

local SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(0.75, -0.75)
	return fs
end

oUF_Caellian.SetFontString = SetFontString

local ShortValue = function(value)
	if value >= 1e9 then
		return ("%.1fb"):format(value / 1e9):gsub("%.?0+([kmb])$", "%1")
	elseif value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([kmb])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([kmb])$", "%1")
	else
		return value
	end
end

oUF_Caellian.ShortValue = ShortValue

local PostUpdateHealth = function(health, unit, min, max)

	if UnitIsTapped(unit) and not (UnitIsTappedByPlayer(unit) or UnitIsTappedByAllThreatList(unit)) then
		health:SetStatusBarColor(unpack(oUF.colors.tapped))
	elseif not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		local class = select(2, UnitClass(unit))
		local color = UnitIsPlayer(unit) and oUF.colors.class[class] or {0.84, 0.75, 0.65}

		health:SetValue(0)
		health.bg:SetVertexColor(color[1] * 0.5, color[2] * 0.5, color[3] * 0.5)

		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5".."Offline".."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5".."Dead".."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5".."Ghost".."|r")
		end
	else
		local r, g, b
		r, g, b = oUF.ColorGradient(min, max, 0.69, 0.31, 0.31, 0.71, 0.43, 0.27, 0.17, 0.17, 0.24)

		health:SetStatusBarColor(r, g, b)
		health.bg:SetVertexColor(0.15, 0.15, 0.15)

		if min ~= max then
			r, g, b = oUF.ColorGradient(min, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
			elseif unit == "target" then
				health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
			elseif health:GetParent():GetName():match("oUF_Caellian_Party") or health:GetParent():GetName():match("oUF_Caellian_Raid") then
				health.value:SetFormattedText("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, ShortValue(floor(min - max)))
			else
				health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
			end
		else
			if unit ~= "player" and unit ~= "pet" then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
			else
				health.value:SetText("|cff559655"..max.."|r")
			end
		end
	end
end

oUF_Caellian.PostUpdateHealth = PostUpdateHealth

local PostUpdateName = function(self, power)
	self.Info:ClearAllPoints()
	if power.value:GetText() then
		self.Info:SetPoint("TOP", 0, pixelScale(-3.5))
	else
		self.Info:SetPoint("TOPLEFT", pixelScale(3.5), pixelScale(-3.5))
	end
end

oUF_Caellian.PostUpdateName = PostUpdateName

local PreUpdatePower = function(power, unit)
	local _, pType = UnitPowerType(unit)
	
	local color = oUF_Caellian.colors.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

oUF_Caellian.PreUpdatePower = PreUpdatePower

local PostUpdatePower = function(power, unit, min, max)

	local self = power:GetParent()

	local pType, pToken = UnitPowerType(unit)
	local color = oUF_Caellian.colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) or max == 0 then
		local class = select(2, UnitClass(unit))
		local color = UnitIsPlayer(unit) and oUF.colors.class[class] or {0.84, 0.75, 0.65}

		power:SetValue(0)
		power.bg:SetVertexColor(color[1] * 0.5, color[2] * 0.5, color[3] * 0.5)
	end

	if unit ~= "player" and unit ~= "pet" and unit ~= "target" and not (unit and unit:match("boss%d")) then return end

	if min == 0 then
		power.value:SetText()
	elseif not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	elseif min == max and (pType == 2 or pType == 3 and pToken ~= "POWER_TYPE_PYRITE") then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), ShortValue(max - (max - min)))
				elseif unit == "player" and power:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					power.value:SetFormattedText("%d%%", floor(min / max * 100))
				else
					power.value:SetFormattedText("%d%% |cffD7BEA5-|r %d", floor(min / max * 100), max - (max - min))
				end
			else
				power.value:SetText(max - (max - min))
			end
		else
			if unit == "pet" or unit == "target" then
				power.value:SetText(ShortValue(min))
			else
				power.value:SetText(min)
			end
		end
	end
	if self.Info then
		if unit == "pet" or unit == "target" or (unit and unit:match("boss%d")) then PostUpdateName(self, power) end
	end
end

oUF_Caellian.PostUpdatePower = PostUpdatePower

local execDelay = 0
local UpdateExecLevel = function(self, elapsed)
	execDelay = execDelay + elapsed
	if self.parent.unit ~= "target" or execDelay < 0.2 then return end

	execDelay = 0

	local percExec = UnitHealth("target") / UnitHealthMax("target") * 100

	local threshold = nil

	if (playerClass == "ROGUE" or playerClass == "WARLOCK") and execThreshold[playerClass][playerSpec] then
		threshold = execThreshold[playerClass][playerSpec]
	elseif execThreshold[playerClass] then
		threshold = execThreshold[playerClass]
	end
	
	if threshold and type(threshold) ~= "table" then
		if percExec < threshold and not UnitIsDeadOrGhost("target") then
			self.WarningMsg:SetText("|cffaf5050FINISH IT|r")
			caelUI.flash(self, 0.3)
		else
			self.WarningMsg:SetText()
			caelUI.stopflash(self)
		end
	end
end

oUF_Caellian.UpdateExecLevel = UpdateExecLevel

local manaDelay = 0
local UpdateManaLevel = function(self, elapsed)
	manaDelay = manaDelay + elapsed

	if self.parent.unit ~= "player" or manaDelay < 0.2 or UnitPowerType("player") ~= 0 then return end

	manaDelay = 0

	local percMana = UnitMana("player") / UnitManaMax("player") * 100

	if percMana ~= 0 and percMana <= oUF_Caellian.config.manaThreshold and not UnitIsDeadOrGhost("player") then
		self.WarningMsg:SetText("|cffaf5050LOW MANA|r")
		caelUI.flash(self, 0.3)
	else
		self.WarningMsg:SetText()
		caelUI.stopflash(self)
	end
end

oUF_Caellian.UpdateManaLevel = UpdateManaLevel

local UpdateDruidManaText = function(self)
	if self.unit ~= "player" then return end

	local num, str = UnitPowerType("player")
	if num ~= 0 then
		local min, max = UnitPower("player", 0), UnitPowerMax("player", 0)

		local percMana = min / max * 100
		if percMana <= oUF_Caellian.config.manaThreshold then
			self.FlashInfo.WarningMsg:SetText("|cffaf5050LOW MANA|r")
			caelUI.flash(self.FlashInfo, 0.3)
		else
			self.FlashInfo.WarningMsg:SetText()
			caelUI.stopflash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.DruidManaText:SetPoint("TOPLEFT", self.Power.value, "TOPRIGHT", pixelScale(1), 0)
				self.DruidManaText:SetFormattedText("|cffD7BEA5-|r %d%%|r", floor(min / max * 100))
			else
				self.DruidManaText:SetPoint("TOPLEFT", pixelScale(3.5), pixelScale(-3.5))
				self.DruidManaText:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.DruidManaText:SetText()
		end

		self.DruidManaText:SetAlpha(1)
	else
		self.DruidManaText:SetAlpha(0)
	end
end

oUF_Caellian.UpdateDruidManaText = UpdateDruidManaText

local UpdateComboPoints = function(self, event, unit)
	if unit == "pet" then return end

	local ComboPoints

	if UnitHasVehicleUI("player") then
		ComboPoints = GetComboPoints("vehicle", "target")
	else
		ComboPoints = GetComboPoints("player", "target")
	end

	for i = 1, MAX_COMBO_POINTS do
		if i <= ComboPoints then
			self.CPoints[i]:SetAlpha(1)
		else
			self.CPoints[i]:SetAlpha(0)
		end
	end

	if self.CPoints[1]:GetAlpha() == 1 then
		for i = 1, MAX_COMBO_POINTS do
			self.CPoints:Show()
		end
	else
		for i = 1, MAX_COMBO_POINTS do
			self.CPoints:Hide()
		end
	end
end

oUF_Caellian.UpdateComboPoints = UpdateComboPoints

local UpdateHolyPower = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER") then return end

	local num = UnitPower("player", SPELL_POWER_HOLY_POWER)
	local numMax = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
	for i = 1, numMax do
		if i <= num then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(0)
		end
	end
end

oUF_Caellian.UpdateHolyPower = UpdateHolyPower

local UpdateShadowOrbs = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= "SHADOW_ORBS") then return end

	local num = UnitPower("player", SPELL_POWER_SHADOW_ORBS)
	local numMax = PRIEST_BAR_NUM_ORBS -- UnitPowerMax("player", SPELL_POWER_SHADOW_ORBS)
	for i = 1, numMax do
		if i <= num then
			self.ShadowOrbs[i]:SetAlpha(1)
		else
			self.ShadowOrbs[i]:SetAlpha(0)
		end
	end
end

oUF_Caellian.UpdateShadowOrbs = UpdateShadowOrbs

local UpdateChi = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= "CHI") then return end

	local num = UnitPower("player", SPELL_POWER_CHI)
	local numMax = UnitPowerMax("player", SPELL_POWER_CHI)
	for i = 1, numMax do
		if i <= num then
			self.Harmony[i]:SetAlpha(1)
		else
			self.Harmony[i]:SetAlpha(0)
		end
	end
end

oUF_Caellian.UpdateChi = UpdateChi

local PostCastStart = function(castbar, unit, name, rank, castid)
	castbar.channeling = false
	if unit == "vehicle" then unit = "player" end

	if unit == "player" then
		local _, _, _, lag = GetNetStats()
		local latency = GetTime() - (castbar.castSent or 0)
		lag = lag / 1e3 > castbar.max and castbar.max or lag / 1e3
		latency = latency > castbar.max and lag or latency

		if latency and latency > 0 then
			if castbar.Latency then
				castbar.Latency:SetText(("%d ms"):format(latency * 1e3))
			end

			if castbar.SafeZone then
				castbar.SafeZone:SetWidth(pixelScale(castbar:GetWidth() * latency / castbar.max))
				castbar.SafeZone:ClearAllPoints()
				castbar.SafeZone:SetPoint("TOPRIGHT")
				castbar.SafeZone:SetPoint("BOTTOMRIGHT")
			end
		end
	end

	if castbar.interrupt and UnitCanAttack("player", unit) then
		castbar:SetStatusBarColor(0.69, 0.31, 0.31)
	elseif unit == "player" then
		castbar:SetStatusBarColor(unpack(oUF_Caellian.colors.class[playerClass]))
	else
		castbar:SetStatusBarColor(0.55, 0.57, 0.61)
	end
end

oUF_Caellian.PostCastStart = PostCastStart

local PostChannelStart = function(castbar, unit, name)
	castbar.channeling = true
	if unit == "vehicle" then unit = "player" end

	if unit == "player" then
		local _, _, _, lag = GetNetStats()
		local latency = GetTime() - (castbar.castSent or 0)
		lag = lag / 1e3 > castbar.max and castbar.max or lag / 1e3
		latency = latency > castbar.max and lag or latency

		if latency and latency > 0 then
			if castbar.Latency then
				castbar.Latency:SetText(("%d ms"):format(latency * 1e3))
			end

			if castbar.SafeZone then
				castbar.SafeZone:SetWidth(pixelScale(castbar:GetWidth() * latency / castbar.max))
				castbar.SafeZone:ClearAllPoints()
				castbar.SafeZone:SetPoint("TOPLEFT")
				castbar.SafeZone:SetPoint("BOTTOMLEFT")
			end
		end
	end

	if castbar.interrupt and UnitCanAttack("player", unit) then
		castbar:SetStatusBarColor(0.69, 0.31, 0.31)
	elseif unit == "player" then
		castbar:SetStatusBarColor(unpack(oUF_Caellian.colors.class[playerClass]))
	else
		castbar:SetStatusBarColor(0.55, 0.57, 0.61)
	end
end

oUF_Caellian.PostChannelStart = PostChannelStart

local CustomCastTimeText = function(self, duration)
	self.Time:SetText(("%.1f / %.2f"):format(self.channeling and duration or self.max - duration, self.max))
end

local CustomCastDelayText = function(self, duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
end

oUF_Caellian.CustomCastDelayText = CustomCastDelayText

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		if s <= minute * 5 then
			return format("%d:%02d", floor(s/60), s % minute), s - floor(s)
		end
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

oUF_Caellian.FormatTime = FormatTime

local CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
					self.remaining:SetText(time)
				if self.timeLeft < 5 then
					self.remaining:SetTextColor(0.69, 0.31, 0.31)
				else
					self.remaining:SetTextColor(0.84, 0.75, 0.65)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

oUF_Caellian.CreateAuraTimer = CreateAuraTimer

local HideAura = function(self)
	if self.unit == "player" then
		if oUF_Caellian.config.noPlayerAuras then
			self.Buffs:Hide()
--			self.Debuffs:Hide()
		else
			local BuffFrame = _G["BuffFrame"]
			BuffFrame:UnregisterEvent("UNIT_AURA")
			BuffFrame:Hide()
--			BuffFrame = _G["TemporaryEnchantFrame"]
--			BuffFrame:Hide()
		end
	elseif self.unit == "pet" and oUF_Caellian.config.noPetAuras or self.unit == "targettarget" and oUF_Caellian.config.noToTAuras then
		self.Auras:Hide()
	elseif self.unit == "target" and oUF_Caellian.config.noTargetAuras then
		self.Buffs:Hide()
		self.Debuffs:Hide()
	end
end

oUF_Caellian.HideAura = HideAura

local PostCreateAura = function(auras, button)
	auras.createdIcons = auras.createdIcons + 1 -- need to do this

	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.backdrop = CreateFrame("Frame", nil, button)
	button.backdrop:SetPoint("TOPLEFT", pixelScale(-4), pixelScale(4))
	button.backdrop:SetPoint("BOTTOMRIGHT", pixelScale(4), pixelScale(-4))
	button.backdrop:SetBackdrop({
		bgFile = nil,
		edgeFile = caelMedia.files.edgeFile,
		edgeSize = caelUI.scale(2),
		insets = caelMedia.insetTable,
	})
	button.backdrop:SetBackdropBorderColor(0, 0, 0, 0.85)

	button.gloss = CreateFrame("Frame", nil, button)
	button.gloss:SetPoint("TOPLEFT", pixelScale(-3), pixelScale(3))
	button.gloss:SetPoint("BOTTOMRIGHT", pixelScale(3), pixelScale(-3))
	button.gloss:SetBackdrop({
		bgFile = caelMedia.files.buttonGloss,
		insets = {top = pixelScale(-1), left = pixelScale(-1), bottom = pixelScale(-1), right = pixelScale(-1)},
	})
	button.gloss:SetBackdropColor(0.25, 0.25, 0.25, 0.5)

	button.count:SetPoint("BOTTOMRIGHT", pixelScale(1), pixelScale(1.5))
	button.count:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 8, "OUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	button.count:SetJustifyH("RIGHT")

	button.cd.noOCC = true
	button.cd.noCooldownCount = true
	auras.disableCooldown = true

	button.overlay:SetTexture(caelMedia.files.buttonNormal)
	button.overlay:SetPoint("TOPLEFT", pixelScale(-3.5), pixelScale(3.5))
	button.overlay:SetPoint("BOTTOMRIGHT", pixelScale(3.5), pixelScale(-3.5))
	button.overlay:SetTexCoord(0, 1, 0, 1)
	button.overlay.Hide = function(self) end

	button.remaining = SetFontString(button.backdrop, caelMedia.fonts.CUSTOM_NUMBERFONT, 8, "OUTLINE")
	button.remaining:SetPoint("TOP", 0, pixelScale(-2))
end

oUF_Caellian.PostCreateAura = PostCreateAura
--[[
local CreateEnchantTimer = function(self, icons)
	for i = 1, 3 do
		local icon = icons[i]
		if icon.expTime then
			icon.timeLeft = icon.expTime - GetTime()
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

oUF_Caellian.CreateEnchantTimer = CreateEnchantTimer
--]]
local PostUpdateIcon

do
	local playerUnits = {
		player = true,
		pet = true,
		vehicle = true,
	}

	PostUpdateIcon = function(icons, unit, icon, index, offset)
		local _, _, _, _, _, duration, expirationTime, unitCaster = UnitAura(unit, index, icon.filter)
		if playerUnits[unitCaster] then
			if icon.isDebuff then
				icon.overlay:SetVertexColor(0.69, 0.31, 0.31)
				icon.gloss:SetBackdropColor(0.69, 0.31, 0.31, 0.5)
			else
				icon.overlay:SetVertexColor(0.33, 0.59, 0.33)
				icon.gloss:SetBackdropColor(0.33, 0.59, 0.33, 0.5)
			end
		else
			if UnitIsEnemy("player", unit) then
				if icon.isDebuff then
					icon.icon:SetDesaturated(true)
				end
			end
			icon.overlay:SetVertexColor(0.5, 0.5, 0.5)
			icon.gloss:SetBackdropColor(0.25, 0.25, 0.25, 0.5)
		end

		if duration and duration > 0 then
			icon.remaining:Show()
			icon.timeLeft = expirationTime
			icon:SetScript("OnUpdate", CreateAuraTimer)
		else
			icon.remaining:Hide()
			icon.timeLeft = math.huge
			icon:SetScript("OnUpdate", nil)
		end

		icon:SetScript("OnMouseUp", function(self, button)
			if not InCombatLockdown() and button == "RightButton" then
				CancelUnitBuff("player", index, "HELPFUL")
			end
		end)

		icon.first = true
	end
end

oUF_Caellian.PostUpdateIcon = PostUpdateIcon

local CustomFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, expiration, caster)

--	if not UnitPlayerControlled(caster) and not UnitIsPlayer(caster) then
--		return true
--	end

	local playerUnits = {
		player = true,
		pet = true,
		vehicle = true,
	}

	if UnitCanAttack("player", unit) then
		local casterClass

		if caster then
			casterClass = select(2, UnitClass(caster))
		end

--		if not icon.isDebuff or (casterClass and casterClass == playerClass) then
		if (icon.isDebuff and playerUnits[icon.owner]) or (not icon.isDebuff and icon.owner == unit) then
			return true
		end
	else
		local isPlayer

		if caster == "player" or caster == "pet" or caster == "vehicle" then
			isPlayer = true
		end

		if((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
			icon.isPlayer = isPlayer
			icon.owner = caster
			return true
		end
	end

	return false
end

oUF_Caellian.CustomFilter = CustomFilter

local SortAuras = function(a, b)
	if (a and b and a.timeLeft and b.timeLeft) then
		if(a:IsShown() and b:IsShown()) then
			return a.timeLeft > b.timeLeft
		elseif(a:IsShown()) then
			return true
		end
	end
end

oUF_Caellian.SortAuras = SortAuras

local PreSetPosition = function(auras)
	table.sort(auras, SortAuras)
	return 1, auras.createdIcons
end

oUF_Caellian.PreSetPosition = PreSetPosition

local SetFocus = function(self) 
	local ModKey = "Shift"
    local MouseButton = 1
    local key = ModKey .. "-type" .. (MouseButton or "")
	if not InCombatLockdown() then
		if self.unit == "focus" then
			self:SetAttribute(key, "macro")
			self:SetAttribute("macrotext", "/clearfocus")
		else
			self:SetAttribute(key, "focus")
		end
	end
end

oUF_Caellian.SetFocus = SetFocus