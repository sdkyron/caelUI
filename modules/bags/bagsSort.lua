--[[	$Id: bagsSort.lua 3537 2013-08-25 05:50:10Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--category constants
--number indicates sort priority (1 is highest)
SOULBOUND   = 1
REAGENT     = 2
CONSUMABLE  = 3
QUEST       = 4
TRADE       = 5
QUALITY     = 6
COMMON      = 7
TRASH       = 8

local _G = _G
local BagGroups --bag group definitions
local ItemSwapGrid --grid of item data based on destination inventory location
		
local Sorting = false     --indicates bag rearrangement is in progress
local PauseRemaining = 0  --how much longer to wait before running the OnUpdate code again

local ClearData = function()
	ItemSwapGrid = {}
	BagGroups = {}
end

local OnUpdate = function(self, elapsed)
	if not Sorting then return end
	
	PauseRemaining = PauseRemaining - elapsed
	if PauseRemaining > 0 then return end

	local changesThisRound = false
	local blockedThisRound = false
	
	--for each bag in the grid
	for bagIndex in pairs(ItemSwapGrid) do
	    --for each slot in this bag
	    for slotIndex in pairs(ItemSwapGrid[bagIndex]) do
			--(for readability)
			local destinationBag  = ItemSwapGrid[bagIndex][slotIndex].destinationBag
			local destinationSlot = ItemSwapGrid[bagIndex][slotIndex].destinationSlot

			--see if either item slot is currently locked
	        local _, _, locked1 = GetContainerItemInfo(bagIndex, slotIndex)
	        local _, _, locked2 = GetContainerItemInfo(destinationBag, destinationSlot)
	        
	        if locked1 or locked2 then
	            blockedThisRound = true
			--if item not already where it belongs, move it
			elseif bagIndex ~= destinationBag or slotIndex ~= destinationSlot then
               	PickupContainerItem(bagIndex, slotIndex)
				PickupContainerItem(destinationBag, destinationSlot)
				
				local tempItem = ItemSwapGrid[destinationBag][destinationSlot]
				ItemSwapGrid[destinationBag][destinationSlot] = ItemSwapGrid[bagIndex][slotIndex]
				ItemSwapGrid[bagIndex][slotIndex] = tempItem

				changesThisRound = true
	        end
		end
	end
	
	if not changesThisRound and not blockedThisRound then
	    Sorting = false
	    ClearData()
	end
	
	PauseRemaining = 0.05
end

local SortBagRange = function(bagList, order)
	--clear any data from previous sorts
	ClearData()
	local family

	--assign bags to bag groups
	for slotNumIndex, slotNum in pairs(bagList) do
		
		if GetContainerNumSlots(slotNum) > 0 then --if bag exists
			--initialize the item grid for this bag (used later)
			ItemSwapGrid[slotNum] = {}
			family = select(2, GetContainerNumFreeSlots(slotNum))

			if family then
				if family == 0 then family = "default" end

				if not BagGroups[family] then
					BagGroups[family] = {}
					BagGroups[family].bagSlotNumbers = {}
				 end
				table.insert(BagGroups[family].bagSlotNumbers, slotNum)
			end
		end
	end
	
	--for each bag group
	for groupKey, group in pairs(BagGroups) do
		--initialize the list of items for this bag group
		group.itemList = {}
		--for each bag in this group
		for bagKey, bagSlot in pairs(group.bagSlotNumbers) do
		
			--for each item slot in this bag
			for itemSlot = 1, GetContainerNumSlots(bagSlot) do
			
				--get a reference for the item in this location
				local itemLink = GetContainerItemLink(bagSlot, itemSlot)

				--if this slot is non-empty
				if itemLink ~= nil then
				
					--collect important data about the item
					local newItem   = {}
					
					--initialize the sorting string for this item
					newItem.sortString = ""
					
					--use reference from above to request more detailed information
					local itemName, _, itemRarity, _, _, itemType, itemSubType, _, itemEquipLoc, _ = GetItemInfo(itemLink)

					if not itemName then 
						itemName = itemLink
						itemRarity = 5
						itemType = "Pet"
						itemSubType = "Pet"
						itemEquipLoc = 0
					end -- fix for battle pets
					newItem.name = itemName
					
					--determine category
					
					--soulbound items
                   	local tooltip = _G["toolTip"]

					tooltip:ClearLines()
					tooltip:SetBagItem(bagSlot, itemSlot)

					local tooltipLine2 = _G["toolTipTextLeft2"]:GetText()

					tooltip:Hide()

					if tooltipLine2 and tooltipLine2 == "Soulbound" then
						newItem.sortString = newItem.sortString .. SOULBOUND
					--consumable items
					elseif itemType == "Consumable" then
						newItem.sortString = newItem.sortString .. CONSUMABLE
					--reagents
					elseif itemType == "Reagent" then
						newItem.sortString = newItem.sortString .. REAGENT
					--trade goods
					elseif itemType == "Trade Goods" then
						newItem.sortString = newItem.sortString .. TRADE
					--quest items
					elseif itemType == "Quest" then
						newItem.sortString = newItem.sortString .. QUEST
					--junk
					elseif itemRarity == 0 then
						newItem.sortString = newItem.sortString .. TRASH
					--common quality
					elseif itemRarity == 1 then
						newItem.sortString = newItem.sortString .. COMMON
					--higher quality
					else
						newItem.sortString = newItem.sortString .. QUALITY
					end
					
					--finish the sort string, placing more important information
					--closer to the start of the string
					
					newItem.sortString = newItem.sortString .. itemType .. itemSubType .. itemEquipLoc .. itemName
					
					--add this item's accumulated data to the item list for this bag group
					tinsert(group.itemList, newItem)

					--record location
					ItemSwapGrid[bagSlot][itemSlot] = newItem
					newItem.startBag = bagSlot
					newItem.startSlot = itemSlot
				end
			end
		end
		
		--sort the item list for this bag group by sort strings
		table.sort(group.itemList, function(a, b) return a.sortString < b.sortString end)
		
		--show the results for this group
		for index, item in pairs(group.itemList) do
			local gridSlot = index
   			--record items in a grid according to their intended final placement
			for bagSlotNumberIndex, bagSlotNumber in pairs(group.bagSlotNumbers) do
				if gridSlot <= GetContainerNumSlots(bagSlotNumber) then
					if order == 0 then -- put their order them from bottomright
						ItemSwapGrid[item.startBag][item.startSlot].destinationBag  = bagSlotNumber
						ItemSwapGrid[item.startBag][item.startSlot].destinationSlot = GetContainerNumSlots(bagSlotNumber) - gridSlot + 1
						break
					else -- put their order them from topleft
						ItemSwapGrid[item.startBag][item.startSlot].destinationBag  = bagSlotNumber
						ItemSwapGrid[item.startBag][item.startSlot].destinationSlot = gridSlot
						break
					end
				else
					gridSlot = gridSlot - GetContainerNumSlots(bagSlotNumber)
				end
	        end
	    end
	end
	
	--signal for sorting to begin
	Sorting = true
end

BankSort = function(order)
	if order == 0 then
		SortBagRange({11, 10, 9, 8, 7, 6, 5, -1}, 0)
	else
		SortBagRange({-1, 5, 6, 7, 8, 9, 10, 11}, 1)
	end
end

BagSort = function(order)
	if order == 0 then
		SortBagRange({4, 3, 2, 1, 0}, 0)
	else
		SortBagRange({0, 1, 2, 3, 4}, 1)
	end
end

caelBags:SetScript("OnLoad", ClearData)
caelBags:SetScript("OnUpdate", OnUpdate)

local Tooltip = CreateFrame("GameTooltip", "toolTip", UIParent, "GameTooltipTemplate")