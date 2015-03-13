--[[	$Id: oUF_cLayout.lua 3969 2014-12-02 08:32:21Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

oUF_Caellian.cmain = oUF_Caellian.createModule("cMain")

local mediaPath = [[Interface\Addons\caelUI\media\miscellaneous\]]

local format = string.format

local pixelScale, playerClass, playerSpec = caelUI.scale, caelUI.playerClass, GetSpecialization()

local auraSize = pixelScale(((230 - (9 * 6)) / 10))

local backdrop = {
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
	insets = {top = pixelScale(-1), left = pixelScale(-1), bottom = pixelScale(-1), right = pixelScale(-1)},
}

local SetStyle = function(self, unit)

	local unitInRaid = self:GetParent():GetName():match("oUF_Caellian_Raid")
	local unitInParty = self:GetParent():GetName():match("oUF_Caellian_Party") -- unit and unit:match("party%d")
	local unitIsPartyPet = self:GetAttribute("unitsuffix") == "pet" -- unit and unit:match("partypet%d")
	local unitIsPartyTarget = self:GetAttribute("unitsuffix") == "target" -- unit and unit:match("party%dtarget")

	self.colors = oUF_Caellian.colors
	self:RegisterForClicks("AnyUp")

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self.FrameBackdrop = CreateFrame("Frame", nil, self)
	self.FrameBackdrop:SetFrameLevel(self:GetFrameLevel() - 1)
	self.FrameBackdrop:SetPoint("TOPLEFT", self, pixelScale(-3), pixelScale(3))
	self.FrameBackdrop:SetFrameStrata("MEDIUM")
	self.FrameBackdrop:SetBackdrop(caelMedia.backdropTable)
	self.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
	self.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)

	if unit == "player" and (playerClass == "DEATHKNIGHT" or (playerClass == "WARLOCK" and UnitLevel("player") >= 10 and playerSpec) or (playerClass == "DRUID" and playerSpec == 1) or playerClass == "SHAMAN") then
		self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self, pixelScale(3), pixelScale(-12))
	else
		self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self, pixelScale(3), pixelScale(-3))
	end

	self.Health = CreateFrame("StatusBar", self:GetName().."_Health", self)
	self.Health:SetHeight((unit == "player" or unit == "target") and pixelScale(30) or unitInRaid and pixelScale(22) or unitIsPartyPet and pixelScale(10) or pixelScale(16))
	self.Health:SetPoint("TOPLEFT", pixelScale(1), pixelScale(-1))
	self.Health:SetPoint("TOPRIGHT", pixelScale(-1), pixelScale(-1))
	self.Health:SetStatusBarTexture(caelMedia.files.statusBarCb)
	self.Health:SetBackdrop(backdrop)
	self.Health:SetBackdropColor(0, 0, 0)

	self.Health.frequentUpdates = true
	self.Health.Smooth = true

	self.Health.PostUpdate = oUF_Caellian.PostUpdateHealth

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetTexture(caelMedia.files.statusBarCb)

	self.Health.value = oUF_Caellian.SetFontString(self.Health, oUF_Caellian.config.font,(unit == "player" or unit == "target") and 10 or 9)
	if unitInRaid then
		self.Health.value:SetPoint("BOTTOMRIGHT", pixelScale(-1), pixelScale(2))
	elseif unitIsPartyPet then
		self.Health.value:SetPoint("RIGHT", pixelScale(-1), pixelScale(1))
	else
		self.Health.value:SetPoint("TOPRIGHT", pixelScale(-3.5), pixelScale(-3.5))
	end

	if not unitIsPartyPet then
		self.Power = CreateFrame("StatusBar", self:GetName().."_Power", self)
		self.Power:SetHeight((unit == "player" or unit == "target") and pixelScale(15) or pixelScale(5))
		if unitInRaid then
			self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, pixelScale(-1))
			self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, pixelScale(-1))
		else
			self.Power:SetPoint("BOTTOMLEFT", pixelScale(1), pixelScale(1))
			self.Power:SetPoint("BOTTOMRIGHT", pixelScale(-1), pixelScale(1))
		end
		self.Power:SetStatusBarTexture(caelMedia.files.statusBarC)
		self.Power:SetBackdrop(backdrop)
		self.Power:SetBackdropColor(0, 0, 0)

		self.Power.colorPower = unit == "player" or unit == "pet" and true
		self.Power.colorClass = true
		self.Power.colorReaction = true

		self.Power.frequentUpdates = true
		self.Power.Smooth = true

		self.Power.PreUpdate = oUF_Caellian.PreUpdatePower
		self.Power.PostUpdate = oUF_Caellian.PostUpdatePower

		self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
		self.Power.bg:SetAllPoints()
		self.Power.bg:SetTexture(caelMedia.files.statusBarC)
		self.Power.bg.multiplier = 0.5

		self.Power.value = oUF_Caellian.SetFontString(self.Health, oUF_Caellian.config.font, (unit == "player" or unit == "target") and 10 or 9)
		self.Power.value:SetPoint("TOPLEFT", pixelScale(3.5), pixelScale(-3.5))
	end

	if unitInRaid then
		self.Nameplate = CreateFrame("Frame", nil, self.FrameBackdrop)
		self.Nameplate:SetFrameLevel(self:GetFrameLevel() + 1)
		self.Nameplate:SetPoint("TOPLEFT", self, 0, pixelScale(-28))
		self.Nameplate:SetPoint("BOTTOMRIGHT", self)
		self.Nameplate:SetBackdrop {
			bgFile = caelMedia.files.bgFile,
			edgeFile = caelMedia.files.bgFile,
			tile = false, tileSize = 0, edgeSize = pixelScale(1),
			insets = {left = 0, right = 0, top = 1, bottom = 0}
		}
		self.Nameplate:SetBackdropColor(0.15, 0.15, 0.15)
		self.Nameplate:SetBackdropBorderColor(0, 0, 0)
	end

	if unit ~= "player" then
		self.Info = oUF_Caellian.SetFontString(unitInRaid and self.Nameplate or self.Health, oUF_Caellian.config.font, unit == "target" and 10 or 9)
		if unitInRaid then
			self.Info:SetPoint("BOTTOM", self, 0, pixelScale(2))
			self:Tag(self.Info, "[caellian:getnamecolor][caellian:nameshort]")
		elseif unit == "target" then
			self.Info:SetPoint("TOPLEFT", pixelScale(3.5), pixelScale(-3.5))
			self:Tag(self.Info, "[caellian:getnamecolor][caellian:namelong] [caellian:diffcolor][level] [shortclassification]")
		elseif unit == "pet" then
			self.Info:SetPoint("LEFT", pixelScale(1), pixelScale(1))
			self:Tag(self.Info, "[caellian:getnamecolor][caellian:nameshort]")
		else
			self.Info:SetPoint("LEFT", pixelScale(1), pixelScale(1))
			self:Tag(self.Info, "[caellian:getnamecolor][caellian:namemedium]")
		end
	end

	if unit == "player" then
		self.Combat = self.Health:CreateTexture(nil, "OVERLAY")
		self.Combat:SetSize(pixelScale(12), pixelScale(12))
		self.Combat:SetPoint("TOP", 0, pixelScale(-3.5))
		self.Combat:SetTexture(mediaPath.."bubbletex")
		self.Combat:SetVertexColor(0.69, 0.31, 0.31)

		if UnitLevel("player") ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
			self.Resting = self.Power:CreateTexture(nil, "OVERLAY")
			self.Resting:SetSize(pixelScale(18), pixelScale(18))
			self.Resting:SetPoint("BOTTOMLEFT", pixelScale(-8.5), pixelScale(-8.5))
			self.Resting:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
			self.Resting:SetTexCoord(0, 0.5, 0, 0.421875)
		end

		self.MyHealBar = CreateFrame("StatusBar", nil, self.Health)
		self.MyHealBar:SetWidth(pixelScale(230))
		self.MyHealBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
		self.MyHealBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
		self.MyHealBar:SetStatusBarTexture(caelMedia.files.statusBarCb)
		self.MyHealBar:SetStatusBarColor(0.33, 0.59, 0.33, 0.75)

		self.OtherHealBar = CreateFrame("StatusBar", nil, self.Health)
		self.OtherHealBar:SetWidth(pixelScale(230))
		self.OtherHealBar:SetPoint("TOPLEFT", self.MyHealBar:GetStatusBarTexture(), "TOPRIGHT")
		self.OtherHealBar:SetPoint("BOTTOMLEFT", self.MyHealBar:GetStatusBarTexture(), "BOTTOMRIGHT")
		self.OtherHealBar:SetStatusBarTexture(caelMedia.files.statusBarCb)
		self.OtherHealBar:SetStatusBarColor(0.33, 0.59, 0.33, 0.75)

		self.HealPrediction = {
			myBar = self.MyHealBar,
			otherBar = self.OtherHealBar,
			maxOverflow = 1,
		}

		if playerClass == "DEATHKNIGHT" then
			self.Runes = CreateFrame("Frame", nil, self)
			self.Runes:SetFrameLevel(self:GetFrameLevel() - 1)
			self.Runes:SetPoint("TOPLEFT", self, "BOTTOMLEFT", pixelScale(1), pixelScale(-1.5))
			self.Runes:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", pixelScale(-1), pixelScale(-1.5))
			self.Runes:SetHeight(pixelScale(7))
			self.Runes:SetBackdrop(backdrop)
			self.Runes:SetBackdropColor(0, 0, 0)

			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self.Runes)
				self.Runes[i]:SetSize(pixelScale(((230 - 5) / 6)), pixelScale(7))
				if i == 1 then
					self.Runes[i]:SetPoint("LEFT")
				else
					self.Runes[i]:SetPoint("LEFT", self.Runes[i-1], "RIGHT", pixelScale(1), 0)
				end
				self.Runes[i]:SetStatusBarTexture(caelMedia.files.statusBarC)
				self.Runes[i]:SetStatusBarColor(unpack(oUF_Caellian.colors.runeloadcolors[i]))

				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
				self.Runes[i].bg:SetAllPoints()
				self.Runes[i].bg:SetTexture(caelMedia.files.statusBarC)
				self.Runes[i].bg.multiplier = 0.5
			end
		end

		if playerClass == "SHAMAN" then
			self.TotemBar = {}
			self.TotemBar.Destroy = true
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
				self.TotemBar[i]:SetSize(pixelScale(((230 - 3) / 4)), pixelScale(7))
				if i == 1 then
					self.TotemBar[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", pixelScale(1), pixelScale(-1.5))
				else
					self.TotemBar[i]:SetPoint("LEFT", self.TotemBar[i-1], "RIGHT", pixelScale(1), 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(caelMedia.files.statusBarC)
				self.TotemBar[i]:SetMinMaxValues(0, 1)

				self.TotemBar[i]:SetBackdrop(backdrop)
				self.TotemBar[i]:SetBackdropColor(0, 0, 0)

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints()
				self.TotemBar[i].bg:SetTexture(caelMedia.files.statusBarC)
				self.TotemBar[i].bg.multiplier = 0.5
			end
		end

		if playerClass == "PALADIN" then
			self.HolyPower = CreateFrame("Frame", nil, self.Power)
			self.HolyPower:SetAllPoints()

			for i = 1, UnitPowerMax("player", SPELL_POWER_HOLY_POWER) do
				self.HolyPower[i] = self.HolyPower:CreateTexture(nil, "OVERLAY")
				self.HolyPower[i]:SetSize(pixelScale(12), pixelScale(12))
				self.HolyPower[i]:SetTexture(mediaPath.."bubbletex")
				self.HolyPower[i]:SetVertexColor(unpack(oUF_Caellian.colors.class[playerClass]))

				if i == 1 then
					self.HolyPower[i]:SetPoint("LEFT", pixelScale(3.5), pixelScale(-9))
				else
					self.HolyPower[i]:SetPoint("LEFT", self.HolyPower[i-1], "RIGHT", pixelScale(1))
				end
			end

			self.HolyPower.Override = oUF_Caellian.UpdateHolyPower
		end

		if playerClass == "WARLOCK" then
			self.WarlockSpecBars = CreateFrame("Frame", nil, self)
			self.WarlockSpecBars:SetFrameLevel(self:GetFrameLevel() - 1)
			self.WarlockSpecBars:SetPoint("TOPLEFT", self, "BOTTOMLEFT", pixelScale(1), pixelScale(-1.5))
			self.WarlockSpecBars:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", pixelScale(-1), pixelScale(-1.5))
			self.WarlockSpecBars:SetHeight(pixelScale(7))
			self.WarlockSpecBars:SetBackdrop(backdrop)
			self.WarlockSpecBars:SetBackdropColor(0, 0, 0)

			for i = 1, 4 do
				self.WarlockSpecBars[i] = CreateFrame("StatusBar", self:GetName().."_WarlockSpecBars"..i, self.WarlockSpecBars)
				self.WarlockSpecBars[i]:SetSize(pixelScale(((230 - 3) / 4)), pixelScale(7))

				if i == 1 then
					self.WarlockSpecBars[i]:SetPoint("LEFT")
				else
					self.WarlockSpecBars[i]:SetPoint("LEFT", self.WarlockSpecBars[i-1], "RIGHT", pixelScale(1), 0)
				end

				local r, g, b = unpack(oUF_Caellian.colors.class[playerClass])

				self.WarlockSpecBars[i]:SetStatusBarTexture(caelMedia.files.statusBarC)
				self.WarlockSpecBars[i]:SetStatusBarColor(r, g, b)

				self.WarlockSpecBars[i].bg = self.WarlockSpecBars[i]:CreateTexture(nil, "BORDER")
				self.WarlockSpecBars[i].bg:SetAllPoints()
				self.WarlockSpecBars[i].bg:SetTexture(caelMedia.files.statusBarC)
				self.WarlockSpecBars[i].bg:SetVertexColor(r * 0.5, g * 0.5, b * 0.5)
			end
		end

		if playerClass == "PRIEST" then
			self.ShadowOrbs = CreateFrame("Frame", nil, self.Power)
			self.ShadowOrbs:SetAllPoints()

			for i = 1, UnitPowerMax("player", SPELL_POWER_SHADOW_ORBS) do
				self.ShadowOrbs[i] = self.ShadowOrbs:CreateTexture(nil, "OVERLAY")
				self.ShadowOrbs[i]:SetSize(pixelScale(12), pixelScale(12))
				self.ShadowOrbs[i]:SetTexture(mediaPath.."bubbletex")
				self.ShadowOrbs[i]:SetVertexColor(unpack(oUF_Caellian.colors.class[playerClass]))

				if i == 1 then
					self.ShadowOrbs[i]:SetPoint("LEFT", pixelScale(3.5), pixelScale(-9))
				else
					self.ShadowOrbs[i]:SetPoint("LEFT", self.ShadowOrbs[i-1], "RIGHT", pixelScale(1))
				end
			end

			self.ShadowOrbs.Override = oUF_Caellian.UpdateShadowOrbs
		end

		if playerClass == "MONK" then
			self.Harmony = {}
			self.Harmony = CreateFrame("Frame", nil, self)

			for i = 1, UnitPowerMax("player", SPELL_POWER_CHI) do
				self.Harmony[i] = self.Power:CreateTexture(nil, "OVERLAY")
				self.Harmony[i]:SetSize(pixelScale(12), pixelScale(12))
				self.Harmony[i]:SetTexture(mediaPath.."bubbletex")

				if i == 1 then
					self.Harmony[i]:SetPoint("LEFT", pixelScale(3.5), pixelScale(-9))
				else
					self.Harmony[i]:SetPoint("LEFT", self.Harmony[i-1], "RIGHT", pixelScale(1))
				end

				self.Harmony[i]:SetVertexColor(unpack(oUF_Caellian.colors.class[playerClass]))
			end

			self.Harmony.Override = oUF_Caellian.UpdateChi
		end

		if playerClass == "DRUID" then
			self.DruidManaText = CreateFrame("Frame", nil, self)
			self.DruidManaText = oUF_Caellian.SetFontString(self.Health, oUF_Caellian.config.font, 10)
			self.DruidManaText:SetTextColor(unpack(oUF_Caellian.colors.class[playerClass]))
			self:RegisterEvent("UNIT_POWER_FREQUENT", oUF_Caellian.UpdateDruidManaText)
			
			self.EclipseBar = CreateFrame("Frame", nil, self)
			self.EclipseBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", pixelScale(1), pixelScale(-1.5))
			self.EclipseBar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", pixelScale(-1), pixelScale(-1.5))
			self.EclipseBar:SetHeight(pixelScale(7))
			self.EclipseBar:SetBackdrop(backdrop)
			self.EclipseBar:SetBackdropColor(0, 0, 0)

			self.EclipseBar.LunarBar = CreateFrame("StatusBar", nil, self.EclipseBar)
			self.EclipseBar.LunarBar:SetPoint("LEFT")
			self.EclipseBar.LunarBar:SetSize(pixelScale(228), pixelScale(7))
			self.EclipseBar.LunarBar:SetStatusBarTexture(caelMedia.files.statusBarC)
			self.EclipseBar.LunarBar:SetStatusBarColor(0.34, 0.1, 0.86)

			self.EclipseBar.SolarBar = CreateFrame("StatusBar", nil, self.EclipseBar)
			self.EclipseBar.SolarBar:SetPoint("LEFT", self.EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", pixelScale(1), 0)
			self.EclipseBar.SolarBar:SetSize(pixelScale(228), pixelScale(7))
			self.EclipseBar.SolarBar:SetStatusBarTexture(caelMedia.files.statusBarC)
			self.EclipseBar.SolarBar:SetStatusBarColor(0.95, 0.73, 0.15)
		end
	end

	if unit == "pet" or unit == "targettarget" then
		self.Auras = CreateFrame("Frame", nil, self)
		self.Auras.size = auraSize
		self.Auras:SetWidth(pixelScale((self.Auras.size * 8) + 42))
		self.Auras:SetHeight(self.Auras.size)
		self.Auras.spacing = 6
--		self.Auras.numBuffs = 4
--		self.Auras.numDebuffs = 4
		self.Auras.gap = false
		self.Auras.PostCreateIcon = oUF_Caellian.PostCreateAura
		self.Auras.PostUpdateIcon = oUF_Caellian.PostUpdateIcon
		if unit == "pet" then
			self.Auras:SetPoint("TOPRIGHT", self, "TOPLEFT", pixelScale(-9), pixelScale(-1))
			self.Auras.initialAnchor = "TOPRIGHT"
			self.Auras["growth-x"] = "LEFT"
		else
			self.Auras:SetPoint("TOPLEFT", self, "TOPRIGHT", pixelScale(9), pixelScale(-1))
			self.Auras.initialAnchor = "TOPLEFT"
		end
	end

	if unit == "player" or unit == "target" then
		self.Portrait = CreateFrame("PlayerModel", nil, self)
		self.Portrait:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", pixelScale(7.5), pixelScale(10))
		self.Portrait:SetPoint("BOTTOMRIGHT", self.Power, "TOPRIGHT", pixelScale(-7.5), pixelScale(-8))
		self.Portrait:SetFrameLevel(self:GetFrameLevel() + 3)

		self.Underlay = CreateFrame("StatusBar", self:GetName().."_Underlay", self)
		self.Underlay:SetFrameLevel(self.Portrait:GetFrameLevel() - 1)
		self.Underlay:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", pixelScale(7.5), pixelScale(11))
		self.Underlay:SetPoint("BOTTOMRIGHT", self.Power, "TOPRIGHT", pixelScale(-6), pixelScale(-9))
		self.Underlay:SetStatusBarTexture([[Interface\ChatFrame\ChatFrameBackground]])
		self.Underlay:SetStatusBarColor(0, 0, 0)

		self.Overlay = CreateFrame("StatusBar", self:GetName().."_Overlay", self)
		self.Overlay:SetFrameLevel(self.Portrait:GetFrameLevel() + 1)
		self.Overlay:SetParent(self.Portrait)
		self.Overlay:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", pixelScale(7.5), pixelScale(11))
		self.Overlay:SetPoint("BOTTOMRIGHT", self.Power, "TOPRIGHT", pixelScale(-6), pixelScale(-9))
		self.Overlay:SetStatusBarTexture(mediaPath.."smallshadertex")
		self.Overlay:SetStatusBarColor(0.1, 0.1, 0.1, 0.75)

		local checkDelay = 5
		local needChecking = true

		self.FlashInfo = CreateFrame("Frame", "FlashInfo", self.Overlay)
		self.FlashInfo.parent = self
		self.FlashInfo:SetToplevel(true)
		self.FlashInfo:SetAllPoints()

		oUF_Caellian_Player.FlashInfo:SetScript("OnUpdate", oUF_Caellian.UpdateManaLevel)

		self.FlashInfo.WarningMsg = oUF_Caellian.SetFontString(self.FlashInfo, caelMedia.fonts.CUSTOM_NUMBERFONT, 14, "OUTLINE")
		self.FlashInfo.WarningMsg:SetPoint("TOP", 0, pixelScale(-3.5))

		local FinishIt_OnUpdate = function(self, elapsed)
			if checkDelay then
				checkDelay = checkDelay - elapsed
				if checkDelay <= 0 then
					playerSpec = GetSpecialization()
					self:SetScript("OnUpdate", nil)
				end
			end
		end

		oUF_Caellian.cmain:RegisterEvent("PLAYER_ENTERING_WORLD")
		oUF_Caellian.cmain:SetScript("OnEvent", function(self, event)
			if needChecking then
				oUF_Caellian.cmain:SetScript("OnUpdate", FinishIt_OnUpdate)
				oUF_Caellian_Target.FlashInfo:SetScript("OnUpdate", oUF_Caellian.UpdateExecLevel)
				needChecking = nil
			end
		end)

		self.Buffs = CreateFrame("Frame", nil, self)
		self.Buffs.size = auraSize
		self.Buffs:SetWidth(pixelScale((self.Buffs.size * 8) + 42))
		self.Buffs:SetHeight(self.Buffs.size)
		self.Buffs.spacing = 6
		self.Buffs.PreSetPosition = oUF_Caellian.PreSetPosition
		self.Buffs.PostCreateIcon = oUF_Caellian.PostCreateAura
		self.Buffs.PostUpdateIcon = oUF_Caellian.PostUpdateIcon

		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs.size = auraSize
		self.Debuffs:SetWidth(pixelScale(230))
		self.Debuffs:SetHeight(self.Debuffs.size)
		self.Debuffs.spacing = 6
		self.Debuffs.PreSetPosition = oUF_Caellian.PreSetPosition
		self.Debuffs.PostCreateIcon = oUF_Caellian.PostCreateAura
		self.Debuffs.PostUpdateIcon = oUF_Caellian.PostUpdateIcon
		if unit == "player" then
			self.Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", pixelScale(-9), pixelScale(-1))
			self.Buffs.initialAnchor = "TOPRIGHT"
			self.Buffs["growth-x"] = "LEFT"
			self.Buffs["growth-y"] = "DOWN"
			self.Buffs.filter = true

			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs["growth-y"] = "DOWN"
			if playerClass == "DEATHKNIGHT" or (playerClass == "WARLOCK" and UnitLevel("player") >= 10 and playerSpec) or (playerClass == "DRUID" and playerSpec == 1) or playerClass == "SHAMAN" then
				self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, pixelScale(-15))
			else
				self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, pixelScale(-7.5))
			end

			self.CPoints = CreateFrame("Frame", nil, self.Power)
			self.CPoints:SetAllPoints()

			for i = 1, MAX_COMBO_POINTS do
				self.CPoints[i] = self.CPoints:CreateTexture(nil, "OVERLAY")
				self.CPoints[i]:SetSize(pixelScale(12), pixelScale(12))
				self.CPoints[i]:SetTexture(mediaPath.."bubbletex")

				if i == 1 then
					self.CPoints[i]:SetPoint("LEFT", pixelScale(3.5), pixelScale(-9))
				else
					self.CPoints[i]:SetPoint("LEFT", self.CPoints[i-1], "RIGHT", pixelScale(1))
				end

				self.CPoints[i]:SetVertexColor(unpack(oUF_Caellian.colors.cpoints[i]))
			end

			self.CPoints.Override = oUF_Caellian.UpdateComboPoints

		elseif unit == "target" then
			self.Buffs:SetPoint("TOPLEFT", self, "TOPRIGHT", pixelScale(9), pixelScale(-1))
			self.Buffs.initialAnchor = "TOPLEFT"
			self.Buffs["growth-y"] = "DOWN"
			self.Buffs.CustomFilter = oUF_Caellian.CustomFilter

			self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, pixelScale(-8))
			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs["growth-y"] = "DOWN"
			if not oUF_Caellian.config.noClassDebuffs then
				self.Debuffs.CustomFilter = oUF_Caellian.CustomFilter
			end
		end

		self.CombatFeedbackText = oUF_Caellian.SetFontString(self.Overlay, caelMedia.fonts.CUSTOM_NUMBERFONT, 14, "OUTLINE")
		self.CombatFeedbackText:SetPoint("CENTER")
