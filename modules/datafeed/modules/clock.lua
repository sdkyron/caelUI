--[[	$Id: clock.lua 3982 2015-01-26 10:18:12Z sdkyron@gmail.com $	]]

local _, caelDataFeeds = ...

caelDataFeeds.clock = caelDataFeeds.createModule("Clock")

local clock = caelDataFeeds.clock

clock.text:SetPoint("RIGHT", caelPanel8, "RIGHT", caelUI.scale(-10), 0)

clock:RegisterEvent("PLAYER_ENTERING_WORLD")
clock:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")

local delay = 0
clock:SetScript("OnUpdate", function(self, elapsed)
    delay = delay - elapsed
    if delay < 0 then
        self.text:SetText(date("%H:%M:%S"))
        delay = 1
    end
end)

clock:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		-- Hides the stupid clock because Blizzard was cool enough to remove the showClock CVAR! GO BLIZZARD YOU ROCK!!
		TimeManagerClockButton:Hide()
	elseif event == "CALENDAR_UPDATE_PENDING_INVITES" then
		if CalendarGetNumPendingInvites() > 0 then
			self.text:SetTextColor(0.33, 0.59, 0.33)
		else
			self.text:SetTextColor(1, 1, 1)
		end
	end
end)

clock:SetScript("OnMouseDown", function(_, button)
    if button == "LeftButton" then
        ToggleTimeManager()
    else
        GameTimeFrame:Click()
    end
end)

local itemList = {"Trove", 32609, "Key", 32626, "Deathtalon", 39287, "Doomroller", 39289, "Terrorfist", 39288, "Vengeance", 39290}

clock:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, caelUI.scale(4))
    GameTooltip:AddLine(date("%B, %A %d %Y"), 0.84, 0.75, 0.65)

	if UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then
		local addedLine = false

		for i = 1, #itemList - 1, 2 do
			if IsQuestFlaggedCompleted(itemList[i + 1]) then
				if not addedLine then
					GameTooltip:AddLine(" ")
					addedLine = true
				end

				GameTooltip:AddDoubleLine(itemList[i], "|cffAF5050Done|r")
			end
		end

		if GetNumSavedWorldBosses() ~= 0 then
			GameTooltip:AddLine(" ")
		end

		for i = 1, GetNumSavedWorldBosses() do
			local name, _, reset = GetSavedWorldBossInfo(i)

			if reset then
				GameTooltip:AddDoubleLine(name, "|cffAF5050Done|r")
			end
		end
	end

	GameTooltip:Show()
end)