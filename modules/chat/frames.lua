--[[	$Id: frames.lua 3957 2014-12-02 08:23:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

local _G = getfenv(0)

_G["caelChat"] = caelMedia

caelUI.chatframes = caelUI.createModule("Chatframes")

local chatframes = caelUI.chatframes

local kill = caelUI.kill
local pixelScale = caelUI.scale
local playerClass = caelUI.playerClass

local INVITE_WORD = "inviteraid"

CHAT_TELL_ALERT_TIME = 0 -- sound on every whisper
DEFAULT_CHATFRAME_ALPHA = 0 -- remove mouseover background

-- Hides the new Friends button next to the chatbox (possibly temporary)
FriendsMicroButton:Hide()

local colorize = function(r, g, b)
	if r and b and g then
		caelPanel10:SetBackdropColor(r * 0.5, g * 0.5, b * 0.5, 0.5)
	else
		caelPanel10:SetBackdropColor(0, 0, 0, 0.5)
	end
end

-- Handle the color changes to the chatbox edit frame panel (caelPanel10)
hooksecurefunc("ChatEdit_UpdateHeader", function(editbox)
	if ACTIVE_CHAT_EDIT_BOX then
		local type = editbox:GetAttribute("chatType")
		if type == "CHANNEL" then
			local chatType = GetChannelName(editbox:GetAttribute("channelTarget"))
			if chatType == 0 then
				colorize(0.25, 0.25, 0.25)
			else
				colorize(ChatTypeInfo[type..chatType].r, ChatTypeInfo[type..chatType].g, ChatTypeInfo[type..chatType].b)
			end
		else
			colorize(ChatTypeInfo[type].r, ChatTypeInfo[type].g, ChatTypeInfo[type].b)
		end
	else
		colorize(0.25, 0.25, 0.25)
	end
end)

local mergedTable = {
--	coloredChats values only
	[0] = "CHANNEL5",
	
--	Values which coloredChats and messageGroups have in common.
	[1] = "SAY",
	[2] = "EMOTE",
	[3] = "YELL",
	[4] = "GUILD",
	[5] = "OFFICER",
	[6] = "GUILD_ACHIEVEMENT",
	[7] = "WHISPER",
	[8] = "PARTY",
	[9] = "PARTY_LEADER",
	[10] = "RAID",
	[11] = "RAID_LEADER",
	[12] = "RAID_WARNING",
	[13] = "INSTANCE_CHAT",
	[14] = "INSTANCE_CHAT_LEADER",
	[15] = "ACHIEVEMENT",
	
--	MessageGroups only.
	[16] = "BN_WHISPER",
	[17] = "BN_CONVERSATION",
	[18] = "MONSTER_SAY",
	[19] = "MONSTER_EMOTE",
	[20] = "MONSTER_YELL",
	[21] = "MONSTER_WHISPER",
	[22] = "MONSTER_BOSS_EMOTE",
	[23] = "MONSTER_BOSS_WHISPER",
	[24] = "BG_HORDE",
	[25] = "BG_ALLIANCE",
	[26] = "BG_NEUTRAL",
	[27] = "SYSTEM",
	[28] = "ERRORS",
	[29] = "IGNORED",
	[30] = "CHANNEL",
	[31] = "SKILL",
}

-- Container frame for tab buttons
local cftbb = CreateFrame("Frame", "ChatButtonBar", caelPanel1)

--	Make chat tab flash.
local FlashTab = function(tab, start)
	if start and tab.flash:IsShown() then
			return
	elseif not start and not tab.flash:IsShown() then
			return
	elseif start then
		tab.flash:SetAlpha(0)
		tab.flash.elapsed = 0
		tab.flash:Show()
	else
		tab.flash:Hide()
	end
end

-- FCF override funcs
local GetCurrentChatFrame = function(...)
--	Gets the chat frame which should be currently shown.
	return _G[format("ChatFrame%s", ChatButtonBar.id)]
end

local GetChatFrameID = function(...)
--	Gets the current chat frame's id.
	return ChatButtonBar.id
end

caelChat.GetChatFrameEditBox = function(...)
--	Gets the current chat frame edit box which should be currently active
	return _G[format("ChatFrame%sEditBox", GetChatFrameID())]
end

local ShowChatFrame = function(self)
--	Set required id variables.
	ChatButtonBar.id = self.id
	SELECTED_CHAT_FRAME = _G[format("ChatFrame%s", self.id)]

--	Hide all chat frames
	for i = 1, 4 do
		if i ~= 2 then
			_G[format("ChatButton%s", i)]:SetBackdropColor(0, 0, 0, 0.33)
			_G[format("ChatFrame%s", i)]:Hide()
			_G[format("ChatFrame%sEditBox", i)]:Hide()
		end
	end

--	Make sure tab is not flashing (stop on click)
	FlashTab(self)

--	Change our tab to a colored version so the user can see which tab is selected.
	self:SetBackdropColor(0.84, 0.75, 0.65, 0.5)

	_G[format("ChatFrame%s", self.id)]:Show()
	_G[format("ChatFrame%sEditBox", self.id)]:Show()

	_G[format("ChatFrame%sEditBox", self.id)]:SetFocus()
	_G[format("ChatFrame%sEditBox", self.id)]:ClearFocus()
end

--	Get rid of the pet battle combat log frame.
hooksecurefunc("FCF_OpenTemporaryWindow", function()
	for _, chatFrame in pairs(CHAT_FRAMES) do
		local tempFrame = _G[chatFrame]

		if tempFrame.isTemporary then
			FCF_Close(tempFrame)
		end
	end
end)

local ctddm = CreateFrame("Frame", "ChatTabDropDown")
ctddm.displayMode = "MENU"
ctddm.info = {}
ctddm.initialize = function(self, level)
	local info = self.info
	local id = self.id
	
	if level == 1 then
		wipe(info)
		info.text = "Config"
		info.notCheckable = 1
		info.hasArrow = false
		info.func = function() ShowUIPanel(ChatConfigFrame) end
		UIDropDownMenu_AddButton(info, level)
		wipe(info)
		info.text = "Font Size"
		info.notCheckable = 1
		info.hasArrow = true
		info.value = "FONTSIZE"
		UIDropDownMenu_AddButton(info, level)
	elseif level == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == "FONTSIZE" then
			for _, size in pairs(CHAT_FONT_HEIGHTS) do
				wipe(info)
				info.text = format(FONT_SIZE_TEMPLATE, size)
				info.value = size
				info.func = function()
					FCF_SetChatWindowFontSize(self, _G[format("ChatFrame%s", id)], size)
				end
				local _, currentSize, _ = _G[format("ChatFrame%s", id)]:GetFont()
				if size == floor(currentSize + 0.5) then
					info.checked = 1
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end

chatframes:RegisterEvent("ADDON_LOADED")
chatframes:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			ChatConfigFrame_OnEvent(nil, "PLAYER_ENTERING_WORLD", addon)
			chatframes:UnregisterEvent("ADDON_LOADED")
			for i = 1, NUM_CHAT_WINDOWS do
				local frame = _G[format("ChatFrame%s", i)]
				local cfeb = _G[format("ChatFrame%sEditBox", i)]
				local cfebh = _G[format("ChatFrame%sEditBoxHeader", i)]
				local cft = _G[format("ChatFrame%sTab", i)]
				local cftf = _G[format("ChatFrame%sTabFlash", i)]

				-- kill chat tabs
				cft:EnableMouse(false)
				cft:SetScript("OnEnter", nil)
				cft:SetScript("OnLeave", nil)
				cft.SetAlpha = function() end

				cftf:SetScript("OnShow", nil)
				cftf:SetScript("OnHide", nil)
				cftf:GetRegions():SetTexture(nil)
				--frame:GetRegions():SetTexture(nil)

				-- Removes hover over textures
				kill(_G[format("ChatFrame%sBackground",i)])
				kill(_G[format("ChatFrame%sTopLeftTexture",i)])
				kill(_G[format("ChatFrame%sBottomLeftTexture",i)])
				kill(_G[format("ChatFrame%sBottomRightTexture",i)])
				kill(_G[format("ChatFrame%sTopRightTexture",i)])
				kill(_G[format("ChatFrame%sLeftTexture",i)])
				kill(_G[format("ChatFrame%sRightTexture",i)])
				kill(_G[format("ChatFrame%sBottomTexture",i)])
				kill(_G[format("ChatFrame%sTopTexture",i)])

				-- Removes Default ChatFrame Tabs texture
				kill(_G[format("ChatFrame%sTabGlow", i)])
				kill(_G[format("ChatFrame%sTabLeft", i)])
				kill(_G[format("ChatFrame%sTabMiddle", i)])
				kill(_G[format("ChatFrame%sTabRight", i)])
				kill(_G[format("ChatFrame%sTabText", i)])

				-- Killing off the new chat tab selected feature
				kill(_G[format("ChatFrame%sTabSelectedLeft", i)])
				kill(_G[format("ChatFrame%sTabSelectedMiddle", i)])
				kill(_G[format("ChatFrame%sTabSelectedRight", i)])
				kill(_G[format("ChatFrame%sTabSelectedTop", i)])

				-- Kills off the new method of handling the Chat Frame scroll buttons as well as the resize button
				-- Note: This also needs to include the actual frame textures for the ButtonFrame onHover
				kill(_G[format("ChatFrame%sButtonFrameUpButton", i)])
				kill(_G[format("ChatFrame%sButtonFrameDownButton", i)])
				kill(_G[format("ChatFrame%sButtonFrameBottomButton", i)])
				kill(_G[format("ChatFrame%sResizeButton", i)])
				kill(_G["ChatFrameMenuButton"])

				-- Kills off the retarded new circle around the editbox
				kill(_G[format("ChatFrame%sEditBoxFocusLeft", i)])
				kill(_G[format("ChatFrame%sEditBoxFocusMid", i)])
				kill(_G[format("ChatFrame%sEditBoxFocusRight", i)])

				-- Kill off editbox artwork
				local a, b, c = select(6, cfeb:GetRegions()); kill (a); kill (b); kill (c)

				frame:SetFading(true)
				frame:SetFadeDuration(5)
				frame:SetTimeVisible(30)

				-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen.
				frame:SetClampedToScreen(false)

				-- Allows the arrow keys to be used to move around the chatbox instead of needing to use the alt key.
				cfeb:SetAltArrowKeyMode(false)

				-- Change the positions of the chatframes and editboxes.
				if i ~= 2 then
					frame:SetParent(caelPanel1)
					frame:SetSize(pixelScale(caelPanel1:GetWidth() - 10), pixelScale(caelPanel1:GetHeight() - 16))
--					frame:ClearAllPoints()
--					frame:SetPoint("BOTTOMLEFT", pixelScale(5), pixelScale(10))
					frame:SetMaxLines(1000)
					SetChatWindowSavedDimensions(i, frame:GetWidth(), frame:GetHeight())
					FCF_SavePositionAndDimensions(frame)

					cfeb:SetParent(caelPanel1)
					cfeb:ClearAllPoints()
					cfeb:SetHeight(20)
					cfeb:SetPoint("BOTTOMLEFT",  caelPanel1, "TOPLEFT", 0, pixelScale(1))
					cfeb:SetPoint("BOTTOMRIGHT", caelPanel1, "TOPRIGHT", pixelScale(-90), pixelScale(1))
					cfeb:SetFont(caelMedia.fonts.CHAT_FONT, 11)
					cfebh:SetPoint("LEFT", caelPanel10, pixelScale(5), pixelScale(1))
					cfebh:SetFont(caelMedia.fonts.CHAT_FONT, 11)

					-- Redock the frames together.
					if (i == 1) then
						FCF_DockFrame(frame, frame:GetID())
					else
						FCF_DockFrame(frame, frame:GetID() - 1)
					end
				end

				-- Setup the chatframes

				if (caelUI.myChars or caelUI.herChars) then
					ChatFrame_RemoveAllChannels(frame)
					ChatFrame_RemoveAllMessageGroups(frame)
				end

				if i == 1 then
					FCF_SetWindowName(frame, "• Gen •")

					if (caelUI.myChars or caelUI.herChars) then
						for i = 0, 31 do
							if i < 16 then -- Everything up to 15
								ToggleChatColorNamesByClassGroup(true, mergedTable[i])
							end
							if i > 0 then -- Everything except index 0
								ChatFrame_AddMessageGroup(frame, mergedTable[i])
							end
						end
					end
				elseif i == 2 then
					FCF_SetWindowName(frame, "• Log •")
					FCF_UnDockFrame(frame)
					frame:ClearAllPoints()
					frame:SetParent(caelPanel2)
					frame:SetPoint("TOPLEFT", pixelScale(5), pixelScale(-30))
					frame:SetPoint("BOTTOMRIGHT", pixelScale(-5), pixelScale(-10))
					frame.SetPoint = function() end
					FCF_SetTabPosition(frame, 0)
					frame:SetJustifyH("RIGHT")
					frame:Hide()
					frame:UnregisterEvent("COMBAT_LOG_EVENT")
				elseif i == 3 then
					FCF_SetWindowName(frame, "• w <-> •")

					ChatFrame_AddMessageGroup(frame, "WHISPER")
					ChatFrame_AddMessageGroup(frame, "WHISPER_INFORM")
					ChatFrame_AddMessageGroup(frame, "BN_WHISPER")
					ChatFrame_AddMessageGroup(frame, "BN_WHISPER_INFORM")
				elseif i == 4 then
					FCF_SetWindowName(frame, "• Loot •")

					ChatFrame_AddMessageGroup(frame, "LOOT")
					ChatFrame_AddMessageGroup(frame, "MONEY")
				else
					frame.isInitialized = 0
					FCF_SetTabPosition(frame, 0)
					FCF_Close(frame)
					FCF_UnDockFrame(frame)
					FCF_SetWindowName(frame, "")
					ChatFrame_RemoveAllMessageGroups(frame)
					ChatFrame_RemoveAllChannels(frame)
				end

				-- save original function to alternate name
				cfeb.oldSetTextInsets = cfeb.SetTextInsets
				-- override function to modify values.
				cfeb.SetTextInsets = function(self, left, right, top, bottom)
					left = pixelScale(left - 10)
					top = pixelScale(top - 2)
					-- call original function
					cfeb.oldSetTextInsets(self, left, right, top, bottom)
				end

				cfeb:HookScript("OnHide", function()
					caelPanel10:SetBackdropColor(0, 0, 0, 0.33)
				end)

				if i < 5 then
					FCF_SetChatWindowFontSize(nil, frame, 9)
					FCF_SetWindowColor(frame, 0, 0, 0)
					FCF_SetWindowAlpha(frame, 0)
					frame:SetFrameStrata("LOW")
					--FCF_SetLocked(frame, 1)
					if i ~= 2 then frame:Show() end
				end
			end

--			Custom chat tabs
			local MakeButton = function(id, txt, tip)
				local btn = CreateFrame("Button", format("ChatButton%s", id), cftbb)
				btn.id = id
				btn:SetSize(pixelScale(30), pixelScale(20))
--				If you want them to only show on_enter
--				btn:SetScript("OnEnter", function(...) ChatButtonBar:SetAlpha(1) end)
--				btn:SetScript("OnLeave", function(...) ChatButtonBar:SetAlpha(0) end)
				btn:RegisterForClicks("LeftButtonDown", "RightButtonDown")
				btn:SetScript("OnClick", function(self, button, ...)
					if button == "RightButton" then
						if self.id == ChatButtonBar.id then
							ChatTabDropDown.id = self.id
							ToggleDropDownMenu(1, nil, ChatTabDropDown, "cursor")
						end
					else
						ShowChatFrame(self)
					end
				end)
				btn:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, pixelScale(3))
					GameTooltip:AddLine(tip)
					GameTooltip:Show()
				end)
				btn:SetScript("OnLeave", function()
					GameTooltip:Hide()
				end)
				btn.t = btn:CreateFontString(nil, "OVERLAY")
				btn.t:SetFont(caelMedia.fonts.ADDON_FONT, 9)
				btn.t:SetPoint("CENTER", 0, pixelScale(1))
				btn.t:SetTextColor(1, 1, 1)
				btn.t:SetText(txt)

				btn:SetBackdrop(caelMedia.backdropTable)
				btn:SetBackdropColor(0, 0, 0, 0.33)
				btn:SetBackdropBorderColor(0, 0, 0)

