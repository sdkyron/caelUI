--[[	$Id: threat.lua 3964 2014-12-02 08:27:55Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.threat = caelUI.createModule("Threat")

local threat = caelUI.threat

local abs = math.abs
local playerClass = caelUI.playerClass
local unitClass, lastWarning

local warningSounds = true

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

-- You can get the colours from GetThreatStatusColor(#)				
-- 0 - You have less than 100% raw threat
-- 1 - You have 100% or higher raw threat but aren't tanking yet
-- 2 - You are tanking and another unit has 100% or higher raw threat
-- 3 - You are tanking and no other unit has 100% or higher raw threat

local aggroColors = {
	[true] = {
		[0] = {0, 0, 0, 1}, -- Black
		[1] = {0.65, 0.63, 0.35, 1}, -- Yellow
		[2] = {0.71, 0.43, 0.27, 1}, -- Orange
		[3] = {0.33, 0.59, 0.33, 1}, -- Green
	},
	[false] = {
		[0] = {0, 0, 0, 1}, -- Black
		[1] = {0.65, 0.63, 0.35, 1}, -- Yellow
		[2] = {0.71, 0.43, 0.27, 1}, -- Orange
		[3] = {0.69, 0.31, 0.31, 1}, -- Red
	}
}

threat:RegisterEvent("UNIT_AURA")
threat:RegisterEvent("GROUP_ROSTER_UPDATE")
threat:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
threat:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
threat:HookScript("OnEvent", function(self, event, unit)
	if tostring(GetZoneText()) == "Wintergrasp" or QueueStatusMinimapButton.status == "active" then return end

	if not unit then return end

	_, unitClass = UnitClass(unit)

	local unitIsTank = IsTankCheck(unit, hasResolve)
	local playerIsTank = IsTankCheck("player", hasResolve)

	if event ~= "UNIT_AURA" then

		local _, status, threatPercent = UnitDetailedThreatSituation("player", "target")

		if not playerIsTank then

			if status then
				threatPercent = floor(threatPercent + 0.5)
			end

			if (status and status < 1)	then
				if (abs(threatPercent - 20) <= 5) then
					if (lastWarning ~= 20) then
						RaidNotice_AddMessage(RaidWarningFrame, "|cff559655".."~20% THREAT|r", ChatTypeInfo["RAID_WARNING"])
						lastWarning = 20
					end
				elseif (abs(threatPercent - 40) <= 5) then
					if (lastWarning ~= 40) then
						RaidNotice_AddMessage(RaidWarningFrame, "|cff559655".."~40% THREAT|r", ChatTypeInfo["RAID_WARNING"])
						lastWarning = 40
					end
				elseif (abs(threatPercent - 60) <= 5) then
					if (lastWarning ~= 60) then
						RaidNotice_AddMessage(RaidWarningFrame, "|cffFFFF78".."~60% THREAT|r", ChatTypeInfo["RAID_WARNING"]) -- Yellow |cffA5A05A
						lastWarning = 60
					end
				end
			elseif (status and status > 0 and status < 3 and unit == "player") then
				if (abs(threatPercent - 80) <= 5) then
					if (lastWarning ~= 85) then
						if warningSounds then
							PlaySoundFile(caelMedia.files.soundWarning, "Master")
						end
						RaidNotice_AddMessage(RaidWarningFrame, "|cffFF9900".."WARNING THREAT: "..tostring(threatPercent).."%|r", ChatTypeInfo["RAID_WARNING"]) -- Orange |cffB46E46
						lastWarning = 85
					end
				end
			elseif (status and status > 2 and unit == "player") then
				if warningSounds then
					PlaySoundFile(caelMedia.files.soundAggro, "Master")
				end

				RaidNotice_AddMessage(RaidWarningFrame, "|cffAF5050AGGRO|r", ChatTypeInfo["RAID_WARNING"]) -- Red
			end
		end
	end

--	if GetNumGroupMembers() > 0 then
		if IsAddOnLoaded("caelUI") then
--[[
			for _, panel in pairs(caelPanels) do
				local status = UnitThreatSituation("player")

				if (status and status > 0) then
					local r, g, b = unpack(aggroColors[playerIsTank][status])
					panel:SetBackdropBorderColor(r, g, b)
				else
					panel:SetBackdropBorderColor(0, 0, 0)
				end
			end
--]]
			for plate in pairs(caelUI.activePlates) do
				if plate.oldglow:IsShown() then
					local r, g, b = plate.oldglow:GetVertexColor()
					local status = (g + b == 0 and 3) or (b == 0 and 2) or (r + b == 0 and 1) or 0

					plate.healthGlow:SetBackdropBorderColor(unpack(aggroColors[playerIsTank][status]))
				else
					plate.healthGlow:SetBackdropBorderColor(0, 0, 0)
				end
			end

			for k, v in pairs(oUF.objects) do
				if v.unit == unit then
					local status = UnitThreatSituation(unit)

					if (status and status > 0) then
						local r, g, b = unpack(aggroColors[unitIsTank][status])
						v.FrameBackdrop:SetBackdropColor(r, g, b, a)
						if v.Overlay then
							v.Overlay:SetStatusBarColor(r, g, b, a)
						end
					else
						v.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
						if v.Overlay then
							v.Overlay:SetStatusBarColor(0.1, 0.1, 0.1, 0.75)
						end
					end
				end
			end					
		end
--	end
end)