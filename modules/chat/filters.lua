--[[	$Id: filters.lua 3885 2014-02-26 11:51:17Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.chatfilters = caelUI.createModule("ChatFilters")

local gsub, find, match, lower = string.gsub, string.find, string.match, string.lower

--[	Filter channels join/leave & afk/dnd	]

local noticeChannels = {
	"CHAT_MSG_AFK",
	"CHAT_MSG_DND",
	"CHAT_MSG_CHANNEL_JOIN",
	"CHAT_MSG_CHANNEL_LEAVE",
	"CHAT_MSG_CHANNEL_NOTICE",
	"CHAT_MSG_CHANNEL_NOTICE_USER",
}

local SuppressNotices = function()
	return true
end

for _, event in ipairs(noticeChannels) do
	ChatFrame_AddMessageEventFilter(event, SuppressNotices)
end

--[[	Filter npc spam	]]

local npcChannels = {
	"CHAT_MSG_MONSTER_SAY",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_EMOTE",
}

local isNpcChat = function(self, event, msg, ...)
	local isResting = IsResting()

	if isResting and not msg:find(caelUI.playerName) then
		return true
	end
end

for _, event in ipairs(npcChannels) do
	ChatFrame_AddMessageEventFilter(event, isNpcChat)
end

--[[  Filter various chat spam	]]

local patterns = {
	caelUI.pattern(CLEARED_AFK),
	caelUI.pattern(MARKED_AFK),
	caelUI.pattern(CLEARED_DND),
	caelUI.pattern(MARKED_DND),

	caelUI.pattern(NEW_TITLE_EARNED),
	caelUI.pattern(ERR_FRIEND_ONLINE_SS),
	caelUI.pattern(BN_INLINE_TOAST_FRIEND_ONLINE),
	caelUI.pattern(ERR_FRIEND_OFFLINE_S),
	caelUI.pattern(BN_INLINE_TOAST_FRIEND_OFFLINE),
	caelUI.pattern(ERR_LEARN_SPELL_S),
	caelUI.pattern(ERR_LEARN_ABILITY_S),
	caelUI.pattern(ERR_LEARN_PASSIVE_S),
	caelUI.pattern(ERR_SPELL_UNLEARNED_S),
	caelUI.pattern(ERR_PET_SPELL_UNLEARNED_S),
	caelUI.pattern(ERR_GUILD_INTERNAL),
	caelUI.pattern(ERR_INSTANCE_GROUP_ADDED_S),
	caelUI.pattern(ERR_INSTANCE_GROUP_REMOVED_S),
	caelUI.pattern(ERR_BG_PLAYER_LEFT_S),
	caelUI.pattern(ERR_BG_PLAYER_JOINED_SS),
}

RoleChangedFrame:UnregisterAllEvents()

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(frame, event, message, author, ...)
	for i = 1, #patterns do
		if message:find(patterns[i]) then
			return true
		end
	end

	local realm = gsub(caelUI.playerRealm, " ", "")

	-- Remove player's realm name
	if message:find("-"..realm) then
		return false, gsub(message, "%-"..realm, ""), author, ...
	end
end)

--[[	Filter bossmods	]]

local raidChannels = {
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_WHISPER",
}

local raidSpam = {
	[1] = "%*%*%*",
	[2] = "%<%D%B%M%>",
	[3] = "%<%B%W%>",
	[4] = "^(%S+) fails at moving",
	[5] = "^(%S+) fails at spreading",
	[6] = "^(%S+) fails at not casting",
	[7] = "^(%S+) fails at not attacking",
	[8] = "^(%S+) fails at not being at the wrong place",
	[9] = "PS Died:",
	[10] = "RSC >",
	[11] = "Fatality:",
}

local IsSpam = function(self, event, msg, ...)
	for _, pattern in pairs(raidSpam) do
		if msg:find(pattern) then
			return true
		end
	end
end

for _, pattern in ipairs(raidChannels) do
	ChatFrame_AddMessageEventFilter(pattern, IsSpam)
end

RaidWarningFrame:SetScript("OnEvent", function(self, event, msg)
	if event == "CHAT_MSG_RAID_WARNING" then
		if not msg:find("%*%*%*", 1, false) then
			RaidWarningFrame_OnEvent(self, event, msg)
		end 
	end
end)

--[[	RaidNotice to Scrolling frame	]]

local hooks = {}
hooks["RaidNotice_AddMessage"] = RaidNotice_AddMessage

RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo, ...)
	if noticeFrame and noticeFrame:GetName() ~= "CinematicFrameRaidBossEmoteFrame" then
		if IsAddOnLoaded("caelUI") then
			caelCombatTextAddText("|cffD7BEA5"..textString.."|r", nil, nil, true, "Notification")
		else
			hooks.RaidNotice_AddMessage(noticeFrame, textString, colorInfo, ...)
		end
		PlaySoundFile(caelMedia.files.soundAlarm, "Master")
	end
