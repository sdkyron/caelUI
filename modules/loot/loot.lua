--[[	$Id: loot.lua 3983 2015-01-26 10:18:34Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.loot = caelUI.createModule("Loot")

local pixelScale, playerName = caelUI.scale, caelUI.playerName

local curSlot
local curLootSlots = {}

local destroyList = {
	[20406]	=	true,	-- Twilight Cultist Mantle
	[20407]	=	true,	-- Twilight Cultist Robe
	[20408]	=	true,	-- Twilight Cultist Cowl
}

local exceptionList = {
	[41109] = true,		-- Glyph of Light of Dawn
	[92501] = true,		-- A note from Chen Stormstout
	[114002] = true,		-- Encoded Message (Blingtron 5000)
}

local openList = {
	[32724]	=	true,	-- Sludge-covered Object
	[33857]	=	true,	-- Crate of Meat
	[33844]	=	true,	-- Barrel of Fish
	[9276]	=	true,	-- Pirate's Footlocker
	[35313]	=	true,	-- Bloated Barbed Gill Trout
	[35232]	=	true,	-- Shattered Sun Supplies
	[34863]	=	true,	-- Bag of Fishing Treasures
	[110278]	=	true,	-- Engorged Stomach
}

local needList = {
	[33865]	=	true,	-- Amani Hex Stick 
}

local greedList = {
	[32428]	=	true,	-- Heart of Darkness
	[32897]	=	true,	-- Mark of the Illidari
	[34664]	=	true,	-- Sunmote
	[43102]	=	true,	-- Frozen Orb
	[45087]	=	true,	-- Runed Orb
	[47556]	=	true,	-- Crusader Orb
	[52078]	=	true,	-- Chaos Orb
	[68729]	=	true,	-- Elementium Lockbox (Can't roll need on this)
	[71998]	=	true,	-- Essence of Destruction
	[88567]	=	true,	-- Ghost Iron Lockbox (Can't roll need on this)
	[116920]	=	true,	-- True Steel Lockbox (Can't roll need on this)
}

local lockBoxes = {
	[4632]	=	true,	-- Ornate Bronze Lockbox
	[4633]	=	true,	-- Heavy Bronze Lockbox
	[4634]	=	true,	-- Iron Lockbox
	[4636]	=	true,	-- Strong Iron Lockbox
	[4637]	=	true,	-- Steel Lockbox
	[4638]	=	true,	-- Reinforced Steel Lockbox
	[5758]	=	true,	-- Mithril Lockbox
	[5759]	=	true,	-- Thorium Lockbox
	[5760]	=	true,	-- Eternium Lockbox
	[31952]	=	true,	-- Khorium Lockbox
	[43622]	=	true,	-- Froststeel Lockbox
}

caelUI.loot:SetScript("OnEvent", function(self, event, id)
	if event == "PLAYER_ENTERING_WORLD" then
		for _, object in pairs({LootFrame:GetRegions()}) do
			caelUI.kill(object)
		end

		LootFrameInset:Hide()

		LootFrame:EnableMouseWheel(true)
		LootFrame:SetHitRectInsets(0, 0, 0, 0)

		LootFrame:SetScale(0.85)
		LootFrame:SetSize(160, 180)

		LootFrame:SetBackdrop(caelMedia.backdropTable)
		LootFrame:SetBackdropColor(0, 0, 0, 0.33)
		LootFrame:SetBackdropBorderColor(0, 0, 0)

		local width = pixelScale(LootFrame:GetWidth() - 6)
		local height = pixelScale(LootFrame:GetHeight() / 5)

		local gradientTop = LootFrame:CreateTexture(nil, "BORDER")
		gradientTop:SetTexture(caelMedia.files.bgFile)
		gradientTop:SetSize(width, height)
		gradientTop:SetPoint("TOPLEFT", caelUI.scale(3), caelUI.scale(-3))
		gradientTop:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0.84, 0.75, 0.65, 0.5)

		local gradientBottom = LootFrame:CreateTexture(nil, "BORDER")
		gradientBottom:SetTexture(caelMedia.files.bgFile)
		gradientBottom:SetSize(width, height)
		gradientBottom:SetPoint("BOTTOMRIGHT", caelUI.scale(-3), caelUI.scale(3))
		gradientBottom:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.75, 0, 0, 0, 0)

		LootFrame:SetScript("OnMouseWheel", function(self, direction)
			if LootFrameUpButton:IsShown() then
				LootFrameUpButton:Click()
			elseif LootFrameDownButton:IsShown() then
				LootFrameDownButton:Click()
			end
		end)

		LootFrame:Hide()

		LootFrameCloseButton:SetPoint("TOPRIGHT", pixelScale(2), pixelScale(2))

		for i = 1, LOOTFRAME_NUMBUTTONS do
			local lootButton = _G[format("LootButton%d", i)]
			local icon = _G[format("LootButton%d%s", i, "IconTexture")]
			local quest =_G[format("LootButton%d%s", i, "IconQuestTexture")]
			local text = _G[format("LootButton%d%s", i, "Text")]
			local background = _G[format("LootButton%d%s", i, "NameFrame")]

			lootButton:ClearAllPoints()
			lootButton:SetHeight(pixelScale(28))
			lootButton:SetWidth(pixelScale(28))

			if i == 1 then
				lootButton:SetPoint("TOPLEFT", pixelScale(10), pixelScale(-25))
			else
				lootButton:SetPoint("TOP", _G[format("LootButton%d", i-1)], "BOTTOM", 0, pixelScale(-10))
			end

			lootButton:SetNormalTexture(caelMedia.files.buttonNormal)
			lootButton:GetNormalTexture():SetPoint("TOPLEFT", pixelScale(-5), pixelScale(5))
			lootButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", pixelScale(5), pixelScale(-5))

			lootButton:SetHighlightTexture(caelMedia.files.buttonHighlight)
			lootButton:GetHighlightTexture():SetPoint("TOPLEFT", pixelScale(-5), pixelScale(5))
			lootButton:GetHighlightTexture():SetPoint("BOTTOMRIGHT", pixelScale(5), pixelScale(-5))

			lootButton:SetPushedTexture(nil)
			lootButton:SetDisabledTexture(nil)

			if not lootButton.doneScript then
				lootButton:HookScript("OnEnter", function(self)
					GameTooltip:SetOwner(LootFrame, "ANCHOR_NONE")
					GameTooltip:SetPoint("TOPLEFT", LootFrame, "TOPRIGHT", pixelScale(3), 0)
					GameTooltip:SetLootItem(self.slot)
				end)
				lootButton.donescript = true
			end

			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			quest:SetPoint("TOPLEFT")
			quest:SetPoint("BOTTOMRIGHT", 0, pixelScale(1))
			quest:SetTexCoord(0.05, 0.95, 0.05, 0.95)

			text:SetHeight(lootButton:GetHeight())
			text:SetPoint("TOPLEFT", lootButton, "TOPRIGHT" , pixelScale(5), 0)
			text:SetPoint("RIGHT", self, pixelScale(-5), 0)

			background:SetTexture(nil)

			LootFrameUpButton:SetSize(0.01, 0.01)
			LootFrameDownButton:SetSize(0.01, 0.01)
		end
	elseif event == "START_LOOT_ROLL" then
		local _, instanceType = IsInInstance()
			if instanceType == "party" or instanceType == "scenario" or instanceType == "raid" then
				local _, name, _, quality, BoP, _, _, canDE = GetLootRollItemInfo(id)

				if (caelUI.myChars or caelUI.herChars) and id then
					for k, v in pairs(needList) do
						if name == select(1, GetItemInfo(k)) then
							RollOnLoot(id, 1)
						end
					end

					for k, v in pairs(greedList) do
						if name == select(1, GetItemInfo(k)) then
							RollOnLoot(id, 2)
						end
					end

					if caelUI.playerClass == "ROGUE" then
						for k, v in pairs(lockBoxes) do
							if name == select(1, GetItemInfo(k)) then
								RollOnLoot(id, 1)
							end
						end
					end

--					if UnitLevel("player") ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] then return end

--					if quality == 2 and not BoP and not IsEquippableItem(id) then -- or (quality == 3 and (caelUI.myChars or caelUI.herChars) and caelUI.iLvl >= 355) then
--						RollOnLoot(id, canDE and 3 or 2)
--					end
				end
			end
	elseif event == "UNIT_INVENTORY_CHANGED" then
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local item = GetContainerItemLink(bag, slot)
				if item then
					local itemName, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(item)

					local itemId = item:match("|c%x+|Hitem:(%d+):.+")

					if openList[tonumber(itemId)] then
							UseContainerItem(bag, slot)
					end

					for k, v in pairs(destroyList) do
						if strfind(item, k) then
							PickupContainerItem(bag, slot)
							DeleteCursorItem()
						end
					end

					if itemRarity == 0 and itemSellPrice < 1e4 and not exceptionList[tonumber(itemId)] then
						PickupContainerItem(bag, slot)
						DeleteCursorItem()
					end
				end
			end
		end
	end

	for i = 1, STATICPOPUP_NUMDIALOGS do
		local frame = _G["StaticPopup"..i]

		if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then
			StaticPopup_OnClick(frame, 1)
		end
	end

	if GetNumGroupMembers() == 0 then
		if event == "LOOT_BIND_CONFIRM" then
			StaticPopup_Hide("LOOT_BIND")
			curLootSlots[#curLootSlots + 1] = id

			self:SetScript("OnUpdate", function(self)
				for _, v in ipairs(curLootSlots) do
					curSlot = v
					ConfirmLootSlot(v)
					print(format("|cffD7BEA5cael|rLoot: Recieved %s", GetLootSlotLink(v)))
				end
				self:SetScript("OnUpdate", nil)
			end)
		elseif event == "LOOT_SLOT_CLEARED" then
			for i, v in ipairs(curLootSlots) do
				if v == curSlot then
					curLootSlots[i] = nil
					curSlot = nil
				end
			end
		end
	end
end)

LootFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("LEFT", UIParent, pixelScale(5), 0)

end)

LootHistoryFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", pixelScale(-5), pixelScale(160))

end)

BonusRollFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("TOP", UIParent, "TOP", 0, pixelScale(-360))
	self:SetScale(0.85)
end)

