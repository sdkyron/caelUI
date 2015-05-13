--[[	$Id: tolbarad.lua 3519 2013-08-23 09:49:35Z sdkyron@gmail.com $	]]

if UnitLevel("player") ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] or (UnitLevel("pet") ~= 0 and UnitLevel("pet") ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]) then return end

local _, caelDataFeeds = ...

caelDataFeeds.tbtimer = caelDataFeeds.createModule("TolBaradTimer")

local tbtimer = caelDataFeeds.tbtimer

tbtimer.text:SetPoint("BOTTOM", caelPanel3, "BOTTOM", 0, caelUI.scale(3))
tbtimer.text:SetParent(caelPanel3)

local delay = 0
tbtimer:SetScript("OnUpdate", function(self, elapsed)
	delay = delay - elapsed
	if delay < 0 then
		local inInstance, instanceType = IsInInstance()
		local _, localizedName, isActive, canQueue, startTime = GetWorldPVPAreaInfo(2)

		if inInstance == nil then
			if startTime > 0 and not isActive then
				local nextBattleTime = SecondsToTime(startTime)

				if nextBattleTime and startTime > 9e2 then
					self.text:SetFormattedText("|cffD7BEA5"..localizedName..":|r %s", nextBattleTime)
				else
					self.text:SetText("|cffD7BEA5"..localizedName..":|r Available")
				end
			elseif isActive and canQueue then
				self.text:SetText("|cffD7BEA5"..localizedName..":|r In progress")
			end
		else
			self.text:SetText("|cffD7BEA5"..localizedName..":|r Unavailable")
		end
		delay = 1
	end
end)