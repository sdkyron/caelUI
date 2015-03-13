--[[    $Id: autoGuildManagement.lua 3975 2014-12-04 23:07:52Z sdkyron@gmail.com $       ]]

local _, caelUI = ...

if not (caelUI.myChars or caelUI.herChars) then return end

local randomWelcome = {
	[1]	=	"Bienvenue",
	[2]	=	"Hello",
	[3]	=	"Salut",
	[4]	=	"Yop",
}

------------------------------------------------------------------------
--	Basic initialization stuff.
------------------------------------------------------------------------

local Management = caelUI.createModule("Management")
caelUI.management = Management

-- Avoid giant if-else chains by passing off events to individual functions.
Management:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
Management:RegisterEvent("PLAYER_LOGIN")

function Management:PLAYER_LOGIN()
	self:UnregisterEvent("PLAYER_LOGIN")

	-- If the GuildUI is already loaded, do it now, otherwise wait.
	if IsAddOnLoaded("Blizzard_GuildUI") then
		self:ADDON_LOADED("Blizzard_GuildUI")
	else
		self:RegisterEvent("ADDON_LOADED")
	end

	self:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")

	self:RegisterEvent("GUILD_ROSTER_UPDATE")
	GuildRoster() -- Forces a GUILD_ROSTER_UPDATE to fire soon.
end

------------------------------------------------------------------------
-- Let the GuildUI load normally.
------------------------------------------------------------------------

function Management:ADDON_LOADED(addon)
	if addon == "Blizzard_GuildUI" then
		if GetGuildInfo("player") == "We Did It" and (CanGuildPromote() or CanGuildRemove()) then
			GuildRosterShowOfflineButton:Disable()
		end

		local function ChangeView()
			GuildFrameTab2:Click()
			GuildRoster_SetView("guildStatus")
			-- Currently not performed in _SetView
			UIDropDownMenu_SetSelectedValue(GuildRosterViewDropdown, "guildStatus")
		end
		GuildFrame:HookScript("OnShow", ChangeView)
		GuildFrame:HookScript("OnHide", function()
			ChangeView()
			Management:GUILD_ROSTER_UPDATE()
		end)

		self:UnregisterEvent("ADDON_LOADED")
	end
end

------------------------------------------------------------------------
--	List of calendar events changed.
------------------------------------------------------------------------

function Management:CALENDAR_UPDATE_EVENT_LIST()
	self:ManageCalendar()
end

------------------------------------------------------------------------
--	Guild roster changed.
------------------------------------------------------------------------

function Management:GUILD_ROSTER_UPDATE()
	if GuildFrame and GuildFrame:IsShown() then
		return
	end
	-- Are we in the right guild? Do we have any permissions?
	if GetGuildInfo("player") == "We Did It" and (CanGuildPromote() or CanGuildRemove()) then
		-- Should we defer to the other manager?
		if caelUI.herChars then
			-- Is the other manager online?
			local chars = caelUI.myToons
			for i = 1, GetNumGuildMembers() do
				local name, _, _, _, _, _, _, _, online = GetGuildRosterInfo(i)

				name = Ambiguate(name, "guild")

				if chars[name] and online then
					-- Other manager is online. Let them handle it.
					return
				end
			end
		end

		-- Pass "true" to do it for real, eg. self:ManageGuild(true)
		self:ManageGuild(true)
	end
end

------------------------------------------------------------------------
--	Actual calendar management logic.
------------------------------------------------------------------------

local current = date("*t")

function Management:ManageCalendar()
	local viewedMonth, viewedYear = CalendarGetMonth()

	if viewedMonth ~= current.month or viewedYear ~= current.year then
		return print("Not viewing current month. Skipping scan.")
	end

--	print("Scanning...")

	for monthOffset = -12, 12 do
		local scanMonth, scanYear, numDays = CalendarGetMonth(monthOffset)

		for day = 1, numDays do
			for eventIndex = 1, CalendarGetNumDayEvents(monthOffset, day) do
				local title, _, _, calendarType, _, _, _, _, _, invitedBy = CalendarGetDayEvent(monthOffset, day, eventIndex)

				invitedBy = format(invitedBy:gsub("%-[^|]+", ""))

				if calendarType == "PLAYER" and invitedBy ~= caelUI.playerName then
					if monthOffset < 0 or (monthOffset == 0 and day < current.day) then
						-- Remove the event if it pre-dates the current day
						CalendarContextInviteRemove(monthOffset, day, eventIndex)
					elseif CalendarContextInviteIsPending(monthOffset, day, eventIndex) then
						-- Accept the event if it's from a guildmate
						if caelUI.isGuild(invitedBy) then
							print(format("Accepted guild event: %s from %s on %d-%d-%d", title, invitedBy, day, scanMonth, scanYear))
							CalendarContextInviteAvailable(monthOffset, day, eventIndex)
--[[
						elseif invitedBy == "" then -- or (not caelUI.isFriend(invitedBy) and not (UnitInRaid(invitedBy) or UnitInParty(invitedBy))) then
						-- Remove the event if invitedBy has no name (deleted, most likely a spam)
							print(format("Remove event: %s on %d-%d-%d", title, day, scanMonth, scanYear))
							CalendarContextInviteRemove(monthOffset, day, eventIndex)
--]]
						end
					end
				end
			end
		end
	end
--	print("Done.")
end

------------------------------------------------------------------------
--	Actual guild management logic, all wrapped up in a do-end block to
-- limit scoping.
------------------------------------------------------------------------