local RepositionLootFrames = function()
	local frame

	frame = _G["GroupLootContainer"]

	if frame then
		frame:ClearAllPoints()
		frame:SetPoint("TOPRIGHT", UIParent, "RIGHT", pixelScale(-5), 0) -- ("BOTTOM", caelPanel3, "TOP", 0, pixelScale(40))
		frame:SetScale(0.75)
	end

	for i = 1, NUM_GROUP_LOOT_FRAMES do
		frame = _G[format("GroupLootFrame%d", i)]

		if i == 1 then
			if frame then
				frame:ClearAllPoints()
				frame:SetPoint("TOPRIGHT", UIParent, "RIGHT", pixelScale(-5), 0) -- ("BOTTOM", caelPanel3, "TOP", 0, pixelScale(40))
				frame:SetScale(0.85)
			end
		elseif i > 1 then
			if frame then
				frame:ClearAllPoints()
				frame:SetPoint("TOP", "GroupLootFrame"..(i - 1), "BOTTOM", 0, pixelScale(-10)) -- ("BOTTOM", "GroupLootFrame"..(i - 1), "TOP", 0, pixelScale(10))
				frame:SetScale(0.85)
			end
		end
	end

	for i = 1, #LOOT_WON_ALERT_FRAMES do
		frame = _G[format("LootWonAlertFrame%d", i)]

		if i == 1 then
			if frame then
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOM", caelPanel3, "TOP", 0, pixelScale(5))
				frame:SetScale(0.85)
			elseif i > 1 then
				if frame then
					frame:ClearAllPoints()
					frame:SetPoint("TOP", "LootWonAlertFrame"..(i - 1), "BOTTOM", 0, pixelScale(-10))
					frame:SetScale(0.85)
				end
			end
		end
	end