--				Create the flash frame
				btn.flash = CreateFrame("Frame", format("ChatButton%sFlash", id), btn)
				btn.flash:SetAllPoints()
				btn.flash:SetBackdrop(caelMedia.backdropTable)
				btn.flash:SetBackdropColor(0.69, 0.31, 0.31, 0.5)
				btn.flash:SetBackdropBorderColor(0, 0, 0)
				btn.flash.frequency = .025
				btn.flash.elapsed = 0
				btn.flash.isFading = false
				btn.flash:SetScript("OnUpdate", function(self, elapsed)
--					Check if update should happen yet
					self.elapsed = self.elapsed + elapsed
					if self.elapsed <= self.frequency then return end
					self.elapsed = 0

--					Determine if we should fade or not
					local currentAlpha = self:GetAlpha()
					if self.isFading and currentAlpha <= 0 then
						self.isFading = false
					elseif not self.isFading and currentAlpha >= 1 then
						self.isFading = true
					end

--					Change alpha
					self:SetAlpha(currentAlpha + (self.isFading and -.1 or .1))
				end)
--				Stop flashing if player sends an outgoing whisper
				btn.flash:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
				btn.flash:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
				btn.flash:SetScript("OnEvent", function(self, event, ...)
					FlashTab(self:GetParent())
				end)

				btn.flash:Hide()

				btn.skinTop = btn:CreateTexture(nil, "BORDER")
				btn.skinTop:SetTexture(caelMedia.files.bgFile)
				btn.skinTop:SetHeight(pixelScale(4))
				btn.skinTop:SetPoint("TOPLEFT", pixelScale(2), pixelScale(-2))
				btn.skinTop:SetPoint("TOPRIGHT", pixelScale(-2), pixelScale(-2))
				btn.skinTop:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0.84, 0.75, 0.65, 0.5)

				btn.skinBottom = btn:CreateTexture(nil, "BORDER")
				btn.skinBottom:SetTexture(caelMedia.files.bgFile)
				btn.skinBottom:SetHeight(pixelScale(4))
				btn.skinBottom:SetPoint("TOPLEFT", pixelScale(2), pixelScale(-12))
				btn.skinBottom:SetPoint("BOTTOMRIGHT", pixelScale(-2), pixelScale(2))
				btn.skinBottom:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.75, 0, 0, 0, 0)

				return btn
			end

			local cft1 = MakeButton(1, "G", "• Gen •")