--		self.CombatFeedbackText.colors = oUF_Caellian.colors.feedback

		self.Status = oUF_Caellian.SetFontString(self.Overlay, oUF_Caellian.config.font, 18, "OUTLINE")
		self.Status:SetPoint("CENTER", 0, pixelScale(2))
		self.Status:SetTextColor(0.69, 0.31, 0.31, 0)
		self:Tag(self.Status, "[pvp]")

		self:SetScript("OnEnter", function(self) self.Status:SetAlpha(0.5); UnitFrame_OnEnter(self) end)
		self:SetScript("OnLeave", function(self) self.Status:SetAlpha(0); UnitFrame_OnLeave(self) end)
	end

	self.cDebuffFilter = true

	self.cDebuff = CreateFrame("StatusBar", nil, (unit == "player" or unit == "target") and self.Overlay or self.Health)
	self.cDebuff:SetFrameLevel(self:GetFrameLevel() + 3)
	self.cDebuff:SetSize(pixelScale(16), pixelScale(16))
	self.cDebuff:SetPoint("CENTER")

	self.cDebuffBackdrop = self.cDebuff:CreateTexture(nil, "OVERLAY")
	self.cDebuffBackdrop:SetAllPoints(unitInRaid and self.Nameplate or self)
	self.cDebuffBackdrop:SetTexture(mediaPath.."highlighttex")
	self.cDebuffBackdrop:SetBlendMode("ADD")
	self.cDebuffBackdrop:SetVertexColor(0, 0, 0, 0)

	self.cDebuff.icon = self.cDebuff:CreateTexture(nil, "OVERLAY")
	self.cDebuff.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	self.cDebuff.icon:SetAllPoints()

	self.cDebuff.border = CreateFrame("Frame", nil, self.cDebuff)
	self.cDebuff.border:SetPoint("TOPLEFT", pixelScale(-1.5), pixelScale(1.5))
	self.cDebuff.border:SetPoint("BOTTOMRIGHT", pixelScale(1.5), pixelScale(-1.5))
	self.cDebuff.border:SetBackdrop({
		bgFile = caelMedia.files.buttonNormal,
		insets = {top = pixelScale(-1), left = pixelScale(-1), bottom = pixelScale(-1), right = pixelScale(-1)},
	})

	self.cDebuff.gloss = CreateFrame("Frame", nil, self.cDebuff.border)
	self.cDebuff.gloss:SetPoint("TOPLEFT", pixelScale(-1), pixelScale(1))
	self.cDebuff.gloss:SetPoint("BOTTOMRIGHT", pixelScale(1), pixelScale(-1))
	self.cDebuff.gloss:SetBackdrop({
		bgFile = caelMedia.files.buttonGloss,
		insets = {top = pixelScale(-1), left = pixelScale(-1), bottom = pixelScale(-1), right = pixelScale(-1)},
	})

	self.cDebuff.count = oUF_Caellian.SetFontString(self.cDebuff, oUF_Caellian.config.font, 10)
	self.cDebuff.count:SetPoint("CENTER")
	self.cDebuff.count:SetTextColor(0.84, 0.75, 0.65)

	if not (unitInRaid or unitIsPartyPet) then
		self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", (unit == "player" or unit == "target") and self.Portrait or self.Power)
		self.Castbar:SetStatusBarTexture(caelMedia.files.statusBarB)
		self.Castbar:SetAlpha(0.75)

		self.Castbar.PostCastStart = oUF_Caellian.PostCastStart
		self.Castbar.PostChannelStart = oUF_Caellian.PostChannelStart

		if unit == "player" or unit == "target" then
			self.Castbar:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", pixelScale(8), pixelScale(10.5))
			self.Castbar:SetPoint("BOTTOMRIGHT", self.Power, "TOPRIGHT", pixelScale(-6.5), pixelScale(-9))
		else
			self.Castbar:SetHeight(pixelScale(5))
			self.Castbar:SetAllPoints()
		end

		if unit == "player" or unit == "target" then
			self.Castbar.Time = oUF_Caellian.SetFontString(self.Overlay, oUF_Caellian.config.font, 9)
			self.Castbar.Time:SetPoint("TOPRIGHT", pixelScale(-3.5), pixelScale(-1))
			self.Castbar.Time:SetTextColor(0.84, 0.75, 0.65)
			self.Castbar.Time:SetJustifyH("RIGHT")
			self.Castbar.CustomTimeText = oUF_Caellian.CustomCastTimeText
			self.Castbar.CustomDelayText = oUF_Caellian.CustomCastDelayText

			self.Castbar.Text = oUF_Caellian.SetFontString(self.Overlay, oUF_Caellian.config.font, 10)
			self.Castbar.Text:SetPoint("LEFT", pixelScale(3.5), pixelScale(1))
			self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", pixelScale(-1), 0)
			self.Castbar.Text:SetTextColor(0.84, 0.75, 0.65)

			self.Castbar:HookScript("OnShow", function() self.Castbar.Text:Show(); self.Castbar.Time:Show() end)
			self.Castbar:HookScript("OnHide", function() self.Castbar.Text:Hide(); self.Castbar.Time:Hide() end)
		end

		if unit == "player" then
			self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
			self.Castbar.SafeZone:SetTexture(caelMedia.files.statusBarB)
			self.Castbar.SafeZone:SetVertexColor(0.69, 0.31, 0.31, 0.75)

			self.Castbar.Latency = oUF_Caellian.SetFontString(self.Overlay, oUF_Caellian.config.font, 9)
			self.Castbar.Latency:SetPoint("BOTTOMRIGHT", pixelScale(-3.5), 0)
			self.Castbar.Latency:SetTextColor(0.84, 0.75, 0.65)

			self.Castbar:HookScript("OnShow", function() self.Castbar.Latency:Show() end)
			self.Castbar:HookScript("OnHide", function() self.Castbar.Latency:Hide() end)
			
			self:RegisterEvent("UNIT_SPELLCAST_SENT", function(self, event, caster)
				if caster == "player" or caster == "vehicle" then
					self.Castbar.castSent = GetTime()
				end
			end)
		end
	end

	if unitInParty and not unitIsPartyPet and not unitIsPartyTarget or unitInRaid or unit == "player" then
		self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
		self.Leader:SetSize(pixelScale(14), pixelScale(14))
		self.Leader:SetPoint("TOPLEFT", 0, pixelScale(8))

		self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
		self.Assistant:SetSize(pixelScale(14), pixelScale(14))
		self.Assistant:SetPoint("TOPLEFT", 0, pixelScale(8))

		self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
		self.MasterLooter:SetSize(pixelScale(11), pixelScale(11))
		self.MasterLooter:SetPoint("TOPRIGHT", 0, pixelScale(6.5))

		self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
		self.ReadyCheck:SetParent(unitInRaid and self.Nameplate or self.Health)
		self.ReadyCheck:SetSize(pixelScale(12), pixelScale(12))
		self.ReadyCheck.finishedTime = 5
		self.ReadyCheck.fadeTime = 2
		if unitInRaid then
			self.ReadyCheck:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", pixelScale(-5), pixelScale(2))
		else
			self.ReadyCheck:SetPoint("TOPRIGHT", pixelScale(7), pixelScale(7))
		end

		if (unitInParty and not unitIsPartyPet and not unitIsPartyTarget) or unitInRaid then
			self.LFGRole = oUF_Caellian.SetFontString(self.Health, oUF_Caellian.config.font, 9)
			self.LFGRole:SetPoint("LEFT", self.Info, "RIGHT", 0, pixelScale(1))
			self:Tag(self.LFGRole, "[caellian:lfgrole]")
		end
	end

	if unit == "player" or unit == "target" then