end

hooksecurefunc("GroupLootContainer_OnLoad", RepositionLootFrames)
hooksecurefunc("GroupLootContainer_RemoveFrame", RepositionLootFrames)
hooksecurefunc("GroupLootFrame_OnShow", RepositionLootFrames)
hooksecurefunc("GroupLootFrame_OpenNewFrame", RepositionLootFrames)
hooksecurefunc("GroupLootFrame_OnEvent", RepositionLootFrames)
hooksecurefunc("GroupLootContainer_Update", RepositionLootFrames)
hooksecurefunc("AlertFrame_FixAnchors", RepositionLootFrames)

for _, event in next, {
	"CONFIRM_DISENCHANT_ROLL",
	"CONFIRM_LOOT_ROLL",
	"LOOT_BIND_CONFIRM",
	"LOOT_SLOT_CLEARED",
	"PLAYER_ENTERING_WORLD",
	"START_LOOT_ROLL",
	"UNIT_INVENTORY_CHANGED",
} do
	caelUI.loot:RegisterEvent(event)
end

--[[
local newOnShow = function(self, ...)
	self:ClearAllPoints()
	if self:GetName() == "GroupLootFrame1" then
		self:SetPoint("BOTTOM", caelPanel3, "TOP", 0, pixelScale(40))
		self.SetPoint = caelUI.dummy
	else
		local _, _, num = self:GetName():find("GroupLootFrame(%d)")
		self:SetPoint("BOTTOM", _G[format("GroupLootFrame%d", num - 1)], "TOP", 0, pixelScale(10))
	end

	self:SetScale(0.75)

	if self.oldOnShow then
		self:oldOnShow(...)
	end
end

for i = 1, NUM_GROUP_LOOT_FRAMES do
	local frame = _G[format("GroupLootFrame%d", i)]
	frame.oldOnShow = frame:GetScript("OnShow")
	frame:SetScript("OnShow", newOnShow)
end
--]]