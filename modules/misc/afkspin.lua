--[[	$Id: afkspin.lua 3535 2013-08-24 14:49:27Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.afkspin = caelUI.createModule("AfkSpin")

if GetCVar("AutoClearAFK") == 0 then
	SetCVar("AutoClearAFK", 1)
end

local dimmer = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
dimmer:SetHighlightTexture(nil)
dimmer:SetPushedTexture(nil)
dimmer:SetNormalTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
dimmer:RegisterForClicks("AnyUp")
dimmer:SetAllPoints()
dimmer:Hide()
RegisterStateDriver(dimmer, "visibility", "[combat] hide")

local GoAFK = function()
	if not UnitAffectingCombat("player") then
		MoveViewRightStart(0.01)
		dimmer:Show()
	end
end

local ReturnFromBeingAFK = function()
	MoveViewRightStop()

	if not UnitAffectingCombat("player") then
		dimmer:Hide()
	end
end

dimmer:SetScript("OnClick", function()
	if UnitIsAFK("player") then
		SendChatMessage("", "AFK")

		ReturnFromBeingAFK()
	end
end)

local ToggleAFKState = function()
	if UnitIsAFK("player") then
		GoAFK()
	else
		ReturnFromBeingAFK()
	end
end

caelUI.afkspin:SetScript("OnEvent", function(_, event, unit)
	if event == "PLAYER_FLAGS_CHANGED" then
		if unit ~= "player" then
			return
		end
    elseif event == "PLAYER_REGEN_DISABLED" then
		if dimmer:IsVisible() then
			MoveViewRightStop()
		end

		return
	end

	ToggleAFKState()
end)

for _, event in next, {
	"PLAYER_ENTERING_WORLD",
	"PLAYER_FLAGS_CHANGED",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED"
} do
	caelUI.afkspin:RegisterEvent(event)
end