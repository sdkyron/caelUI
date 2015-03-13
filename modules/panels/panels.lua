--[[	$Id: panels.lua 3536 2013-08-24 16:19:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.panels = caelUI.createModule("Panels")

local caelPanels = caelUI.panels

local pixelScale = caelUI.scale

local panels, n = {}, 1
--	local fadePanels = {}
local bgTexture = caelMedia.files.bgFile

caelPanels.createPanel = function(name, x, y, width, height, point, rpoint, anchor, parent, strata)
	panels[n] = CreateFrame("frame", name, parent)
	panels[n]:EnableMouse(false)
	panels[n]:SetFrameStrata(strata)
	panels[n]:SetWidth(pixelScale(width))
	panels[n]:SetHeight(pixelScale(height))
	panels[n]:SetPoint(point, anchor, rpoint, pixelScale(x), pixelScale(y))
	panels[n]:SetBackdrop(caelMedia.backdropTable)
	panels[n]:SetBackdropColor(0, 0, 0, 0.33)
	panels[n]:SetBackdropBorderColor(0, 0, 0)
	panels[n]:Show()
	n = n + 1
end

caelPanels.createPanel("caelPanel1", 401, 20, 321, 109, "BOTTOM", "BOTTOM", UIParent, UIParent, "BACKGROUND") -- Chatframes
caelPanels.createPanel("caelPanel2", -401, 20, 321, 130, "BOTTOM", "BOTTOM", UIParent, UIParent, "BACKGROUND") -- CombatLog
caelPanels.createPanel("caelPanel3", 0, 20, 130, 130, "BOTTOM", "BOTTOM", UIParent, UIParent, "MEDIUM") -- Minimap
caelPanels.createPanel("caelPanel4", -153, 90, 172, 60, "BOTTOM", "BOTTOM", UIParent, UIParent, "MEDIUM") -- TopLeftBar
caelPanels.createPanel("caelPanel5", 153, 90, 172, 60, "BOTTOM", "BOTTOM", UIParent, UIParent, "MEDIUM") -- TopRightBar
caelPanels.createPanel("caelPanel6", -153, 20, 172, 60, "BOTTOM", "BOTTOM", UIParent, UIParent, "MEDIUM") -- BottomLeftBar
caelPanels.createPanel("caelPanel7", 153, 20, 172, 60, "BOTTOM", "BOTTOM", UIParent, UIParent, "MEDIUM") -- BottomRightBar
caelPanels.createPanel("caelPanel8", 0, 2, 1124, 18, "BOTTOM", "BOTTOM", UIParent, UIParent, "BACKGROUND") -- DataFeeds bar
caelPanels.createPanel("caelPanel9", 0, 0, 31, 336, "RIGHT", "RIGHT", UIParent, MultiBarLeft, "BACKGROUND") -- Side Action Bar
caelPanels.createPanel("caelPanel10", -45, 1.5, 230, 20, "BOTTOM", "TOP", caelPanel1, caelPanel1, "BACKGROUND") -- ChatFrameEditBox
caelPanels.createPanel("caelPanel11", -5, -5, 223, 150, "TOPRIGHT", "TOPRIGHT", UIParent, UIParent, "MEDIUM") -- Battlefield Minimap

caelPanels:HookScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		if NumerationFrame then
			caelPanels.createPanel("caelPanel12", -647, 2, 167, 148, "BOTTOM", "BOTTOM", UIParent, NumerationFrame, "BACKGROUND") -- MeterLeft
			NumerationFrame:ClearAllPoints()
			NumerationFrame:SetPoint("TOPLEFT", caelPanel12, "TOPLEFT", pixelScale(3), pixelScale(-3))
		end

		if recThreatMeter then
			caelPanels.createPanel("caelPanel13", 647, 2, 167, 148, "BOTTOM", "BOTTOM", UIParent, recThreatMeter, "BACKGROUND") -- MeterRight
			recThreatMeter:ClearAllPoints()
			recThreatMeter:SetPoint("TOPLEFT", caelPanel13, "TOPLEFT", pixelScale(3), pixelScale(-3))
		end

		for i = 1, 13 do
			local panel = panels[i]
			if panel then
				local width = pixelScale(panel:GetWidth() - 4.5)
				local height = pixelScale(panel:GetHeight() / 5)

				local gradientTop = panel:CreateTexture(nil, "BORDER")
				gradientTop:SetTexture(bgTexture)
				gradientTop:SetSize(width, height)
				gradientTop:SetPoint("TOPLEFT", pixelScale(2.5), pixelScale(-2))
				gradientTop:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0.84, 0.75, 0.65, 0.5)

				local gradientBottom = panel:CreateTexture(nil, "BORDER")
				gradientBottom:SetTexture(bgTexture)
				gradientBottom:SetSize(width, height)
				gradientBottom:SetPoint("BOTTOMLEFT", pixelScale(2.5), pixelScale(2))
				gradientBottom:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.75, 0, 0, 0, 0)

				if i ~= 1 and i ~= 10 and i ~= 11 then
					RegisterStateDriver(panel, "visibility", "[petbattle] hide; show")
				end
			end
		end
	elseif event == "PET_BATTLE_OPENING_START" then
		caelPanel1:ClearAllPoints()
		caelPanel1:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 20)
	elseif event == "PET_BATTLE_OVER" then
		caelPanel1:ClearAllPoints()
		caelPanel1:SetPoint("BOTTOM", UIParent, 401, 20)
	end