--			2 would be combat log, but not for gotChat
			local cft3 = MakeButton(3, "W", "• w <-> •")
			local cft4 = MakeButton(4, "L", "• Loot •")

			cft4:SetPoint("BOTTOMRIGHT", caelPanel1, "TOPRIGHT", 0, 1.5)
			cft3:SetPoint("RIGHT", cft4, "LEFT")
			cft1:SetPoint("RIGHT", cft3, "LEFT")

--			Override old tab bar functions so that we can use our custom buttons to open chat options
			FCF_GetCurrentChatFrameID = GetChatFrameID
			FCF_GetCurrentChatFrame = GetCurrentChatFrame

--			Start with chat frame 1 shown.
			ShowChatFrame(cft1)

--			Prevent Blizzard from changing to chat tab 1 (on instance enter, flight path end etc).
			ChatFrame1:HookScript("OnShow", function()
				if ChatButtonBar.id ~= 1 then
					ShowChatFrame(_G[format("ChatButton%d", ChatButtonBar.id)])
				end
			end)

--			Hook cf3's add message so we can flash.
			local oAddMessage = ChatFrame3.AddMessage
			ChatFrame3.AddMessage = function(...)
--				Flash if tab is not selected.
				if ChatButtonBar.id ~= 3 then
					FlashTab(cft3, true)
				end
				oAddMessage(...)
			end
		end
	end