end

--[=[
--[[	Bosses & monsters emotes to RWF	]]

chatFrames:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
chatFrames.CHAT_MSG_RAID_BOSS_EMOTE = function(self, event, arg1, arg2)
	local string = format(arg1, arg2)
	RaidNotice_AddMessage(RaidWarningFrame, string, ChatTypeInfo["RAID_WARNING"])
end
--]=]

--[[	Filter various crap	]]

local craps = {
	"%[.*%].*anal",
	"anal.*%[.*%]",
}

local FilterFunc = function(_, _, msg, sender, _, _, _, _, chanID)
	if not CanComplainChat(sender) or UnitInParty(sender) or UnitIsInMyGuild(sender) then return end
	
	if chanID == 1 or chanID == 2 then
		msg = lower(msg) --lower all text
		msg = gsub(msg, " ", "") --Remove spaces
		for i, v in ipairs(craps) do
			if find(msg, v) then
				return true
			end
		end
	end

	return false
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", FilterFunc)

--[[	Reformat money messages	]]

local gold = " ".. select(2, strsplit(" ", GOLD_AMOUNT))
local silver = " "..select(2, strsplit(" ", SILVER_AMOUNT))
local copper = " "..select(2, strsplit(" ", COPPER_AMOUNT))

local gColor = "|cffffd700"
local sColor = "|cffc7c7cf"
local cColor = "|cffeda55f"

local function moneyFilter(self, event, msg, ...)
	local newMsg = msg

	newMsg = gsub(newMsg, " deposited to guild bank", "")
	newMsg = gsub(newMsg, " of the loot", "")
	newMsg = gsub(newMsg, gold, "|cffffd700g|r")
	newMsg = gsub(newMsg, silver, "|cffc7c7cfs|r")
	newMsg = gsub(newMsg, copper,"|cffeda55fc|r")

	return false, newMsg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_MONEY", moneyFilter)

--[[	Players spam filter & raid icons filter	]]

local icon, lastMessage

local raidIcons = {
	["{Étoile}"] = "{rt1}",
	["{Rond}"] = "{rt2}",
	["{Losange}"] = "{rt3}",
	["{Triangle}"] = "{rt4}",
	["{Lune}"] = "{rt5}",
	["{Carré}"] = "{rt6}",
	["{Croix}"] = "{rt7}",
	["{Crâne}"] = "{rt8}",
}

local MessageFilter = function(self, event, text, sender, ...)
--	if CanComplainChat(sender) then

	local origSender = sender

	local shortSender, realm = string.split("-", sender)

	if realm then
		sender = shortSender
	end

	if sender ~= caelUI.playerName and not caelUI.isFriend(sender) and not caelUI.isGuild(sender) then
		if not self.repeatMessages or self.repeatCount > 100 then
			self.repeatCount = 0
			self.repeatMessages = {}
		end

		lastMessage = self.repeatMessages[sender]

		if lastMessage == text then
			return true
		end

		self.repeatMessages[sender] = text
		self.repeatCount = self.repeatCount + 1

		for msg in string.gmatch(text, "%b{}") do
			icon = lower(gsub(msg, "[{}]", ""))

--			if ICON_TAG_LIST[icon] and ICON_LIST[ICON_TAG_LIST[icon]] then
			if icon then
				text = gsub(text, msg, "")
			end
		end
	end

	for french, english in pairs(raidIcons) do
		if text:find(french) then
			text = gsub(text, french, english)
		elseif text:find(lower(french)) then
			text = gsub(text, lower(french), english)
		end
	end

	return false, text, origSender, ...
end

for _, chatEvent in next, {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_SAY",
	"CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_YELL",
} do
	ChatFrame_AddMessageEventFilter(chatEvent, MessageFilter)
end

--[[
caelUI.chatfilters:RegisterEvent("CHAT_MSG_SYSTEM")
caelUI.chatfilters:SetScript("OnEvent", function(self, event, msg)
	if event == "CHAT_MSG_SYSTEM" then
		local newComer = msg:find("^(%S+) has joined the guild%.")

		if newComer and caelUI.herChars then
			SendChatMessage("Bienvenue", "GUILD", GetDefaultLanguage("player"))
		end
	end
end)

local AutoGG = function(self, event, text, sender)
	if not (UnitInRaid(sender) or UnitInGroup(sender)) and sender ~= caelUI.playerName then
		SendChatMessage("gg", "GUILD", GetDefaultLanguage("player"))
	end
end

if (caelUI.myChars or caelUI.herChars) then
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", AutoGG)
end
--]]