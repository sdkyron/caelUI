--[[	$Id: autoTab.lua 3535 2013-08-24 14:49:27Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.tabswitch = caelUI.createModule("Tab Switch")

local button = tabButton or CreateFrame("BUTTON", "tabButton", UIParent, "SecureActionButtonTemplate")
button:SetAttribute("type", "macro")

caelUI.tabswitch:SetScript("OnEvent", function()
	if InCombatLockdown() then
		return
	end

	local _, instanceType = IsInInstance()

	if instanceType == "pvp" or instanceType == "arena" or GetZonePVPInfo() == "combat" then
		button:SetAttribute("macrotext", "/targetenemyplayer")
	else
		button:SetAttribute("macrotext", "/targetenemy")
	end
end)

for _, event in next, {
	"PLAYER_ENTERING_WORLD",
	"ZONE_CHANGED_NEW_AREA",
} do
	caelUI.tabswitch:RegisterEvent(event)
end