end)

--	Disable pet battle tab
local old = FCFManager_GetNumDedicatedFrames
function FCFManager_GetNumDedicatedFrames(...)
	return select(1, ...) ~= "PET_BATTLE_COMBAT_LOG" and old(...) or 1
end

local chatStuff = function()
	local _, instanceType = IsInInstance()

	if instanceType ~= "raid" then
		if GetLocale() == "frFR" and not (caelUI.myChars or caelUI.herChars) then
			ChatFrame_AddChannel(ChatFrame1, "Général")
			ChatFrame_AddChannel(ChatFrame1, "Commerce")
		else
			ChatFrame_AddChannel(ChatFrame1, "General")
			ChatFrame_AddChannel(ChatFrame1, "Trade")
		end
	else
		if GetLocale() == "frFR" and not (caelUI.myChars or caelUI.herChars) then
			ChatFrame_RemoveChannel(ChatFrame1, "Général")
		else
			ChatFrame_RemoveChannel(ChatFrame1, "General")
		end
	end
end

local positionDelay = 3
local channelDelay = 10
local colorDelay = 12
local caelChat_OnUpdate = function(self, elapsed)
	if positionDelay then
		positionDelay = positionDelay - elapsed

		if positionDelay <= 0 then
			for i = 1, NUM_CHAT_WINDOWS do
				if i ~= 2 then
					_G[format("ChatFrame%s", i)]:ClearAllPoints()
					_G[format("ChatFrame%s", i)]:SetPoint("BOTTOMLEFT", pixelScale(5), pixelScale(10))
				end
			end
			positionDelay = nil -- This stops the OnUpdate for this timer.
		end
	end

	if channelDelay then
		channelDelay = channelDelay - elapsed

		if channelDelay <= 0 then
			for i = 1, NUM_CHAT_WINDOWS do
				local frame = _G[format("ChatFrame%s", i)]
				if i == 1 then
					chatStuff()
				end
			end
			channelDelay = nil -- This stops the OnUpdate for this timer.
		end
	end

	if colorDelay then
		colorDelay = colorDelay - elapsed

		if colorDelay <= 0 then
			ChangeChatColor("CHANNEL1", 0.55, 0.57, 0.61)
			ChangeChatColor("CHANNEL2", 0.55, 0.57, 0.61)
			ChangeChatColor("CHANNEL5", 0.84, 0.75, 0.65)
			ChangeChatColor("WHISPER", 0.3, 0.6, 0.9)
			ChangeChatColor("WHISPER_INFORM", 0.3, 0.6, 0.9)
