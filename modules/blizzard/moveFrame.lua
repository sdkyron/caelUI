--[[	$Id: moveFrame.lua 3782 2013-12-08 23:52:06Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.move = caelUI.createModule("Frame Mover")

local frames = {
	"CharacterFrame", "SpellBookFrame", "PVPFrame", "TaxiFrame", "QuestFrame", "PVEFrame",
	"QuestLogFrame", "QuestLogDetailFrame", "MerchantFrame", "TradeFrame", "MailFrame",
	"FriendsFrame", "CinematicFrame", "TabardFrame", "PVPBannerFrame", "PetStableFrame",
	"GuildRegistrarFrame", "PetitionFrame", "HelpFrame", "GossipFrame", "DressUpFrame",
	"WorldStateScoreFrame", "ChatConfigFrame", "RaidBrowserFrame", "InterfaceOptionsFrame",
	"GameMenuFrame", "VideoOptionsFrame", "GuildInviteFrame", "ItemTextFrame", "BankFrame",
	"OpenMailFrame", "LootFrame", "StackSplitFrame", "MacOptionsFrame", "TutorialFrame",
	"StaticPopup1", "StaticPopup2", "MissingLootFrame", "ScrollOfResurrectionSelectionFrame"
}

local lodFrames = {
	["Blizzard_AchievementUI"] = {
		"AchievementFrame"
	},
	["Blizzard_AuctionUI"] = {
		"AuctionFrame"
	},
	["Blizzard_GuildUI"] = {
		"GuildFrame"
	},
	["Blizzard_TalentUI"] = {
		"PlayerTalentFrame"
	},
	["Blizzard_ItemAlterationUI"] = {
		"TransmogrifyFrame"
	}
}

for _, v in ipairs(frames) do
	if _G[v] then
		_G[v]:EnableMouse(true)
		_G[v]:SetMovable(true)
		_G[v]:SetUserPlaced(false)
		_G[v]:SetClampedToScreen(true)
		_G[v]:RegisterForDrag("LeftButton")
		_G[v]:SetScript("OnDragStart", function(self) self:StartMoving() end)
		_G[v]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	end
end

caelUI.move:RegisterEvent("ADDON_LOADED")
caelUI.move:SetScript("OnEvent", function(self, event, addonLoaded)
	if lodFrames[addonLoaded] then
		for k, v in pairs(lodFrames[addonLoaded]) do
			_G[v]:EnableMouse(true)
			_G[v]:SetMovable(true)
			_G[v]:SetUserPlaced(false)
			_G[v]:SetClampedToScreen(true)
			_G[v]:RegisterForDrag("LeftButton")
			_G[v]:SetScript("OnDragStart", function(self) self:StartMoving() end)
			_G[v]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		end
	end
end)