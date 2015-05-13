--[[	$Id: autoInvite.lua 3958 2014-12-02 08:23:47Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Auto accept some invites	]]

caelUI.autoinvite = caelUI.createModule("AutoInvite")

local autoinvite = caelUI.autoinvite

local AcceptFriends = true
local AcceptGuild = true

local CanAccept = function(name)
	if AcceptFriends then
		if caelUI.isFriend(name) then
			return true
		end
	end

	if IsInGuild() and AcceptGuild and (not GetGuildInfo("player") == "We Did It" and not GetGuildInfo(name) == "We Did It") then
		if caelUI.isGuild(name) then
			return true
		end
	end
end

autoinvite:RegisterEvent("PARTY_INVITE_REQUEST")
autoinvite:SetScript("OnEvent", function(self, event, name)
	if CanAccept(name) then
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if frame:IsVisible() and frame.which == "PARTY_INVITE" then
				StaticPopup_OnClick(frame, 1)
			end
		end
	else
		SendWho(string.join("", "n-\"", name, "\""))
	end
end)

StaticPopupDialogs["LOOT_BIND"].OnCancel = function(self, slot)
	if GetNumGroupMembers() == 0 then
		ConfirmLootSlot(slot)
	end
end