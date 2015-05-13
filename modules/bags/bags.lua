--[[	$Id: bags.lua 3884 2014-02-24 18:38:11Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.bags = caelUI.createModule("Bags")

_G["caelBags"] = caelUI.bags

local dummy, kill, pixelScale = caelUI.dummy, caelUI.kill, caelUI.scale

local bags = {
	bag = {
		CharacterBag0Slot,
		CharacterBag1Slot,
		CharacterBag2Slot,
		CharacterBag3Slot
	}
}

local numBagColumns = 10
local numBankColumns = 20
local buttonSize = 28
local buttonSpacing = -2
local bottomMargin = 30

UpdateContainerFrameAnchors = dummy

caelBags.SkinButton = function(button)
	button:SetSize(pixelScale(54), pixelScale(18))
	button:SetNormalFontObject(GameFontNormalSmall)
--	button:SetNormalTexture(caelMedia.files.buttonNormal)
--	button:SetPushedTexture(caelMedia.files.buttonPushed)
--	button:SetHighlightTexture(caelMedia.files.buttonHighlight, "ADD")
	button:SetBackdrop(caelMedia.backdropTable)
	button:SetBackdropColor(0, 0, 0, 0.7)
	button:SetBackdropBorderColor(0, 0, 0)
end
	
caelBags.CreateToggleButton = function (name, caption, parent)
	local button = CreateFrame("Button", name, parent, nil)
	button:SetText(caption)
	caelBags.SkinButton(button)
	
	return button
end

local Create = function(frame)
	local Container = CreateFrame("Frame", "caelBags_"..frame, UIParent)

	if frame == "bag" then 
		Container:SetWidth(pixelScale(((buttonSize + buttonSpacing) * numBagColumns) + 10  - buttonSpacing))
		Container:SetPoint("TOPRIGHT", UIParent, "RIGHT", pixelScale(-35), pixelScale(168))
	else
		Container:SetWidth(pixelScale(((buttonSize + buttonSpacing) * numBankColumns) + 16 - buttonSpacing))
		Container:SetPoint("BOTTOMRIGHT", caelBags_bag, "BOTTOMLEFT", pixelScale(-5), 0)
	end

	Container:SetFrameStrata("HIGH")
	Container:SetBackdrop(caelMedia.backdropTable)
	Container:SetBackdropColor(0, 0, 0, 0.7)
	Container:SetBackdropBorderColor(0, 0, 0)
	Container:SetFrameLevel(1)

	Container:Hide()
	
	Container:SetClampedToScreen(true)
   Container:SetMovable(true)
	Container:EnableMouse(true)
	Container:RegisterForDrag("LeftButton", "RightButton")
	Container:SetScript("OnDragStart", function(self) self:StartMoving() Container:SetUserPlaced(false) end)
	Container:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	local BagFrame = CreateFrame('Frame', "caelBags_"..frame.."_bags")
	BagFrame:SetParent("caelBags_"..frame)
	BagFrame:SetSize(10, 10)
	BagFrame:SetPoint("TOPRIGHT", "caelBags_"..frame, "BOTTOMRIGHT", 0, pixelScale(-5))
	BagFrame:Hide()

	local SortButton = caelBags.CreateToggleButton("sortButton", "Sort", caelBags_bag)
	SortButton:SetParent("caelBags_"..frame)
	SortButton:SetSize(pixelScale(32), pixelScale(18))
	SortButton:SetPoint("BOTTOMRIGHT", "caelBags_"..frame, "BOTTOMRIGHT", pixelScale(-55), pixelScale(5))
	SortButton:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	SortButton:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			if frame == "bag" then
				BagSort(0)
			else
				BankSort(0)
			end
		else
			if frame == "bag" then
				BagSort(1)
			else
				BankSort(1)
			end
		end
	end)
end

Create("bag")
Create("bank")

local Skin = function(index, frame)
	for i = 1, index do
      local bag = _G[frame..i]
		local itemCount = _G[bag:GetName().."Count"]
		local normalTexture = _G[bag:GetName().."NormalTexture"]
		local iconTexture = _G[bag:GetName().."IconTexture"]
		local questTexture = _G[bag:GetName().."IconQuestTexture"]
		local coolDown = _G[bag:GetName().."Cooldown"]
		local junkIcon = bag.JunkIcon
		local iconBorder = bag.IconBorder
		local battlePay = bag.BattlepayItemTexture

		iconBorder:SetAlpha(0)

		if questTexture then
			questTexture:SetAlpha(0)
		end

		if junkIcon then
			junkIcon:SetAlpha(0)
		end

		if battlePay then
			battlePay:SetAlpha(0)
		end

		normalTexture:SetHeight(buttonSize)
		normalTexture:SetWidth(buttonSize)
		normalTexture:ClearAllPoints()
		normalTexture:SetPoint("CENTER")
		normalTexture:SetVertexColor(0.25, 0.25, 0.25)

      bag:SetNormalTexture(caelMedia.files.buttonNormal)
      bag:SetPushedTexture(caelMedia.files.buttonPushed)
		bag:SetHighlightTexture(caelMedia.files.buttonHighlight)

		border = bag:CreateTexture(nil, "OVERLAY")
		border:SetTexture(caelMedia.files.buttonNormal)
		border:SetAllPoints()
		border:SetVertexColor(0.25, 0.25, 0.25)

		iconTexture:SetTexCoord(.08, .92, .08, .92)
		iconTexture:ClearAllPoints()
		iconTexture:SetPoint("TOPLEFT", bag, pixelScale(4), pixelScale(-3))
		iconTexture:SetPoint("BOTTOMRIGHT", bag, pixelScale(-3), pixelScale(4))

		coolDown:ClearAllPoints()
		coolDown:SetPoint("TOPLEFT", bag, pixelScale(4), pixelScale(-3))
		coolDown:SetPoint("BOTTOMRIGHT", bag, pixelScale(-3), pixelScale(4))

		itemCount:ClearAllPoints()
		itemCount:SetPoint("BOTTOMRIGHT", bag, pixelScale(-3), pixelScale(3))
		itemCount:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 10, "OUTLINE")

		bag.border = border
    end
