--[[	$Id: autoSellRepair.lua 3893 2014-03-04 10:26:42Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Auto sell junk & auto repair	]]

caelUI.merchant = caelUI.createModule("Merchant")

local merchant = caelUI.merchant

local format = string.format

local formatMoney = function(value)
	if value >= 1e4 then
		return format("|cffffd700%dg |r|cffc7c7cf%ds |r|cffeda55f%dc|r", value/1e4, strsub(value, -4) / 1e2, strsub(value, -2))
	elseif value >= 1e2 then
		return format("|cffc7c7cf%ds |r|cffeda55f%dc|r", strsub(value, -4) / 1e2, strsub(value, -2))
	else
		return format("|cffeda55f%dc|r", strsub(value, -2))
	end
end

local itemCount, sellValue = 0, 0
merchant:RegisterEvent("MERCHANT_SHOW")
merchant:SetScript("OnEvent", function(self, event)
	if event == "MERCHANT_SHOW" then
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local item = GetContainerItemLink(bag, slot)
				if item then
					local _, _, itemRarity, itemLevel, _, itemType, _, _, _, _, itemSellPrice = GetItemInfo(item)

					if itemRarity == 0 or (itemRarity == 2 and itemLevel < 483 and (itemType == ("Armor") or itemType == ("Weapon")) and UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] and UnitName("target") == "Lumba the Crusher") then
						local stackValue = itemSellPrice * GetItemCount(item)

						ShowMerchantSellCursor(1)
						UseContainerItem(bag, slot)

						itemCount = itemCount + GetItemCount(item)
						sellValue = sellValue + stackValue
					end
				end
			end
		end

		if sellValue > 0 then
			print(format("|cffD7BEA5cael|rCore: Sold %d trash item%s for %s.", itemCount, itemCount ~= 1 and "s" or "", formatMoney(sellValue)))
			itemCount, sellValue = 0, 0
		end

		if CanMerchantRepair() then
			local cost, needed = GetRepairAllCost()
			if needed then
				local GuildWealth = CanGuildBankRepair() and GetGuildBankWithdrawMoney() > cost
				if GuildWealth then
					RepairAllItems(1)
					print(format("|cffD7BEA5cael|rCore: Guild bank repaired for %s.", formatMoney(cost)))
				elseif cost < GetMoney() then
					RepairAllItems()
					print(format("|cffD7BEA5cael|rCore: Repaired for %s.", formatMoney(cost)))
				else
					print("|cffD7BEA5cael|rCore: Repairs were unaffordable.")
				end
			end
		end
	end
end)