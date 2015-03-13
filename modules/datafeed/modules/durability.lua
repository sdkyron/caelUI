--[[	$Id: durability.lua 3595 2013-09-22 20:05:41Z sdkyron@gmail.com $	]]

local _, caelDataFeeds = ...

caelDataFeeds.durability = caelDataFeeds.createModule("Durability")

local durability = caelDataFeeds.durability

durability.text:SetPoint("CENTER", caelPanel8, "CENTER", caelUI.scale(225), 0)

durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")

local total = 0
local current, max
local itemSlots = {
    [1] = {1, "Head", 1},
    [2] = {3, "Shoulder", 1},
    [3] = {5, "Chest", 1},
    [4] = {6, "Waist", 1},
    [5] = {7, "Legs", 1},
    [6] = {8, "Feet", 1},
    [7] = {9, "Wrist", 1},
    [8] = {10, "Hands", 1},
    [9] = {16, "MainHand", 1},
    [10] = {17, "SecondaryHand", 1},
}

local sorting = function(a, b)
	return a[3] > b[3]
end

durability:SetScript("OnEvent", function(self, event)
	local lowest = 1

	for i = 1, 10 do
		if GetInventoryItemLink("player", itemSlots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(itemSlots[i][1])

			if current then
				itemSlots[i][3] = current / max
					lowest = math.min(current / max, lowest)
					total = total + 1
			end
		end
	end

	table.sort(itemSlots, sorting)

	if total > 0 then
		self.text:SetFormattedText("|cffD7BEA5dur|r %d%s", floor(lowest * 100), "%")
	else
		self.text:SetText("100% |cffD7BEA5armor|r")
	end
end)

durability:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, caelUI.scale(4))

	for i = 1, 10 do
		if itemSlots[i][3] ~= 1 then
			green = itemSlots[i][3] * 2
			red = 1 - green
			GameTooltip:AddDoubleLine(itemSlots[i][2], floor(itemSlots[i][3] * 100).."%", 0.84, 0.75, 0.65, red + 1, green, 0)
		end
	end

	GameTooltip:Show()
	total = 0
end)