end

Skin(28, "BankFrameItem")

for i = 1, 12 do
	_G["ContainerFrame"..i.."CloseButton"]:Hide()
	_G["ContainerFrame"..i.."PortraitButton"]:Hide()
	_G["ContainerFrame"..i]:EnableMouse(false)

	Skin(36, "ContainerFrame"..i.."Item")

	for p = 1, 7 do
		select(p, _G["ContainerFrame"..i]:GetRegions()):SetAlpha(0)
    end
end

ContainerFrame1Item1:SetScript("OnHide", function() 
	_G["caelBags_bag"]:Hide()
end)

BankFrameItem1:SetScript("OnHide", function() 
	_G["caelBags_bank"]:Hide()
end)

BankFrameItem1:SetScript("OnShow", function() 
	_G["caelBags_bank"]:Show()
end)

-- Fix token frame glitch
BackpackTokenFrame:Hide()
BackpackTokenFrame.Show = dummy

-- Trash some BankFrame functionality.
BankFrame:EnableMouse(false)
BankFrame:SetSize(0.01, 0.01)
BankFrameCloseButton:Hide()

BankFrameMoneyFrameInset:Hide()
BankFrameMoneyFrameBorder:Hide()

BankFramePurchaseInfo:Hide()
BankFramePurchaseInfo.Show = dummy

BankFrameMoneyFrame:Hide()
BankFrameMoneyFrame.Show = dummy

BankSlotsFrame:DisableDrawLayer("BORDER")

BagItemAutoSortButton:EnableMouse(false)
BagItemAutoSortButton:SetAlpha(0)
BankItemAutoSortButton:EnableMouse(false)
BankItemAutoSortButton:SetAlpha(0)

for i = 1, 7 do 
	BankSlotsFrame["Bag"..i]:Hide()
end

for i = 1, 2 do
	local Tab = _G["BankFrameTab"..i]
	Tab:Hide()
end

-- And finally trash some BankFrame textures. Rock on!
for i = 1, select('#', BankFrame:GetRegions()) do
	select(i, BankFrame:GetRegions()):SetAlpha(0)
end

