--[[	$Id: digBar.lua 3738 2013-11-21 18:12:42Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.capture = caelUI.createModule("Capture")

local color = RAID_CLASS_COLORS[caelUI.playerClass]

local frame
local pixelScale = caelUI.scale

caelUI.capture:RegisterEvent("ADDON_LOADED")
caelUI.capture:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "Blizzard_ArchaeologyUI" then return end
	self:UnregisterEvent("ADDON_LOADED")

	frame = ArcheologyDigsiteProgressBar
	local bar = frame.FillBar

	frame.Shadow:Hide()
	frame.BarBackground:Hide()
	frame.BarBorderAndOverlay:Hide()

	frame.BarTitle:SetFont(caelMedia.fonts.ADDON_FONT, 9)
	frame.BarTitle:SetShadowOffset(0, 0)
	frame.BarTitle:SetPoint("CENTER", 0, 13)

	local width = Minimap:GetWidth()
	bar:SetWidth(width)
	frame.Flash:SetWidth(width + 22)

	bar:SetStatusBarTexture(caelMedia.files.statusBarA)
	bar:SetStatusBarColor(color.r, color.g, color.b)

	bar.bg = caelMedia.createBackdrop(bar)
	bar.bg:SetPoint("TOPLEFT", pixelScale(-2), pixelScale(2))
	bar.bg:SetPoint("BOTTOMRIGHT", pixelScale(2), pixelScale(-2))
end)