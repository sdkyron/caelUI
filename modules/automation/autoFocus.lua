--[[	$Id: autoFocus.lua 3959 2014-12-02 08:24:09Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Auto set the tank as focus	]]

caelUI.autofocus = caelUI.createModule("AutoFocus")

local button = focusButton or CreateFrame("BUTTON", "focusButton", UIParent, "SecureActionButtonTemplate")
button:SetAttribute("type", "macro")

local instanceType

tankList = {}

local hasResolve = GetSpellInfo(158298)

local function IsTankCheck(unit, check)
	local status = false
 
	local _, unitClass = UnitClass(unit)

	if check then
		if UnitAura(unit, check) then
			status = true
		end
	end

	return status
end

local ListContains = function(list, value)
	for k, v in pairs(list) do
		if value == v then
			return true
		end
	end

	return false
end

local UpdateMacroText = function()
	local macroText = "/focus "

	if #tankList == 0 then
		macroText = ""
	end

	for k, v in pairs(tankList) do
		macroText = macroText..string.format("[target=%s, nodead]", v)
	end

	button:SetAttribute("macrotext", macroText)
end

caelUI.autofocus:SetScript("OnEvent", function(self, event, unit)
	if InCombatLockdown() then
		return
	end

	if caelUI.playerClass == "ROGUE" and UnitExists("focus") and select(3, UnitClass("focus")) == 4 then
		return
	end

	if event == "PLAYER_ENTERING_WORLD" then
		instanceType = select(2, IsInInstance())
	end

	if instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= "scenario" then
		table.wipe(tankList)

		return
	end

	if event == "GROUP_ROSTER_UPDATE" then
		table.wipe(tankList)

		for i = 1, GetNumGroupMembers() do
			local unit = instanceType == "raid" and "raid"..i or "party"..i

			local unitIsTank = IsTankCheck(unit, hasResolve)

			if unitIsTank then
				table.insert(tankList, unit)
			end
		end

		UpdateMacroText()
	end

	if event == "UNIT_AURA" then
		if IsTankCheck(unit, hasResolve) and not ListContains(tankList, unit) then
			if strfind(unit, "party") or strfind(unit, "raid") then
				table.insert(tankList, unit)
			end
		end

		UpdateMacroText()
	end
end)

for _, event in next, {
	"GROUP_ROSTER_UPDATE",
	"PLAYER_ENTERING_WORLD",
	"UNIT_AURA"
} do
	caelUI.autofocus:RegisterEvent(event)
end