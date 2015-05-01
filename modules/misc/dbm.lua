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

			tbar:SetHeight(18)
			icon:SetSize(18, 18)

			if not bar.styled then
				local spark		=	_G[name.."Spark"]
				local text		=	_G[name.."Name"]
				local timer		=	_G[name.."Timer"]

				frame.background = caelMedia.createBackdrop(tbar)

				texture:SetTexture(caelMedia.files.statusBarC)
				texture.SetTexture = caelUI.dummy

				spark:SetAlpha(0)
				spark:SetTexture(nil)

				icon:SetPoint("RIGHT", frame, "LEFT", -5, 0)
				icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

				icon.frame = CreateFrame("Frame", nil, tbar)
				icon.frame:SetFrameStrata("BACKGROUND")
				icon.frame:SetAllPoints(icon)
				icon.frame.background = caelMedia.createBackdrop(icon.frame)

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

	DBM_AllSavedOptions.Enabled = true
	DBM_AllSavedOptions.BlockVersionUpdateNotice = true
	DBM_AllSavedOptions.StripServerName = true
	DBM_AllSavedOptions.AutoRespond = false
	DBM_AllSavedOptions.ShowMinimapButton = false
	DBM_AllSavedOptions.ShowSpecialWarnings = true
	DBM_AllSavedOptions.SpecialWarningPoint = "CENTER"
	DBM_AllSavedOptions.SpecialWarningFont = caelMedia.fonts.ADDON_FONT
	DBM_AllSavedOptions.SpecialWarningFontColor = {0.69, 0.31, 0.31}
	DBM_AllSavedOptions.SpecialWarningFontSize = 15
	DBM_AllSavedOptions.WarningIconLeft = false
	DBM_AllSavedOptions.WarningIconRight = false
	DBM_AllSavedOptions.AlwaysShowHealthFrame = false
	DBM_AllSavedOptions.ShowSpecialWarnings = true
	DBM_AllSavedOptions.ShowFakedRaidWarnings = true
	DBM_AllSavedOptions.DontShowBossAnnounces = true
	DBM_AllSavedOptions.AlwaysShowSpeedKillTimer = false
	DBM_AllSavedOptions.LatencyThreshold = 50

	DBM_AllSavedOptions.Scale = 1
	DBM_AllSavedOptions.HugeScale = 1
	DBM_AllSavedOptions.BarXOffset = 0
	DBM_AllSavedOptions.BarYOffset = 5
	DBM_AllSavedOptions.HugeBarXOffset = 0
	DBM_AllSavedOptions.HugeBarYOffset = 5
	DBM_AllSavedOptions.Font = caelMedia.fonts.ADDON_FONT
	DBM_AllSavedOptions.FontSize = 9
	DBM_AllSavedOptions.Width = 145
	DBM_AllSavedOptions.HugeWidth = 145
	DBM_AllSavedOptions.FillUpBars = true
	DBM_AllSavedOptions.IconLeft = true
	DBM_AllSavedOptions.ExpandUpwards = false
	DBM_AllSavedOptions.Texture = caelMedia.files.statusBarC
	DBM_AllSavedOptions.IconRight = false
	DBM_AllSavedOptions.HugeBarsEnabled = true

	if (caelUI.myChars or caelUI.herChars) then
		DBM_AllSavedOptions.SpecialWarningX = 0
		DBM_AllSavedOptions.SpecialWarningY = 200
		DBM_AllSavedOptions.InfoFrameX = 200
		DBM_AllSavedOptions.InfoFrameY = -5
		DBM_AllSavedOptions.InfoFramePoint = "TOP"
		DBM_AllSavedOptions.InfoFrameLocked = true
		DBM_AllSavedOptions.RangeFrameLocked = true

		DBM_AllSavedOptions.TimerX = 400
		DBM_AllSavedOptions.TimerY = 0
		DBM_AllSavedOptions.TimerPoint = "TOP"
		DBM_AllSavedOptions.HugeTimerX = 0
		DBM_AllSavedOptions.HugeTimerY = -58
		DBM_AllSavedOptions.HugeTimerPoint = "CENTER"
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