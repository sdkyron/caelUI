--[[	$Id: buffet.lua 3976 2014-12-04 23:08:05Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.buffet = caelUI.createModule("buffet")

local buffet = caelUI.buffet

local macroHP = "#showtooltip\n%MACRO%"
local macroMP = "#showtooltip\n%MACRO%"

local items, bests, allitems, dirty = caelUI.items, caelUI.bests, caelUI.allitems, false

buffet.Scan = function()
	for _, t in pairs(bests) do
		for i in pairs(t) do
			t[i] = nil
		end
	end
	
	local mylevel = UnitLevel("player")

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local id = (link and string.find(link, "item:(%d+)")) and tonumber(select(3, string.find(link, "item:(%d+)")))

			local reqlvl = link and select(5, GetItemInfo(link)) or 0

			if id and allitems[id] and reqlvl <= mylevel then
				local _, stack = GetContainerItemInfo(bag,slot)

				for set, setitems in pairs(items) do
					local thisbest, val = bests[set], setitems[id]
					if val and (not thisbest.val or (thisbest.val < val or thisbest.val == val and thisbest.stack > stack)) then
						thisbest.id, thisbest.val, thisbest.stack = id, val, stack
					end
				end
			end
		end
	end

	local healthstone = GetItemCount(5512) > 0 and 5512 or nil

	local food = bests.percfood.id or bests.food.id or healthstone or bests.hppot.id
	local water = bests.percwater.id or bests.water.id or bests.mppot.id

	buffet.Edit("AutoHP", macroHP, food, healthstone or bests.hppot.id, bests.bandage.id)
	buffet.Edit("AutoMP", macroMP, water, bests.mppot.id)

	dirty = false
end

buffet.Edit = function(name, substring, food, pot, mod)
	local macroid = GetMacroIndexByName(name)

	if not macroid then return end

	local body = "/use "

	if mod then
		body = body .. "[mod,target=player] item:"..mod.."; "
	end

	if pot then
		body = body .. "[combat] item:"..pot.."; "
	end

	body = body.."item:"..(food or "6948")

	EditMacro(macroid, name, "INV_Misc_QuestionMark", substring:gsub("%%MACRO%%", body), 1)
end

buffet:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		self:Scan()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if dirty then
			buffet.Scan(self)
		end
	elseif event == "BAG_UPDATE" or event == "PLAYER_LEVEL_UP" then
		dirty = true

		if not InCombatLockdown() then
			buffet.Scan(self)
		end
	end
end)

for _, event in next, {
	"BAG_UPDATE",
	"PLAYER_LEVEL_UP",
	"PLAYER_LOGIN",
	"PLAYER_REGEN_ENABLED",
} do
	buffet:RegisterEvent(event)
end