local SkinEditBox = function(frame)
	frame:ClearAllPoints()
	frame:SetSize(pixelScale(4 * (buttonSpacing + buttonSize) -3), pixelScale(18))

	frame:SetBackdrop(caelMedia.backdropTable)
	frame:SetBackdropColor(0, 0, 0, 0.7)
	frame:SetBackdropBorderColor(0, 0, 0)

	BagItemSearchBox:SetPoint("BOTTOMLEFT", _G["caelBags_bag"], pixelScale(5), pixelScale(5))
	BankItemSearchBox:SetPoint("BOTTOMLEFT", _G["caelBags_bank"], pixelScale(5), pixelScale(5))

	if frame.Left then kill(frame.Left) end
	if frame.Middle then kill(frame.Middle) end
	if frame.Right then kill(frame.Right) end
	if frame.Mid then kill(frame.Mid) end

	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(2)
end

SkinEditBox(BagItemSearchBox)
SkinEditBox(BankItemSearchBox)

-- Centralize and rewrite bag rendering function
function ContainerFrame_GenerateFrame(frame, size, id)
	frame.size = size

	for i = 1, size, 1 do
		local index = size - i + 1
		local itemButton = _G[frame:GetName().."Item"..i]
		itemButton:SetID(index)
		itemButton:Show()
	end

	frame:SetID(id)
	frame:Show()

	local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1

	for bag = 1, 5 do
		local slots = GetContainerNumSlots(bag - 1)
		for item = slots, 1, -1 do
			local itemframes = _G["ContainerFrame"..bag.."Item"..item]
			itemframes:ClearAllPoints()
			itemframes:SetWidth(buttonSize)
			itemframes:SetHeight(buttonSize)
			itemframes:SetFrameStrata("HIGH")
			itemframes:SetFrameLevel(2)

			if bag == 1 and item == 16 then
				itemframes:SetPoint("TOPLEFT", _G["caelBags_bag"], "TOPLEFT", pixelScale(5), pixelScale(-5))
				lastrowbutton = itemframes
				lastbutton = itemframes
			elseif numbuttons == numBagColumns then
				itemframes:SetPoint("TOPRIGHT", lastrowbutton, 0, pixelScale(-(buttonSpacing + buttonSize)))
				itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, 0, pixelScale(-(buttonSpacing + buttonSize)))
				lastrowbutton = itemframes
				numrows = numrows + 1
				numbuttons = 1
			else
				itemframes:SetPoint("TOPRIGHT", lastbutton, pixelScale((buttonSpacing + buttonSize)), 0)
				itemframes:SetPoint("BOTTOMLEFT", lastbutton, pixelScale((buttonSpacing + buttonSize)), 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = itemframes
		end
	end
	_G["caelBags_bag"]:SetHeight(pixelScale((((buttonSize + buttonSpacing) * (numrows + 1)) - buttonSpacing) + bottomMargin))

	local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1

	for bank = 1, 28 do
		local bankitems = _G["BankFrameItem"..bank]
		bankitems:ClearAllPoints()
		bankitems:SetWidth(buttonSize)
		bankitems:SetHeight(buttonSize)
		bankitems:SetFrameStrata("HIGH")
		bankitems:SetFrameLevel(2)

		if bank == 1 then
			bankitems:SetPoint("TOPLEFT", _G["caelBags_bank"], "TOPLEFT", 5, -5)
			lastrowbutton = bankitems
			lastbutton = bankitems
		elseif numbuttons == numBankColumns then
			bankitems:SetPoint("TOPRIGHT", lastrowbutton, 0, pixelScale(-(buttonSpacing + buttonSize)))
			bankitems:SetPoint("BOTTOMLEFT", lastrowbutton, 0, pixelScale(-(buttonSpacing + buttonSize)))
			lastrowbutton = bankitems
			numrows = numrows + 1
			numbuttons = 1
		else
			bankitems:SetPoint("TOPRIGHT", lastbutton, pixelScale((buttonSpacing+buttonSize)), 0)
			bankitems:SetPoint("BOTTOMLEFT", lastbutton, pixelScale((buttonSpacing+buttonSize)), 0)
			numbuttons = numbuttons + 1
		end
		lastbutton = bankitems
	end

	for bag = 6, 12 do
		local slots = GetContainerNumSlots(bag - 1)

		for item = slots, 1, -1 do
			local itemframes = _G["ContainerFrame"..bag.."Item"..item]
			itemframes:ClearAllPoints()
			itemframes:SetWidth(buttonSize)
			itemframes:SetHeight(buttonSize)
			itemframes:SetFrameStrata("HIGH")
			itemframes:SetFrameLevel(2)

			if numbuttons == numBankColumns then
				itemframes:SetPoint("TOPRIGHT", lastrowbutton, 0, pixelScale(-(buttonSpacing+buttonSize)))
				itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, 0, pixelScale(-(buttonSpacing+buttonSize)))
				lastrowbutton = itemframes
				numrows = numrows + 1
				numbuttons = 1
			else
				itemframes:SetPoint("TOPRIGHT", lastbutton, pixelScale((buttonSpacing+buttonSize)), 0)
				itemframes:SetPoint("BOTTOMLEFT", lastbutton, pixelScale((buttonSpacing+buttonSize)), 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = itemframes
		end
	end

	_G["caelBags_bank"]:SetHeight(pixelScale((((buttonSize + buttonSpacing) * (numrows + 1)) - buttonSpacing) + bottomMargin))
end

ToggleAllBags = function()
	if not UIParent:IsShown() then return end

	local bagsOpen = 0
	local totalBags = 1

	if IsBagOpen(0) then
		bagsOpen = bagsOpen + 1
		CloseBackpack()
	end

	for i = 1, NUM_BAG_FRAMES, 1 do
		if GetContainerNumSlots(i) > 0 then		
			totalBags = totalBags + 1
		end

		if IsBagOpen(i) then
			CloseBag(i)
			bagsOpen = bagsOpen + 1
		end
	end

	if bagsOpen < totalBags then
		OpenBackpack()
		for i = 1, NUM_BAG_FRAMES, 1 do
			OpenBag(i)
			_G["caelBags_bag"]:Show()
		end
	end
end

OpenAllBags = function(frame)
	if not UIParent:IsShown() then
		return
	end
	
	for i = 0, NUM_BAG_FRAMES, 1 do
		if IsBagOpen(i) then
			return
		end
	end

	if frame and not FRAME_THAT_OPENED_BAGS then
		FRAME_THAT_OPENED_BAGS = frame:GetName()
	end

	OpenBackpack()

	for i = 1, NUM_BAG_FRAMES, 1 do
		OpenBag(i)
		_G["caelBags_bag"]:Show()
	end
end

caelBags:RegisterEvent("BANKFRAME_OPENED")
caelBags:SetScript("OnEvent", function()
	for i = NUM_BAG_FRAMES + 1, NUM_CONTAINER_FRAMES, 1 do
		OpenBag(i)
	end
end)

local isQuestItem, questId, questTexture, itemLink, rarity

hooksecurefunc("ContainerFrame_Update", function(button)
	local id = button:GetID()
	local name = button:GetName()

	for i = 1, button.size, 1 do
		itemButton = _G[name.."Item"..i]
		questTexture = _G[name.."Item"..i.."IconQuestTexture"]

		itemLink = GetContainerItemLink(id, itemButton:GetID())

		isQuestItem, questId = GetContainerItemQuestInfo(id, itemButton:GetID())

		if itemLink then
			_, _, rarity = GetItemInfo(itemLink)

			if isQuestItem or questId then
				itemButton.border:SetVertexColor(1, 1, 0)
			elseif rarity and rarity > 1 then
				itemButton.border:SetVertexColor(GetItemQualityColor(rarity))
			else
				itemButton.border:SetVertexColor(0.25, 0.25, 0.25)
			end
		else
			itemButton.border:SetVertexColor(0.25, 0.25, 0.25)
		end
	end
end)

hooksecurefunc("BankFrameItemButton_Update", function(button)
	if not button.isBag then
		itemButton = _G[button:GetName()]

		iconBorder =  button.IconBorder
		newItemTexture =  button.NewItemTexture
		questTexture = button.IconQuestTexture
		searchOverlay =  button.searchOverlay

		kill(iconBorder)
		kill(newItemTexture)
		kill(questTexture)
		kill(searchOverlay)

		itemLink = GetContainerItemLink(BANK_CONTAINER, button:GetID())
		isQuestItem, questId = GetContainerItemQuestInfo(BANK_CONTAINER, button:GetID())

		if itemLink then
			_, _, rarity = GetItemInfo(itemLink)

			if isQuestItem or questId then
				itemButton.border:SetVertexColor(1, 1, 0)
			elseif rarity and rarity > 1 then
				itemButton.border:SetVertexColor(GetItemQualityColor(rarity))
			else
				itemButton.border:SetVertexColor(0.25, 0.25, 0.25)
			end
		else
			itemButton.border:SetVertexColor(0.25, 0.25, 0.25)
		end
	end
end)