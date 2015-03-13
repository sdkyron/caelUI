--[[	$Id: altPower.lua 3763 2013-12-01 10:56:18Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Move and reskin the PlayerPowerBarAlt	]]

caelUI.altpower = caelUI.createModule("AltPower")

local altpower = caelUI.altpower

local pixelScale = caelUI.scale

local blizzColors = {
	["INTERFACE\\UNITPOWERBARALT\\GARROSHENERGY_HORIZONTAL_FILL.BLP"] = {r = 0.4, g = 0.05, b = 0.67},
	["INTERFACE\\UNITPOWERBARALT\\ARSENAL_HORIZONTAL_FILL.BLP"] = {r = 1, g = 0, b = 0.2},
	["INTERFACE\\UNITPOWERBARALT\\PRIDE_HORIZONTAL_FILL.BLP"] = {r = 0, g = 0.2, b = 0.8},
	["INTERFACE\\UNITPOWERBARALT\\LIGHTNING_HORIZONTAL_FILL.BLP"] = {r = 0.12, g = 0.56, b = 1},
	["INTERFACE\\UNITPOWERBARALT\\AMBER_HORIZONTAL_FILL.BLP"] = {r = 0.97, g = 0.81, b = 0},
	["INTERFACE\\UNITPOWERBARALT\\STONEGUARDAMETHYST_HORIZONTAL_FILL.BLP"] = {r = 0.67, g = 0, b = 1},
	["INTERFACE\\UNITPOWERBARALT\\STONEGUARDCOBALT_HORIZONTAL_FILL.BLP"] = {r = 0.1, g = 0.4, b = 0.95},
	["INTERFACE\\UNITPOWERBARALT\\STONEGUARDJADE_HORIZONTAL_FILL.BLP"] = {r = 0.13, g = 0.55, b = 0.13},
	["INTERFACE\\UNITPOWERBARALT\\STONEGUARDJASPER_HORIZONTAL_FILL.BLP"] = {r = 1, g = 0.4, b = 0},
	["INTERFACE\\UNITPOWERBARALT\\BREWINGSTORM_HORIZONTAL_FILL.BLP"] = {r = 1, g = 0.84, b = 0},
	["INTERFACE\\UNITPOWERBARALT\\SHAWATER_HORIZONTAL_FILL.BLP"] = {r = 0.1, g = 0.6, b = 1},
	["INTERFACE\\UNITPOWERBARALT\\ARCANE_CIRCULAR_FILL.BLP"] = {r = 0.52, g = 0.44, b = 1},
	["INTERFACE\\UNITPOWERBARALT\\MOLTENFEATHERS_HORIZONTAL_FILL.BLP"] = {r = 1, g = 0.4, b = 0},
	["INTERFACE\\UNITPOWERBARALT\\RHYOLITH_HORIZONTAL_FILL.BLP"] = {r = 1, g = 0.4, b = 0},
	["INTERFACE\\UNITPOWERBARALT\\CHOGALL_HORIZONTAL_FILL.BLP"] = {r = 0.4, g = 0.05, b = 0.67},
	["INTERFACE\\UNITPOWERBARALT\\MAP_HORIZONTAL_FILL.BLP"] = {r = 0.97, g = 0.81, b = 0}
}

PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_SHOW")
PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_HIDE")
PlayerPowerBarAlt:UnregisterEvent("PLAYER_ENTERING_WORLD")

altpower:SetSize(pixelScale(130), pixelScale(18))
altpower:SetPoint("BOTTOM", caelPanel3, "TOP", 0, pixelScale(4))

altpower:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if UnitAlternatePowerInfo("player") then
		self:Show()
	else
		self:Hide()
	end
end)

altpower:SetScript("OnEnter", function(self)
	local name = select(10, UnitAlternatePowerInfo("player"))
	local tooltip = select(11, UnitAlternatePowerInfo("player"))

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:AddLine(name, 1, 1, 1)
	GameTooltip:AddLine(tooltip, nil, nil, nil, true)

	GameTooltip:Show()
end)

altpower:SetScript("OnLeave", GameTooltip_Hide)

local status = CreateFrame("StatusBar", nil, altpower)
status:SetFrameLevel(altpower:GetFrameLevel() + 1)
status:SetStatusBarTexture(caelMedia.files.statusBarC)
status:SetMinMaxValues(0, 100)
status:SetPoint("TOPLEFT", pixelScale(2), pixelScale(-2))
status:SetPoint("BOTTOMRIGHT", pixelScale(-2), pixelScale(2))

status.text = status:CreateFontString(nil, "OVERLAY")
status.text:SetFont(caelMedia.fonts.ADDON_FONT, 9)
status.text:SetPoint("CENTER", altpower)

status.bg = caelMedia.createBackdrop(status)

local delay = 1
status:SetScript("OnUpdate", function(self, elapsed)
	if not altpower:IsShown() then
		return
	end

	delay = delay + elapsed

	if delay >= 1 then
		local power = UnitPower("player", ALTERNATE_POWER_INDEX)
		local mpower = UnitPowerMax("player", ALTERNATE_POWER_INDEX)
		local texture, r, g, b = UnitAlternatePowerTextureInfo("player", 2, 0)

		if blizzColors[texture] then
			r, g, b = blizzColors[texture].r, blizzColors[texture].g, blizzColors[texture].b
		elseif not texture then
			r, g, b = 0.33, 0.59, 0.33
		end

		self:SetMinMaxValues(0, mpower)
		self:SetValue(power)
		self.text:SetText(power.."/"..mpower)
		self:SetStatusBarColor(r, g, b)
--		self.bg:SetVertexColor(r, g, b, 0.25)
		delay = 0
	end
end)

for _, event in next, {
	"PLAYER_ENTERING_WORLD",
	"UNIT_POWER",
	"UNIT_POWER_BAR_HIDE",
	"UNIT_POWER_BAR_SHOW",
} do
	altpower:RegisterEvent(event)
end