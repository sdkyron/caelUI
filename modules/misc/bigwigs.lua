--[[	$Id: dbm.lua 3890 2014-03-03 08:11:25Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.bw = caelUI.createModule("BigWigs")

local dummy = caelUI.dummy

local backdrops = {}

local CreateBG = function()
	local backdrop = CreateFrame("Frame")

	backdrop:SetPoint("TOPLEFT", caelUI.scale(-2.5), caelUI.scale(2.5))
	backdrop:SetPoint("BOTTOMRIGHT", caelUI.scale(2.5), caelUI.scale(-2.5))
	backdrop:SetBackdrop(caelMedia.backdropTable)
	backdrop:SetBackdropColor(0, 0, 0, 0.5)
	backdrop:SetBackdropBorderColor(0, 0, 0, 1)

	return backdrop
end

local CreateStyle = function(bar)
	local backdrop = bar:Get("bigwigs:caelUI:bg")

	if backdrop then
		backdrop:ClearAllPoints()
		backdrop:SetParent(UIParent)
		backdrop:Hide()
		backdrops[#backdrops + 1] = backdrop
	end

	local iconBg = bar:Get("bigwigs:caelUI:ibg")

	if iconBg then
		iconBg:ClearAllPoints()
		iconBg:SetParent(UIParent)
		iconBg:Hide()
		backdrops[#backdrops + 1] = iconBg
	end

	bar.candyBarBar.SetPoint = bar.candyBarBar.OldSetPoint
	bar.candyBarIconFrame.SetWidth = bar.candyBarIconFrame.OldSetWidth
	bar.SetScale = bar.OldSetScale

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("TOPLEFT")
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT")
	bar.candyBarIconFrame:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetPoint("TOPRIGHT")
	bar.candyBarBar:SetPoint("BOTTOMRIGHT")

	bar.candyBarBackground:SetAllPoints()

	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
	bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
end

local ApplyStyle = function(bar)
	bar:SetHeight(15)
	bar:SetScale(1)
	bar.OldSetScale = bar.SetScale
	bar.SetScale = dummy

	local backdrop = nil

	if #backdrops > 0 then
		backdrop = table.remove(backdrops)
	else
		backdrop = CreateBG()
	end

	backdrop:SetParent(bar)
	backdrop:ClearAllPoints()
	backdrop:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
	backdrop:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
	backdrop:SetFrameStrata("BACKGROUND")
	backdrop:Show()
	bar:Set("bigwigs:caelUI:bg", backdrop)

	local iconBg = nil

	if bar.candyBarIconFrame:GetTexture() then
		if #backdrops > 0 then
			iconBg = table.remove(backdrops)
		else
			iconBg = CreateBG()
		end

		iconBg:SetParent(bar)
		iconBg:ClearAllPoints()
		iconBg:SetPoint("TOPLEFT", bar.candyBarIconFrame, "TOPLEFT", -2, 2)
		iconBg:SetPoint("BOTTOMRIGHT", bar.candyBarIconFrame, "BOTTOMRIGHT", 2, -2)
		iconBg:SetFrameStrata("BACKGROUND")
		iconBg:Show()
		bar:Set("bigwigs:caelUI:ibg", iconBg)
	end

	bar.candyBarLabel:SetFont(caelMedia.fonts.ADDON_FONT, 11)
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:ClearAllPoints()
	bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 2, 0)

	bar.candyBarDuration:SetFont(caelMedia.fonts.ADDON_FONT, 11)
	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:ClearAllPoints()
	bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", 1, 0)

	bar.candyBarBar:ClearAllPoints()
	bar.candyBarBar:SetAllPoints(bar)
	bar.candyBarBar.OldSetPoint = bar.candyBarBar.SetPoint
	bar.candyBarBar.SetPoint = dummy
	bar.candyBarBar:SetStatusBarTexture(caelMedia.files.statusBarC)
	if not bar.data["bigwigs:emphasized"] == true then bar.candyBarBar:SetStatusBarColor(0.84, 0.75, 0.65, 1) end
	bar.candyBarBackground:SetTexture(caelMedia.files.statusBarC)

	bar.candyBarIconFrame:ClearAllPoints()
	bar.candyBarIconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -28, 0)
	bar.candyBarIconFrame:SetSize(15, 15)
	bar.candyBarIconFrame.OldSetWidth = bar.candyBarIconFrame.SetWidth
	bar.candyBarIconFrame.SetWidth = dummy
	bar.candyBarIconFrame:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end

local RegisterStyle = function()
	if not BigWigs then return end

	local bars = BigWigs:GetPlugin("Bars", true)
	local prox = BigWigs:GetPlugin("Proximity", true)

	if bars then
		bars:RegisterBarStyle("caelUI", {
			apiVersion = 1,
			version = 1,
			GetSpacing = function(bar) return caelUI.scale(13) end,
			ApplyStyle = ApplyStyle,
			BarStopped = CreateStyle,
			GetStyleName = function() return "caelUI" end,
		})
	end

	bars.defaultDB.barStyle = "caelUI"

--	if prox and bars.defaultDB.barStyle == "caelUI" then
--		hooksecurefunc(prox, "RestyleWindow", function()
--			BigWigsProximityAnchor:SetTemplate("Transparent")
--		end)
--	end
end

caelUI.bw:RegisterEvent("ADDON_LOADED")
caelUI.bw:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "BigWigs_Plugins" then
			RegisterStyle()
			caelUI.bw:UnregisterEvent("ADDON_LOADED")
		end
	end
end)