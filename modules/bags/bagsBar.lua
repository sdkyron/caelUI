--[[	$Id: bagsBar.lua 3537 2013-08-25 05:50:10Z sdkyron@gmail.com $	]]

local _, caelUI = ...

local pixelScale = caelUI.scale

local bagButtons = {}

bagButtons[0] = "MainMenuBarBackpackButton"
bagButtons[1] = "CharacterBag0Slot"
bagButtons[2] = "CharacterBag1Slot"
bagButtons[3] = "CharacterBag2Slot"
bagButtons[4] = "CharacterBag3Slot"

local bagBar, bagsButton
local bankBagBar, bankBagsButton
local buySlotCost, buySlotButton
local bagBarReady, bankBagBarReady

local function CreateContainerFrame(name)
    local f = CreateFrame("Frame", name, UIParent)
    f:SetFrameStrata("HIGH")
    f:SetBackdrop(caelMedia.backdropTable)
    f:SetBackdropColor(0, 0, 0, 0.7)
    f:SetBackdropBorderColor(0, 0, 0)

    return f
end

local BagString = function(num)
    return string.format("Bag%d", num)
end

bagBar = CreateContainerFrame("bagBar")
bagBar:SetPoint("TOPLEFT", caelBags_bag, "BOTTOMLEFT")
bagBar:SetPoint("BOTTOMRIGHT", caelBags_bag, 0, pixelScale(-35))
bagBar.buttons = {}

bankBagBar = CreateContainerFrame("bankBagBar")
bankBagBar:SetPoint("TOPLEFT", caelBags_bank, "BOTTOMLEFT")
bankBagBar:SetPoint("BOTTOMRIGHT", caelBags_bank, 0, pixelScale(-35))
bankBagBar:Hide()
bankBagBar.buttons = {}

function bankBagBar:Update() 
	local numSlots, full = GetNumBankSlots()
	local button

	for i = 1, #self.buttons do
		button = self.buttons[i]
		if button then
			if i <= numSlots then
				SetItemButtonTextureVertexColor(button, 1, 1, 1)
				button.tooltipText = BANK_BAG
			else
				SetItemButtonTextureVertexColor(button, 1, 0.1, 0.1)
				button.tooltipText = BANK_BAG_PURCHASE
			end
		end
	end

	if not full then
		local cost = GetBankSlotCost(numSlots)

		if GetMoney() >= cost then
			SetMoneyFrameColor("BankFrameDetailMoneyFrame", "white")
		else
			SetMoneyFrameColor("BankFrameDetailMoneyFrame", "red")
		end

		MoneyFrame_Update("BankFrameDetailMoneyFrame", cost)
		
		self.buySlotButton:Show()
		self.buySlotCost:Show()
	else
		self.buySlotButton:Hide()
		self.buySlotCost:Hide()
	end
end

function bankBagBar:init()
	local buySlotButton = BankFramePurchaseButton

	buySlotButton:SetParent(self)

	buySlotButton:SetNormalTexture("")
	buySlotButton:SetHighlightTexture("")
	buySlotButton:SetPushedTexture("")
	buySlotButton:SetDisabledTexture("")

	buySlotButton.Left:SetAlpha(0)
	buySlotButton.Middle:SetAlpha(0)
	buySlotButton.Right:SetAlpha(0)

	caelBags.SkinButton(buySlotButton)

	buySlotButton:ClearAllPoints()
	buySlotButton:SetPoint("BOTTOMLEFT", self, pixelScale(5), pixelScale(10))

	self.buySlotButton = buySlotButton

	local buySlotCost = BankFrameDetailMoneyFrame

	buySlotCost:ClearAllPoints()
	buySlotCost:SetParent(self)
	buySlotCost:SetPoint("LEFT", buySlotButton, "RIGHT")

	self.buySlotCost = buySlotCost

	bankBagBar:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED")
	bankBagBar:SetScript("OnShow", function(self) self:RegisterEvent("PLAYER_MONEY") self:Update() end)
	bankBagBar:SetScript("OnHide", function(self) self:UnregisterEvent("PLAYER_MONEY") end)
	bankBagBar:SetScript("OnEvent", bankBagBar.Update)
end

local CreateBagBar = function(bank)
    local start_bag = bank and 1 or 0
    local end_bag = bank and 7 or 4
    local bag_index = 0

    local bar = bank and bankBagBar or bagBar
    
    for bag = start_bag, end_bag do
		local name = bagButtons[bag]

		local b = bank and BankSlotsFrame["Bag"..bag] or _G[name]
		local _, highlightFrame = b:GetChildren()
		local border = bank and b.IconBorder or _G[name.."NormalTexture"]

		b:SetSize(pixelScale(28), pixelScale(28))

		b:Show()
		b.Bar = bar
		b:SetParent(bar)

		b.icon:SetTexCoord(.08, .92, .08, .92)

		if bagBar then
			b.icon:SetPoint("TOPLEFT", pixelScale(4.5), pixelScale(-4.5))
			b.icon:SetPoint("BOTTOMRIGHT", pixelScale(-4.5), pixelScale(4.5))
		end

		if not bank then
			b:SetCheckedTexture(nil)
		else
			highlightFrame:Hide()
		end

		b:SetNormalTexture("")
		b:SetPushedTexture("")

		b:ClearAllPoints()
		b:SetPoint("RIGHT", bar, "RIGHT", pixelScale(bag_index * -28 - 5 * 2 - 4 * bag_index) , pixelScale(1.5))

		border:SetTexture(caelMedia.files.buttonNormal)
		border:SetVertexColor(1, 1, 1)
		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND", 1)
		
		tinsert(bar.buttons, b)
		
		bag_index = bag_index + 1
	end

	MainMenuBarBackpackButtonCount:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 10, "OUTLINE")

    if bar.init then
		bar:init()
    end
end

bagsButton = caelBags.CreateToggleButton("bagsButton", "Bags Bar", caelBags_bag)
bagsButton:SetPoint("BOTTOMRIGHT", caelBags_bag, "BOTTOMRIGHT", pixelScale(-5), pixelScale(5))
bagsButton:SetSize(pixelScale(48), pixelScale(18))
bagsButton:SetScript("OnClick", function(self)
    if not self.ready then
		CreateBagBar()
		self.ready = true
    end

    if bagBar:IsShown() then
        bagBar:Hide()
    else
        bagBar:Show()
    end
end)

bankBagsButton = caelBags.CreateToggleButton("bankBagsButton", "Bags Bar", caelBags_bank)
bankBagsButton:SetPoint("BOTTOMRIGHT", caelBags_bank, "BOTTOMRIGHT", pixelScale(-5), pixelScale(5))
bankBagsButton:SetScript("OnClick", function(self)
    if not self.ready then
		CreateBagBar(true)
		self.ready = true
    end

    if bankBagBar:IsShown() then
        bankBagBar:Hide()
    else
        bankBagBar:Show()
    end
end)

--hooksecurefunc(button, "SetChecked", function(self, checked) for i = 1, #self.buttons do self.buttons[i].NormalTexture:SetVertexColor(0.25, 0.25, 0.25) end end)

caelBags_bag:HookScript("OnHide", function() bagBar:Hide() end)
caelBags_bank:HookScript("OnHide", function() bankBagBar:Hide() end)
caelBags_bag:HookScript("OnShow", function() bagBar:Hide() end)
caelBags_bank:HookScript("OnShow", function() bankBagBar:Hide() end)