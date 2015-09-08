--This mod will expand the functionality of the auto-name generation of blizzards in game mail system to include all your toons you've logged in as, B.Net Friends, and last 10 recently mailed individuals

local _, caelUI = ...

caelUI.automail = caelUI.createModule("AutoMail")

local automail = caelUI.automail

local DB_PLAYER, DB_RECENT, currentPlayer, currentRealm

local origHook = {}

automail:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

function automail:PLAYER_LOGIN()
	
	currentPlayer = UnitName('player')
	currentRealm = GetRealmName()
	
	--do the db initialization
	self:StartupDB()
	
	--increase the mailbox history lines to 15
	SendMailNameEditBox:SetHistoryLines(15)
	
	--do the hooks
	origHook["SendMailFrame_Reset"] = SendMailFrame_Reset
	SendMailFrame_Reset = self.SendMailFrame_Reset
	
	origHook["MailFrameTab_OnClick"] = MailFrameTab_OnClick
	MailFrameTab_OnClick = self.MailFrameTab_OnClick
	
	origHook["AutoComplete_Update"] = AutoComplete_Update
	AutoComplete_Update = self.AutoComplete_Update
	
	origHook[SendMailNameEditBox] = origHook[SendMailNameEditBox] or {}
	origHook[SendMailNameEditBox]["OnEditFocusGained"] = SendMailNameEditBox:GetScript("OnEditFocusGained")
	origHook[SendMailNameEditBox]["OnChar"] = SendMailNameEditBox:GetScript("OnChar")
	SendMailNameEditBox:SetScript("OnEditFocusGained", self.OnEditFocusGained)
	SendMailNameEditBox:SetScript("OnChar", self.OnChar)
	
	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

function automail:StartupDB()
	caelAutoMailDB = caelAutoMailDB or {}
	caelAutoMailDB[currentRealm] = caelAutoMailDB[currentRealm] or {}

	--player list
	caelAutoMailDB[currentRealm]["player"] = caelAutoMailDB[currentRealm]["player"] or {}
	DB_PLAYER = caelAutoMailDB[currentRealm]["player"]
	
	--recent list
	caelAutoMailDB[currentRealm]["recent"] = caelAutoMailDB[currentRealm]["recent"] or {}
	DB_RECENT = caelAutoMailDB[currentRealm]["recent"]
	
	--check for current user
	if DB_PLAYER[currentPlayer] == nil then DB_PLAYER[currentPlayer] = true end
end

--This is called when mailed is sent
function automail:SendMailFrame_Reset()

	--first lets get the playername
	local playerName = strtrim(SendMailNameEditBox:GetText())
	
	--if we don't have something to work with then call original function
	if string.len(playerName) < 1 then
		return origHook["SendMailFrame_Reset"]()
	end
	
	--add the name to the history
	SendMailNameEditBox:AddHistoryLine(playerName)

	--add the name to our recent DB, first check to see if it's already there
	--if so then remove it, otherwise add it to the top of the list and remove the 11 entry from the table.
	--afterwards call the original function
	for k = 1, #DB_RECENT do
		if playerName == DB_RECENT[k] then
			tremove(DB_RECENT, k)
			break
		end
	end
	tinsert(DB_RECENT, 1, playerName)
	for k = #DB_RECENT, 11, -1 do
		tremove(DB_RECENT, k)
	end
	origHook["SendMailFrame_Reset"]()
	
	-- set the name to the auto fill
	SendMailNameEditBox:SetText(playerName)
	SendMailNameEditBox:HighlightText()
end

--this is called when one of the mailtabs is clicked
--we have to autofill the name when the tabs are clicked
function automail:MailFrameTab_OnClick(tab)
	origHook["MailFrameTab_OnClick"](self, tab)
	if tab == 2 then
		local playerName = DB_RECENT[1]
		if playerName and SendMailNameEditBox:GetText() == "" then
			SendMailNameEditBox:SetText(playerName)
			SendMailNameEditBox:HighlightText()
		end
	end
end

--this function is called each time a character is pressed in the playername field of the mail window
function automail:OnChar(...)
	if self:GetUTF8CursorPosition() ~= strlenutf8(self:GetText()) then return end
	local text = strupper(self:GetText())
	local textlen = strlen(text)
	local foundName

	--check player toons
	for k, v in pairs(DB_PLAYER) do
		if strfind(strupper(k), text, 1, 1) == 1 then
			foundName = k
			break
		end
	end

	--check our recent list
	if not foundName then
		for k = 1, #DB_RECENT do
			local playerName = DB_RECENT[k]
			if strfind(strupper(playerName), text, 1, 1) == 1 then
				foundName = playerName
				break
			end
		end
	end

	--Check our RealID friends
	if not foundName then
		local numBNetTotal, numBNetOnline = BNGetNumFriends()
		for i = 1, numBNetOnline do
			local presenceID, givenName, surname, toonName, toonID, client = BNGetFriendInfo(i)
			if (toonName and client == BNET_CLIENT_WOW and CanCooperateWithToon(toonID)) then
				if strfind(strupper(toonName), text, 1, 1) == 1 then
					foundName = toonName
					break
				end
			end
		end
	end

	--call the original onChar to display the dropdown
	origHook[SendMailNameEditBox]["OnChar"](self, ...)
	
	--if we found a name then override the one in the editbox
	if foundName then
		self:SetText(foundName)
		self:HighlightText(textlen, -1)
		self:SetCursorPosition(textlen)
	end

end

function automail:OnEditFocusGained(...)
	SendMailNameEditBox:HighlightText()
end

function automail:AutoComplete_Update(editBoxText, utf8Position, ...)
	if self ~= SendMailNameEditBox then
		origHook["AutoComplete_Update"](self, editBoxText, utf8Position, ...)
	end
end

if IsLoggedIn() then automail:PLAYER_LOGIN() else automail:RegisterEvent("PLAYER_LOGIN") end