--[[	$Id: dbm.lua 3890 2014-03-03 08:11:25Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.dbm = caelUI.createModule("Deadly Boss Mods")

local HideBossHealthTitle = function()
	local anchor = DBMBossHealthDropdown:GetParent()

	if not anchor.styled then
		local header = {anchor:GetRegions()}
			if header[1]:IsObjectType("FontString") then
				header[1]:Hide()
				anchor.styled = true	
			end

		header = nil
	end

	anchor = nil
end

local HideBossHealth = function()
	local count = 1

	while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
		local bar = _G[format("DBM_BossHealth_Bar_%d", count)]

		bar:Hide()
		count = count + 1
	end
end

local SetupDBM = function()
	hooksecurefunc(DBT, "CreateBar", function(self)
		for bar in self:GetBarIterator() do
			local frame		=	bar.frame
			local name		=	frame:GetName().."Bar"
			local tbar		=	_G[name]
			local icon		=	_G[name.."Icon1"]
			local texture	=	_G[name.."Texture"]

			icon:SetSize(tbar:GetHeight(), tbar:GetHeight())

			if not bar.styled then
				local spark		=	_G[name.."Spark"]
				local text		=	_G[name.."Name"]
				local timer		=	_G[name.."Timer"]

				if bar.enlarged then
					frame:SetWidth(bar.owner.options.HugeWidth)
					tbar:SetWidth(bar.owner.options.HugeWidth)
					frame:SetScale(bar.owner.options.HugeScale)
				else
					frame:SetWidth(bar.owner.options.Width)
					tbar:SetWidth(bar.owner.options.Width)
					frame:SetScale(bar.owner.options.Scale)
				end

				frame.background = caelMedia.createBackdrop(tbar)

				tbar:SetAllPoints(frame)

				texture:SetTexture(caelMedia.files.statusBarC)
				texture.SetTexture = caelUI.dummy

				spark:SetAlpha(0)
				spark:SetTexture(nil)

				icon:SetPoint("RIGHT", frame, "LEFT", -5, 0)
				icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

				if not icon.overlay then
					icon.overlay = CreateFrame("Frame", "$parentIconOverlay", tbar)
					icon.overlay:SetFrameStrata("BACKGROUND")
					icon.overlay:SetAllPoints(icon)
					icon.overlay.background = caelMedia.createBackdrop(icon.overlay)
				end

				text:SetFont(caelMedia.fonts.ADDON_FONT, 9)
				text:SetShadowOffset(0.75, -0.75)
				text.SetFont = caelUI.dummy

				timer:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 9)
				timer:SetShadowOffset(0.75, -0.75)
				timer.SetFont = caelUI.dummy

				bar.styled = true
			end
		end
	end)

	local firstRange = true
	hooksecurefunc(DBM.RangeCheck, "Show", function()
		if firstRange then
			DBMRangeCheck:SetBackdrop(nil)
			caelMedia.createBackdrop(DBMRangeCheckRadar)

			DBMRangeCheckRadar:SetPoint("LEFT", UIParent, 5, -195)

--			DBMRangeCheckRadar.text:SetFont(caelMedia.fonts.ADDON_FONT, 9)
--			DBMRangeCheckRadar.text:SetShadowOffset(0.75, -0.75)
			DBMRangeCheckRadar.text:Hide()

			DBMRangeCheckRadar.inRangeText:SetFont(caelMedia.fonts.ADDON_FONT, 9)
			DBMRangeCheckRadar.inRangeText:SetShadowOffset(0.75, -0.75)

			firstRange = false
		end
	end)

	local firstInfo = true
	hooksecurefunc(DBM.InfoFrame, "Show", function()
		if firstInfo then
			DBMInfoFrame:SetBackdrop(nil)

			local backdrop = CreateFrame("Frame", nil, DBMInfoFrame)
			backdrop:SetPoint("TOPLEFT")
			backdrop:SetPoint("BOTTOMRIGHT")
			backdrop:SetFrameLevel(DBMInfoFrame:GetFrameLevel() - 1)
			caelMedia.createBackdrop(backdrop)

			firstInfo = false
		end
	end)

	hooksecurefunc(DBM, "ShowUpdateReminder", function()
		for i = UIParent:GetNumChildren(), 1, -1 do
			local frame = select(i, UIParent:GetChildren())

			local editBox = frame:GetChildren()
			if editBox and editBox:GetObjectType() == "EditBox" and editBox:GetText() == "http://www.deadlybossmods.com" and not frame.hidden then
				editBox:GetRegions():Hide()

				frame.hidden = true
			end
		end
	end)

	hooksecurefunc(DBM.BossHealth,"Show", HideBossHealthTitle)
	hooksecurefunc(DBM.BossHealth,"AddBoss", HideBossHealth)
	hooksecurefunc(DBM.BossHealth,"UpdateSettings", HideBossHealth)

	DBM_AllSavedOptions.Default.Enabled = true
	DBM_AllSavedOptions.Default.BlockVersionUpdateNotice = true
	DBM_AllSavedOptions.Default.StripServerName = true
	DBM_AllSavedOptions.Default.DontShowBossAnnounces = false
	DBM_AllSavedOptions.Default.SettingsMessageShown = true
	DBM_AllSavedOptions.Default.ShowWipeMessage = false
	DBM_AllSavedOptions.Default.ShowGuildMessages = false
	DBM_AllSavedOptions.Default.ShowEngageMessage = false
	DBM_AllSavedOptions.Default.ShowKillMessage = false
	DBM_AllSavedOptions.Default.ShowCombatLogMessage = false
	DBM_AllSavedOptions.Default.StatusEnabled = false
	DBM_AllSavedOptions.Default.ShowRecoveryMessage = false
	DBM_AllSavedOptions.Default.ShowCountdownText = false
	DBM_AllSavedOptions.Default.SettingsMessageShown = false
	DBM_AllSavedOptions.Default.PGMessageShown = false
	DBM_AllSavedOptions.Default.AutoRespond = false
	DBM_AllSavedOptions.Default.ShowMinimapButton = false
	DBM_AllSavedOptions.Default.ShowWarningsInChat = false
	DBM_AllSavedOptions.Default.ShowSWarningsInChat = false
	DBM_AllSavedOptions.Default.ShowSpecialWarnings = true
	DBM_AllSavedOptions.Default.ShowTranscriptorMessage = false
	DBM_AllSavedOptions.Default.WarningIconChat = false
	DBM_AllSavedOptions.Default.ShowPizzaMessage = false
	DBM_AllSavedOptions.Default.BugMessageShown = 2
	DBM_AllSavedOptions.Default.WarningFont = caelMedia.fonts.ADDON_FONT
	DBM_AllSavedOptions.Default.SpecialWarningPoint = "CENTER"
	DBM_AllSavedOptions.Default.SpecialWarningFont = caelMedia.fonts.ADDON_FONT
	DBM_AllSavedOptions.Default.SpecialWarningFontCol = {0.69, 0.31, 0.31}
	DBM_AllSavedOptions.Default.SpecialWarningFontSize = 15
	DBM_AllSavedOptions.Default.WarningIconLeft = true
	DBM_AllSavedOptions.Default.WarningIconRight = false
	DBM_AllSavedOptions.Default.AlwaysShowHealthFrame = false
	DBM_AllSavedOptions.Default.ShowFakedRaidWarnings = true
	DBM_AllSavedOptions.Default.AlwaysShowSpeedKillTimer = false
	DBM_AllSavedOptions.Default.LatencyThreshold = 50

	DBM_AllSavedOptions.Default.ShowAllVersions = false
	DBM_AllSavedOptions.Default.ShowCountdownText = true

	DBM_AllSavedOptions.Default.Font = caelMedia.fonts.ADDON_FONT
	DBM_AllSavedOptions.Default.FontSize = 9
	DBM_AllSavedOptions.Default.FillUpBars = true
	DBM_AllSavedOptions.Default.IconLeft = true
	DBM_AllSavedOptions.Default.Texture = caelMedia.files.statusBarC
	DBM_AllSavedOptions.Default.IconRight = false
	DBM_AllSavedOptions.Default.HugeBarsEnabled = true

	DBT_AllPersistentOptions.Default.DBM.ExpandUpwards = true

	DBT_AllPersistentOptions.Default.DBM.Scale = 1
	DBT_AllPersistentOptions.Default.DBM.Width = 138
	DBT_AllPersistentOptions.Default.DBM.TimerPoint = "BOTTOMRIGHT"
	DBT_AllPersistentOptions.Default.DBM.TimerX = -74
	DBT_AllPersistentOptions.Default.DBM.TimerY = 154

	DBT_AllPersistentOptions.Default.DBM.HugeScale = 1
	DBT_AllPersistentOptions.Default.DBM.HugeWidth = 206
	DBT_AllPersistentOptions.Default.DBM.HugeTimerPoint = "CENTER"
	DBT_AllPersistentOptions.Default.DBM.HugeTimerX = -266
	DBT_AllPersistentOptions.Default.DBM.HugeTimerY = -48

	if (caelUI.myChars or caelUI.herChars) then
		DBM_AllSavedOptions.Default.SpecialWarningX = 0
		DBM_AllSavedOptions.Default.SpecialWarningY = 200
		DBM_AllSavedOptions.Default.InfoFrameX = 200
		DBM_AllSavedOptions.Default.InfoFrameY = -5
		DBM_AllSavedOptions.Default.InfoFramePoint = "TOP"
		DBM_AllSavedOptions.Default.InfoFrameLocked = true
		DBM_AllSavedOptions.Default.RangeFrameLocked = true
	end
end

if IsAddOnLoaded("DBM-Core") then
	SetupDBM()
else
	caelUI.dbm:RegisterEvent("ADDON_LOADED")
	caelUI.dbm:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "DBM-Core" then
			return
		end

		self:UnregisterEvent("ADDON_LOADED")

		SetupDBM()

		caelUI.dbm = nil
	end)
end