--[[
			if (caelUI.myChars or caelUI.herChars) and playerClass == "HUNTER" then
				JoinTemporaryChannel("WeDidHunter")
				ChatFrame_AddChannel(_G.ChatFrame1, "WeDidHunter")
				ChangeChatColor("CHANNEL5", 0.67, 0.83, 0.45)
			elseif (caelUI.myChars or caelUI.herChars) and playerClass == "DRUID" or playerClass == "ROGUE" or playerClass == "WARRIOR" or playerClass == "DEATHKNIGHT" then
				JoinTemporaryChannel("WeDidCaC")
				ChatFrame_AddChannel(_G.ChatFrame1, "WeDidCaC")
				if playerClass == "DRUID" then ChangeChatColor("CHANNEL5", 1, 0.49, 0.04) end
				if playerClass == "ROGUE" then ChangeChatColor("CHANNEL5", 1, 0.96, 0.41) end
				if playerClass == "WARRIOR" then ChangeChatColor("CHANNEL5", 0.78, 0.61, 0.43) end
				if playerClass == "DEATHKNIGHT" then ChangeChatColor("CHANNEL5", 0.77, 0.12, 0.23) end
			end
--]]
			print("|cffD7BEA5cael|rChat: Chatframes setup complete")
			self:SetScript("OnUpdate", nil) -- Done now, nil the OnUpdate completely.
		end
	end
end

local first = true
chatframes:RegisterEvent("PLAYER_ENTERING_WORLD")
chatframes:HookScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		chatStuff()

		if first then
			chatframes:SetScript("OnUpdate", caelChat_OnUpdate)
			first = nil
		end
	end
end)

chatframes:RegisterEvent("CHAT_MSG_WHISPER")
chatframes:RegisterEvent("CHAT_MSG_BN_WHISPER")
chatframes:HookScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
		arg1, arg2 = ...

		if not arg1:sub(1, 3) == "OQ," then -- oQueue whisper spam fix
			PlaySoundFile(caelMedia.files.soundWhisper)
		end

		if (((UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) or (not UnitExists("party1"))) and arg1:lower():match(INVITE_WORD)) then
			InviteUnit(arg2)
		end
	end
end)