--[[	$Id: inspect.lua 3536 2013-08-24 16:19:22Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.inspect = caelUI.createModule("Inspect")

local inspectfix = caelUI.inspect

local lastunit
local loaded = false
local BlizzardNotifyInspect = _G.NotifyInspect
local InspectPaperDollFrame_SetLevel, InspectPaperDollFrame_OnShow, InspectGuildFrame_Update = nil, nil, nil
local hookcnt, hooked, blockmsg = 0, {}, {}

local unitchange = function(self)
	local unit = self.unit
	if loaded and unit and unit ~= lastunit then
		lastunit = unit
		BlizzardNotifyInspect(unit)
		InspectFrame_UnitChanged(InspectFrame)
	end
end

local inspectfilter = function(self, event, ...) 
	if loaded then
-- ignore an inspect target disappearance or change to non-player - ie, keep the window open
		if (event == "PLAYER_TARGET_CHANGED" or event == nil) and self.unit == "target" and (not UnitExists("target") or not UnitIsPlayer("target")) then
			return false
		end
	end
	return true
end

local inspectonevent = function(self, event, ...)
	if inspectfilter(self, event, ...) then
		InspectFrame_OnEvent(self, event, ...)
		inspectfix:Update()
	end
end

local inspectonupdate = function(self)
	if inspectfilter(self, nil) then
		InspectFrame_OnUpdate(self)
		inspectfix:Update()
	end
end

-- cache the inspect contents in case we lose our target (so GameTooltip:SetInventoryItem() no longer works)
local scantt = CreateFrame("GameTooltip", "InspectFix_Tooltip", UIParent, "GameTooltipTemplate")
scantt:SetOwner(UIParent, "ANCHOR_NONE")
local inspect_item = {}
local inspect_unit = nil
local pdfupdate = function(self)
	if loaded then
		local id = self:GetID()
		local unit = InspectFrame.unit

		if unit and id then
			local link = GetInventoryItemLink(unit, id)

			inspect_unit = unit
			inspect_item[id] = link

			scantt:SetOwner(UIParent, "ANCHOR_NONE")
			scantt:SetInventoryItem(unit, id)

			local _, scanlink = scantt:GetItem()

			if scanlink and scanlink ~= link then
				inspect_item[id] = scanlink
			end
		end
	end
end

local pdfonenter = function(self)
	if loaded then
		local id = self:GetID()
		if id and inspect_item[id] and inspect_unit == InspectFrame.unit and GameTooltip:IsVisible() then
			if GameTooltip:NumLines() == 1 then -- fill in a bogus inspect result
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetHyperlink(inspect_item[id])
			else
				local name,link = GameTooltip:GetItem()
				if link and link ~= inspect_item[id] then
					inspect_item[id] = link
				end
			end
		end
	end
end

function inspectfix:GetID()
	return self.val
end

inspectfix.val = INVSLOT_FIRST_EQUIPPED

function inspectfix:Update() 
	for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		inspectfix.val = slot
		pdfupdate(inspectfix)
	end
end

-- prevent NotifyInspect interference from other addons
local NIhook = function(unit)
	inspectfix:tryhook()

	if loaded and (not unit or not CanInspect(unit)) then
		return
	end

	local ifvis = InspectFrame and InspectFrame:IsVisible()
	local exvis = Examiner and Examiner:IsVisible()

	if loaded and (ifvis or exvis) then
		local str = debugstack(2)
		local addon = string.match(str,'[%s%c]+([^:%s%c]*)\\[^\\:%s%c]+:')

		addon = string.gsub(addon or "unknown",'I?n?t?e?r?f?a?c?e\\AddOns\\',"")

		if not string.find(str,ifvis and "Blizzard_InspectUI" or "Examiner") then
			blockmsg[addon] = blockmsg[addon] or {}
			local count = (blockmsg[addon].count or 0) + 1
			blockmsg[addon].count = count

			local now = GetTime()

			if not blockmsg[addon].lastwarn or (now - blockmsg[addon].lastwarn > 30) then -- throttle warnings
				blockmsg[addon].lastwarn = now
			end
			return
		end
	end
	BlizzardNotifyInspect(unit)
end

-- prevent a lua error bug in pdf
local pdffilter = function(context)
	if not loaded then
		return true
	elseif InspectFrame and InspectFrame.unit and CanInspect(InspectFrame.unit) then
		return true
	else
		return false
	end
end

local setlevel_hook = function()
	if pdffilter("setlevel") then
		return InspectPaperDollFrame_SetLevel()
	end
end

local pdfshow_hook = function()
	if pdffilter("pdfshow") then
		return InspectPaperDollFrame_OnShow()
	end
end

local guildframe_hook = function()
	if pdffilter("guildframe") then
		return InspectGuildFrame_Update()
	end
end

function inspectfix:tryhook()
	if false and not hooked[unitchange] and InspectFrame_UnitChanged then
		hooksecurefunc("InspectFrame_UnitChanged", unitchange)
		hooked[unitchange] = true
	end

	if _G.NotifyInspect and _G.NotifyInspect ~= NIhook then
		if not hooked["notifyinspect"] then
			BlizzardNotifyInspect = _G.NotifyInspect
			_G.NotifyInspect = NIhook
			hookcnt = hookcnt + 1
			hooked["notifyinspect"] = true
		end
	end

	if _G.InspectFrame_OnEvent and InspectFrame:GetScript("OnEvent") ~= inspectonevent then
		InspectFrame:SetScript("OnEvent", inspectonevent)
		if not hooked[inspectonevent] then
			hookcnt = hookcnt + 1
			hooked[inspectonevent] = true
		end
	end

	if _G.InspectFrame_OnUpdate and InspectFrame:GetScript("OnUpdate") ~= inspectonupdate then
		InspectFrame:SetScript("OnUpdate", inspectonupdate)
		if not hooked[inspectonupdate] then
			hookcnt = hookcnt + 1
			hooked[inspectonupdate] = true
		end
	end

	if _G.InspectPaperDollFrame_SetLevel and _G.InspectPaperDollFrame_SetLevel ~= setlevel_hook then
		if not hooked[setlevel_hook] then
			InspectPaperDollFrame_SetLevel = _G.InspectPaperDollFrame_SetLevel
			_G.InspectPaperDollFrame_SetLevel = setlevel_hook
			hooked[setlevel_hook] = true
			hookcnt = hookcnt + 1
		end
	end

	if _G.InspectGuildFrame_Update and _G.InspectGuildFrame_Update ~= guildframe_hook then
		if not hooked[guildframe_hook] then
			InspectGuildFrame_Update = _G.InspectGuildFrame_Update
			_G.InspectGuildFrame_Update = guildframe_hook
			hooked[guildframe_hook] = true
			hookcnt = hookcnt + 1
		end
	end

	if _G.InspectPaperDollFrame_OnShow and _G.InspectPaperDollFrame_OnShow ~= pdfshow_hook then
		InspectPaperDollFrame:SetScript("OnShow", pdfshow_hook)
		if not hooked[pdfshow_hook] then
			InspectPaperDollFrame_OnShow = _G.InspectPaperDollFrame_OnShow
			_G.InspectPaperDollFrame_OnShow = pdfshow_hook
			hooked[pdfshow_hook] = true
			hookcnt = hookcnt + 1
		end
	end

	if not hooked[pdfupdate] and InspectPaperDollItemSlotButton_Update and InspectPaperDollItemSlotButton_OnEnter then
		hooksecurefunc("InspectPaperDollItemSlotButton_Update", pdfupdate)
		hooksecurefunc("InspectPaperDollItemSlotButton_OnEnter", pdfonenter)
		hookcnt = hookcnt + 1
		hooked[pdfupdate] = true
	end

	if hookcnt == 7 then
		hookcnt = hookcnt + 1
	end
end

inspectfix:RegisterEvent("ADDON_LOADED")
inspectfix:SetScript("OnEvent", function(self, event)
	inspectfix:tryhook()
end)

function inspectfix:Load()
	inspectfix:tryhook()
	loaded = true
end

inspectfix:Load()