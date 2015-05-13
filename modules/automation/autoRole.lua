--[[	$Id: autoRole.lua 3908 2014-03-13 08:48:10Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Auto set role	]]

caelUI.autorole = caelUI.createModule("AutoRole")

local autorole = caelUI.autorole

RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")

local noRole = "NONE"
local currentRole = "NONE"

local isInit = false
local doCheck = false
local isRoleSet = false

local CheckRole = function(force)
	if not force and currentRole ~= noRole then return end

	local playerClass = caelUI.playerClass
	local playerSpec = GetSpecialization()
	local oldRole = UnitGroupRolesAssigned("player")

	if playerSpec == nil then
		currentRole = noRole
		return
	end

	currentRole = GetSpecializationRole(playerSpec)
	if oldRole ~= currentRole then
		isRoleSet = false
	end
end

local SetRole = function(currentRole, isPoll)
	if currentRole == nil or currentRole == noRole or isRoleSet or (not isPoll and not IsInRaid()) then
		return
	end

	isRoleSet = true
	UnitSetRole("player", currentRole)
end

autorole:SetScript("OnEvent", function(self, event, ...)
	if not isInit or InCombatLockdown() then return end

	if event == "PLAYER_SPECIALIZATION_CHANGED" then
		CheckRole(true)
		SetRole(currentRole, false)
	end

	if event == "ROLE_POLL_BEGIN" then
		currentRole = noRole
		CheckRole(true)
		isRoleSet = false
		SetRole(currentRole, true)
		StaticPopupSpecial_Hide(RolePollPopup)
	end

	if event == "GROUP_ROSTER_UPDATE" then
		doCheck = true
	end
end)

local delay = 0
autorole:SetScript("OnUpdate", function(self, elapsed)
	delay = delay + elapsed

	if delay > 1 then
		delay = 0

		if isInit then
			if doCheck then
				doCheck = false
				CheckRole(false)
				SetRole(currentRole, false)
			end
		else
			local specName = caelUI.playerSpec and select(2, GetSpecializationInfo(caelUI.playerSpec)) -- GetTalentInfo(1)

			if specName then
				isInit = true
				doCheck = true
			end
		end
	end
end)

for _, event in next, {
	"GROUP_ROSTER_UPDATE",
	"PLAYER_SPECIALIZATION_CHANGED",
	"ROLE_POLL_BEGIN"
} do
	autorole:RegisterEvent(event)
end