do
	local ignoreList = {
		-- Use a hash table here so ignoreList[name] actually works.
		["PlayerName"] = true,
	}

	local testMode, lastAction, lastName = true

	local group = Management:CreateAnimationGroup()
	group.anim = group:CreateAnimation()
	group.anim:SetDuration(1)
	group.anim:SetOrder(1)
	group.parent = Management

	group:SetScript("OnFinished", function(self, forced)
		if forced or (GuildFrame and GuildFrame:IsShown()) then
			return
		end

		local didAction
		for playerIndex = 1, GetNumGuildMembers() do
			local name, _, rankIndex, level, _, _, note, officerNote, _, _, classFileName = GetGuildRosterInfo(playerIndex)

			-- Make it consistent with values for SetGuildMemberRank() for sanity's sake.
			rankIndex = rankIndex + 1

			if rankIndex > 3 then
				if CanGuildRemove() then
					if name:find("Furyou") then
						GuildUninvite(name)
					end
				end

				if CanGuildPromote() then
					local targetRank
					if level >= 1 and level <= 79 and rankIndex ~= 7 then
						targetRank = 7
					elseif level >= 80 and level <= 84 and rankIndex ~= 6 then
						targetRank = 6
					elseif level >= 85 and level <= 89 and rankIndex ~= 5 then
						targetRank = 5
					elseif level >= 90 and rankIndex ~= 4 then
						targetRank = 4
					end
					if targetRank then
						if testMode then
							print("PROMOTE", name, targetRank)
						else
							if lastAction == "PROMOTE" and lastName == name then
								return print("Action failed:", lastAction, lastName, targetRank)
							end
							didAction, lastAction, lastName = true, "PROMOTE", name
							SetGuildMemberRank(playerIndex, targetRank)
						end
						break
					end
				end
--[[
				Règles de supression:
				Niv 1 plus de 1 jour.
				Niv 55 DK plus de 2 jours.
				Niv de 2-5 ou DK 56-58 plus de 3 jours.
				Niv 6-79 plus de 7 jours.
				Niv 80-84 plus de 14 jours.
				Niv 85-89 plus de 21 jours.
				Niv 90-100 plus de 28 jours.
--]]
				if not ignoreList[name] and note == "" and officerNote == "" and CanGuildRemove() then
					local year, month, day = GetGuildRosterLastOnline(playerIndex)
					if year and (
						(rankIndex == 7
						-- level 1 for more than 1 day.
							and (day >= 1 and level == 1)
						-- level 55 DK for more than 2 days.
							or (day >= 2 and level == 55 and classFileName == "DEATHKNIGHT")
						-- level 2-5 and DK level 56-58 for more than 3 days.
							or (day >= 3 and ((level > 1 and level <= 5) or (level > 55 and level <= 58 and classFileName == "DEATHKNIGHT")))
						-- level 6-79 for more than 7 days.
							or (day >= 7 and level > 5 and level <= 79)
						)
						-- level 80-84 for more than 14 days.
						or (rankIndex == 6 and day >= 14)
						-- level 85-89 for more than 21 days.
						or (rankIndex == 5 and day >= 21)
						-- level 90-100 for more than 28 days.
						or (rankIndex == 4 and day >= 28)
					) then
						if testMode then
							print("REMOVE", name)
						else
							if lastAction == "REMOVE" and lastName == name then
								-- Avoid infinite loops if the action is failing.
								return print("Action failed:", lastAction, lastName)
							end
							didAction, lastAction, lastName = true, "REMOVE", name
							GuildUninvite(name)
						end
						break
					end
				end
			end
		end

		if didAction then
			-- Did something, queue the next action.
			self:Play()
		else
			-- Did nothing, we're done.
			Management:RegisterEvent("GUILD_ROSTER_UPDATE")
		end
	end)

	function Management:ManageGuild(doItForReal)
		self:UnregisterEvent("GUILD_ROSTER_UPDATE")

		SortGuildRoster("online")
		SetGuildRosterShowOffline(true)

		if group:IsPlaying() then
			group:Finish()
		end

		testMode = not doItForReal
		group:Play()
	end
end

------------------------------------------------------------------------
--	Newcomers management.
------------------------------------------------------------------------

Management:RegisterEvent("CHAT_MSG_SYSTEM")
function Management:CHAT_MSG_SYSTEM(message)
	local newComer = message:find(caelUI.pattern(ERR_GUILD_JOIN_S))

	if (caelUI.myChars or caelUI.herChars) and (CanGuildPromote() or CanGuildRemove()) and newComer then
		SendChatMessage(randomWelcome[math.random(1, 4)], "GUILD", GetDefaultLanguage("player"))
	end
end

------------------------------------------------------------------------
--	Guild chat spam management.
------------------------------------------------------------------------

local lastTime, lastMessage, lastCount = {}, {}, {}

Management:RegisterEvent("CHAT_MSG_GUILD")
function Management:CHAT_MSG_GUILD(message, sender)
	if GetGuildInfo("player") == "We Did It" and sender ~= caelUI.playerName and CanGuildRemove() then
		local thisTime = GetTime()

		-- Same as the last message, less than 60 seconds apart.
		if lastMessage[sender] == message and thisTime - lastTime[sender] < 60 then
			lastTime[sender] = thisTime
			lastCount[sender] = lastCount[sender] + 1

			if lastCount[sender] >= 5 then
				GuildUninvite(sender)
			end
		else
			-- First message from this sender, or a different message, or more than 60 seconds apart.
			lastMessage[sender] = message
			lastTime[sender] = thisTime
			lastCount[sender] = 1
		end
	end
end