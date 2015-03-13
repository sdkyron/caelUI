--[[	$Id: shadowEdge.lua 3546 2013-08-30 01:52:50Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Put a shadow edge around the screen	]]

caelUI.shadowedge = caelUI.createModule("ShadowEdge")

shadowedge = caelUI.shadowedge

shadowedge:SetParent("UIParent")
shadowedge:SetPoint("TOPLEFT")
shadowedge:SetPoint("BOTTOMRIGHT")
shadowedge:SetFrameLevel(0)
shadowedge:SetFrameStrata("BACKGROUND")
shadowedge:EnableMouse(false)

shadowedge.tex = shadowedge:CreateTexture()
shadowedge.tex:SetTexture([[Interface\Addons\caelUI\media\miscellaneous\largeshadertex1]])
shadowedge.tex:SetAllPoints()
shadowedge.tex:SetVertexColor(0, 0, 0, 0.5)

shadowedge:RegisterEvent("UNIT_HEALTH")
shadowedge:SetScript("OnEvent", function(self, event, unit)
	if (unit ~= "player") then return end

	if UnitIsDeadOrGhost("player") then
		shadowedge.tex:SetVertexColor(0, 0, 0, 0.5)
		caelUI.stopflash(shadowedge.tex)
		return
	end

	local currentHealth, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
	local healthPercent = (currentHealth/maxHealth)

	if (currentHealth > 0 and healthPercent < 0.25) then
		shadowedge.tex:SetVertexColor(0.69, 0.31, 0.31, 0.5)
		caelUI.flash(shadowedge.tex, 0.3)
	elseif (healthPercent > 0.25 and healthPercent < 0.5)then
		shadowedge.tex:SetVertexColor(0.65, 0.63, 0.35, 0.5)
		caelUI.flash(shadowedge.tex, 0.5)
	else
		shadowedge.tex:SetVertexColor(0, 0, 0, 0.5)
		caelUI.stopflash(shadowedge.tex)
	end
end)