--	for i = 4, 7 do
--		table.insert(fadePanels, panels[i])
--		table.insert(fadePanels, rABS_Bar1Holder)
--		table.insert(fadePanels, rABS_Bar2Holder)
--		table.insert(fadePanels, rABS_Bar3Holder)
--		table.insert(fadePanels, rABS_Bar45Holder)
--	end
end)

--[[
local reverse
local animElapsed = 0
local animTime = 1
local OnUpdate = function(self, elapsed)
	animElapsed = animElapsed + elapsed
	perc = reverse and (animTime - animElapsed) / animTime or animElapsed / animTime

--	for i, v in ipairs(fadePanels) do
--		v:SetAlpha(perc * 1)
--	end

	if animElapsed >= animTime then
		self:SetScript("OnUpdate", nil)
		for i, v in ipairs(fadePanels) do
			self:SetAlpha(reverse and 0 or 1)
		end
		animElapsed = 0
	end
end

function caelPanels:PLAYER_REGEN_DISABLED(event)
	reverse = false

	for i = 1, 8 do
		local panel = panels[i]
		if panel then
			if i == 1 then
				panel:SetPoint("BOTTOM", UIParent, "BOTTOM", 401, 20)
			elseif i == 2 then
				panel:SetPoint("BOTTOM", UIParent, "BOTTOM", -401, 20)
			end
		end
	end

	caelPanels:SetScript("OnUpdate", OnUpdate)
end

function caelPanels:PLAYER_REGEN_ENABLED(event)
	reverse = true

	for i = 1, 8 do
		local panel = panels[i]
		if panel then
			if i == 1 then
				panel:SetPoint("BOTTOM", UIParent, "BOTTOM", 227, 20)
			elseif i == 2 then
				panel:SetPoint("BOTTOM", UIParent, "BOTTOM", -227, 20)
			end
		end
	end

	caelPanels:SetScript("OnUpdate", OnUpdate)
end

caelPanels:RegisterEvent("PLAYER_REGEN_DISABLED")
caelPanels:RegisterEvent("PLAYER_REGEN_ENABLED")
--]]

for _, event in next, {
	"PET_BATTLE_OPENING_START",
	"PET_BATTLE_OVER",
	"PLAYER_LOGIN",
} do
	caelPanels:RegisterEvent(event)
end

-- Push panels table into global scope.
_G["caelPanels"] = panels