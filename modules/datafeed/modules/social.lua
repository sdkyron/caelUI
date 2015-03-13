--[[	$Id: social.lua 3932 2014-09-29 06:46:57Z sdkyron@gmail.com $	]]

local _, caelDataFeeds = ...

caelDataFeeds.social = caelDataFeeds.createModule("Social")

local social = caelDataFeeds.social

social.text:SetPoint("CENTER", caelPanel8, "CENTER", caelUI.scale(325), 0)

local numGuildMembers = 0
local numOnlineGuildMembers = 0

local numFriends = 0
local numOnlineFriends = 0

local numBN = 0
local numOnlineBN = 0

local delay = 0
social:SetScript("OnUpdate", function(self, elapsed)
	delay = delay - elapsed
	if delay < 0 then
		if IsInGuild("player") then
			GuildRoster()
		end
		delay = 10
	end
end)

local CURRENT_GUILD_SORTING

hooksecurefunc("SortGuildRoster", function(type) CURRENT_GUILD_SORTING = type end)

social:SetScript("OnEnter", function(self)
	if IsAddOnLoaded("Blizzard_GuildUI") then
		GuildRoster_SetView("playerStatus")
		UIDropDownMenu_SetSelectedValue(GuildRosterViewDropdown, "playerStatus") -- Currently not performed in _SetView
	end

	numGuildMembers = GetNumGuildMembers()
	numFriends = GetNumFriends() 
	numBNFriends = BNGetNumFriends()

	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, caelUI.scale(4))

	if numOnlineGuildMembers > 0 then

		local sortingOrder = CURRENT_GUILD_SORTING
		if sortingOrder ~= "level" then
			SortGuildRoster("level")
		end

		GameTooltip:AddLine("Online Guild Members", 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")

		for i = 1, numGuildMembers do
			local name, _, _, level, _, zone, _, _, isOnline, status, classFileName, _, _, isMobile = GetGuildRosterInfo(i)
			local color = RAID_CLASS_COLORS[classFileName]
			local realStatus = status == 1 and "«AFK»" or status == 2 and "«DND»" or ""
			
			if isOnline and name ~= caelUI.playerName then
				GameTooltip:AddDoubleLine("|cffD7BEA5"..level.." |r"..name.." "..realStatus, zone, color.r, color.g, color.b, 0.65, 0.63, 0.35)
			end
		end

		if numOnlineFriends > 0 or (numOnlineBN > 0 and numOnlineFriends == 0) then
			GameTooltip:AddLine(" ")
		end
	end

	if numOnlineFriends > 0 then
		GameTooltip:AddLine("Online Friends", 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
		for i = 1, numFriends do
			local name, level, class, zone, isOnline, status = GetFriendInfo(i)

			if not isOnline then break end

			for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if class == v then
					class = k
				end
			end

			if caelUI.Locale ~= "enUS" then -- female class localization
				for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
					if class == v then
						class = k
					end
				end
			end

			local color = RAID_CLASS_COLORS[class]
			if isOnline then
				GameTooltip:AddDoubleLine("|cffD7BEA5"..level.." |r"..name.." "..status, zone, color.r, color.g, color.b, 0.65, 0.63, 0.35)
			end
		end

		
		if numBNFriends > 0 then
			GameTooltip:AddLine(" ")
		end
	end

	if numOnlineBN > 0 then
		GameTooltip:AddLine("Online BN Friends", 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
		for i = 1, numBNFriends do
			local presenceID = BNGetFriendInfo(i)

			local _, _, _, _, toonName, _, client, isOnline, _, isAFK, isDND = BNGetFriendInfoByID(presenceID)

			if client == "WoW" then
				local _, _, _, realmName, _, _, _, class, _, zoneName, level = BNGetFriendToonInfo(i, 1)

				if not isOnline then break end

				for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
					if class == v then
						class = k
					end
				end

				if caelUI.Locale ~= "enUS" then
					for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
						if class == v then
							class = k
						end
					end
				end

				local color = RAID_CLASS_COLORS[class]
				if isOnline then
					if color then
						GameTooltip:AddDoubleLine("|cffD7BEA5"..level.." |r"..toonName, zoneName ~= "" and zoneName or "Unknown", color.r, color.g, color.b, 0.65, 0.63, 0.35)
					else
						GameTooltip:AddDoubleLine("|cffD7BEA5"..level.." |r"..toonName, zoneName ~= ""  and zoneName or "Unknown", 0.55, 0.57, 0.61, 0.65, 0.63, 0.35)
					end
				end
			elseif client == "App" or client == "D3" or client == "S2" or client == "WTCG" then
				if client == "App" then client = "Battle.net" end
				if client == "D3" then client = "Diablo 3" end
				if client == "S2" then client = "Starcraft 2" end
				if client == "WTCG" then client = "Hearthstone" end

				if isOnline then
					GameTooltip:AddDoubleLine(" • •  "..toonName, client, 0.55, 0.57, 0.61, 0.65, 0.63, 0.35)
				end
			end
		end
	end
	GameTooltip:Show()
end)

social:SetScript("OnLeave", function(self)
	if (caelUI.myChars or caelUI.herChars) and GetGuildInfo("player") == "We Did It" and (CanGuildPromote() or CanGuildRemove()) and IsAddOnLoaded("Blizzard_GuildUI") then
		GuildRoster_SetView("guildStatus")
		UIDropDownMenu_SetSelectedValue(GuildRosterViewDropdown, "guildStatus") -- Currently not performed in _SetView
	end

	GameTooltip:Hide()
end)

social:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		ToggleFriendsFrame(1)
	elseif button == "RightButton" then
		if not GuildFrame then
			GuildFrame_LoadUI()
		end

		ToggleGuildFrame()
		GuildFrame_TabClicked(GuildFrameTab2)
	end
end)

local BadRequests = {}
local GoodRequests = {}

social:SetScript("OnEvent", function(self, event, addon, ...)
	local msg = ...
	local text, logInOutMsg

	if not (caelUI.myChars or caelUI.herChars) then
		if event == "ADDON_LOADED" then
			if addon == "Blizzard_GuildUI" then
				GuildFrame:HookScript("OnShow", function()
					GuildRoster_SetView("playerStatus")
					UIDropDownMenu_SetSelectedValue(GuildRosterViewDropdown, "playerStatus") -- Currently not performed in _SetView

					GuildFrameTab2:Click()
				end)
				self:UnregisterEvent("ADDON_LOADED")
			end
		end
	end

	if event == "CHAT_MSG_SYSTEM" and msg and (msg:match("^(%S+) has come online%.") or msg:match("^(%S+) has gone offline%.")) then
		logInOutMsg = true
	end

	if event == "GUILD_ROSTER_UPDATE" or logInOutMsg then
		if IsInGuild("player") then
			numGuildMembers = GetNumGuildMembers()
			numOnlineGuildMembers = 0
			for i = 1, numGuildMembers do
				local isOnline = select(9, GetGuildRosterInfo(i))
				if isOnline then
					numOnlineGuildMembers = numOnlineGuildMembers + 1
				end
			end
			numOnlineGuildMembers = numOnlineGuildMembers - 1
		end
	end

	if event == "PLAYER_ENTERING_WORLD" or event == "FRIENDLIST_UPDATE" or logInOutMsg then
		numFriends = GetNumFriends()
		numOnlineFriends = 0

		if numFriends > 0 then
			for i = 1, numFriends do
				local friendIsOnline = select(5, GetFriendInfo(i))
				if friendIsOnline then
					numOnlineFriends = numOnlineFriends + 1
				end
			end
		end
	end

	if event == "BN_CONNECTED" or string.find(event, "BN_FRIEND_INVITE_") then
		for i = 1, BNGetNumFriendInvites() do
			local inviteID, presenceName, isBattleTag, message = BNGetFriendInviteInfo(i)

			if message and message:lower():find("pvpbank") then
				table.insert(BadRequests, inviteID)
			else
				table.insert(GoodRequests, inviteID)
				print("|cffD7BEA5cael|rUI: Accepted friend request from "..presenceName)
			end
		end

		while true do
			local badFriend = table.remove(BadRequests)
			local goodFriend = table.remove(GoodRequests)

			if badFriend then
				BNDeclineFriendInvite(badFriend)
			elseif goodFriend then
				BNAcceptFriendInvite(goodFriend)
			else
				break
			end
		end
	end

	if event == "PLAYER_ENTERING_WORLD" or (string.find(event, "BN_") and not string.find(event, "BN_FRIEND_INVITE")) then
		numBN = BNGetNumFriends()
		numOnlineBN = 0

		if numBN > 0 then
			for i = 1, numBN do
				local BNFriendIsOnline = select(8, BNGetFriendInfo(i))
				if BNFriendIsOnline then
			
					numOnlineBN = numOnlineBN + 1
				end
			end
		end
	end

	if numOnlineGuildMembers > 0 then
		text = string.format("%s %d", (numOnlineFriends > 0 or numOnlineBN > 0) and "|cffD7BEA5g|r" or "|cffD7BEA5guild|r", numOnlineGuildMembers)
	end

	if numOnlineFriends > 0 then
		text = string.format("%s %s %d", (numOnlineGuildMembers > 0) and text or "", (numOnlineGuildMembers > 0 and "- |cffD7BEA5f|r" or numOnlineBN > 0 and "|cffD7BEA5f|r") or (numOnlineFriends > 1 and "|cffD7BEA5friends|r" or "|cffD7BEA5friend|r"), numOnlineFriends)
	end

	if numOnlineBN > 0 then
		text = string.format("%s %s %d", (numOnlineFriends > 0 or numOnlineGuildMembers > 0) and text or "", (numOnlineFriends > 0 or numOnlineGuildMembers > 0) and "- |cffD7BEA5bn|r" or "|cffD7BEA5realid|r", numOnlineBN)
	end

	if numOnlineGuildMembers == 0 and numOnlineFriends == 0 and numOnlineBN == 0 then
		text = ""
	end

	self.text:SetText(text)
end)

for _, event in next, {
	"ADDON_LOADED",
	"CHAT_MSG_SYSTEM",
	"FRIENDLIST_UPDATE",
	"GUILD_ROSTER_UPDATE",
	"PLAYER_ENTERING_WORLD",
	"BN_SELF_ONLINE",
	"BN_FRIEND_ACCOUNT_ONLINE",
	"BN_FRIEND_ACCOUNT_OFFLINE",
	"BN_CONNECTED",
	"BN_DISCONNECTED",
	"BN_FRIEND_INVITE_ADDED",
	"BN_FRIEND_INVITE_LIST_INITIALIZED"
} do
	social:RegisterEvent(event)
end