--		self:SetSize(pixelScale(230), pixelScale(52))
		self:SetWidth(pixelScale(230))
		self:SetHeight(pixelScale(52))
	elseif not unitInParty and not unitInRaid and not unitIsPartyPet and not unitIsPartyTarget then
--		self:SetSize(pixelScale(112), pixelScale(25))
		self:SetWidth(pixelScale(112))
		self:SetHeight(pixelScale(25))
	end

	self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetParent(unitInRaid and self.Nameplate or self.Health)
	self.RaidIcon:SetTexture(caelMedia.files.raidIcons)
	self.RaidIcon:SetSize(unitInRaid and pixelScale(14) or pixelScale(18), unitInRaid and pixelScale(14) or pixelScale(18))
	if unitInRaid then
		self.RaidIcon:SetPoint("CENTER", 0, pixelScale(10))
	else
		self.RaidIcon:SetPoint("TOP", 0, pixelScale(10))
	end

	if unitInParty or unitInRaid or unitIsPartyPet or unitIsPartyTarget then
		self.Range = {insideAlpha = 1, outsideAlpha = 0.5}
	elseif unit == "target" then
		-- Frame to enable cRange element
		self.cRange = CreateFrame("Frame", nil, self)
		self.cRange:SetFrameLevel(self:GetFrameLevel() + 3)

		self.cRange.text = oUF_Caellian.SetFontString(self.cRange, oUF_Caellian.config.font, 10, "OUTLINE")
		self.cRange.text:SetAllPoints(self.Portrait)
		self.cRange.text:SetTextColor(0.69, 0.31, 0.31)
		self.cRange.text:SetJustifyH("CENTER")
	else
		self.cRange = {insideAlpha = 1, outsideAlpha = 0.5}
	end

	if not unitInParty and not unitInRaid then
		self:SetScale(oUF_Caellian.config.scale)
	end

	if self.Auras then self.Auras:SetScale(oUF_Caellian.config.scale) end
	if self.Buffs then self.Buffs:SetScale(oUF_Caellian.config.scale) end
	if self.Debuffs then self.Debuffs:SetScale(oUF_Caellian.config.scale) end

	oUF_Caellian.HideAura(self)
	oUF_Caellian.SetFocus(self)

	return self
end

oUF_Caellian.SetStyle = SetStyle