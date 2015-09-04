--[[	$Id: oUF_cRange.lua 3521 2013-08-23 11:14:00Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

if not oUF then return end

local playerClass = caelUI.playerClass

local ObjectRanges = {}

local _FRAMES = {}
local OnRangeFrame

local RangeChecker = LibStub("LibRangeCheck-2.0")

local HelpIDs, HelpName
local HarmIDs, HarmName

oUF_cRange = oUF_Caellian.createModule("cRange")

local IsInRange
do
	local UnitIsConnected = UnitIsConnected
	local UnitCanAssist = UnitCanAssist
	local UnitCanAttack = UnitCanAttack
	local UnitIsUnit = UnitIsUnit
	local UnitPlayerOrPetInRaid = UnitPlayerOrPetInRaid
	local UnitIsDead = UnitIsDead
	local UnitOnTaxi = UnitOnTaxi
	local UnitInRange = UnitInRange
	local IsInGroup = IsInGroup
	local IsSpellInRange = IsSpellInRange
	local CheckInteractDistance = CheckInteractDistance

	IsInRange = function(UnitID)
		if UnitIsConnected(UnitID) then
			if UnitCanAssist("player", UnitID) then
				if HelpName and not UnitIsDead(UnitID) then
					return IsSpellInRange(HelpName, UnitID) == 1
				elseif not UnitOnTaxi("player") then
					if IsInGroup() then
						if UnitIsUnit(UnitID, "player") or UnitIsUnit(UnitID, "pet") then
							return UnitInRange(UnitID)
						end
					elseif UnitPlayerOrPetInParty(UnitID) or UnitPlayerOrPetInRaid(UnitID) then
						return UnitInRange(UnitID)
					end
				end
			elseif (HarmName and not UnitIsDead(UnitID) and UnitCanAttack("player", UnitID)) then
				return IsSpellInRange(HarmName, UnitID) == 1
			end
			return CheckInteractDistance(UnitID, 4) and true or false
		end
	end
end

oUF_cRange.IsInRange = IsInRange

local OnRangeUpdate
do
	local timer = 0
	OnRangeUpdate = function(self, elapsed)
		timer = timer + elapsed

		if timer >= 0.1 then
			for _, object in next, _FRAMES do
				if object:IsShown() then
					local InRange = IsInRange(object.unit)
					local cRange = object.cRange
					local minRange, maxRange = RangeChecker:GetRange("target")

					if InRange and cRange.text and minRange and maxRange then
						cRange.text:SetText(minRange.." - "..maxRange)
					end

					if ObjectRanges[object] ~= InRange then
						ObjectRanges[object] = InRange

						local portrait = object.Portrait
						local underlay = object.Underlay
						local cRange = object.cRange

						if object.unit == "target" then
							if InRange then
								if portrait and not portrait:IsShown() then
									portrait:Show()
									portrait:SetCamera(0)
									portrait:SetModelScale(4.25)
									portrait:SetPosition(0, 0, -1.5)

									underlay:Show()
								end

								cRange.text:ClearAllPoints()
								cRange.text:SetPoint("RIGHT", portrait, "RIGHT")
								cRange.text:SetTextColor(0.84, 0.75, 0.65)
							else
								if portrait and portrait:IsShown() then
									portrait:Hide()
									underlay:Hide()
								end

								cRange.text:ClearAllPoints()
								cRange.text:SetAllPoints(portrait)
								cRange.text:SetTextColor(0.69, 0.31, 0.31)
								cRange.text:SetText("Out of Range")
							end
						elseif object.unit == "targettarget" or object.unit == "focus" or object.unit == "focustarget" then
							if InRange then
								if object:GetAlpha() ~= cRange.insideAlpha then
									object:SetAlpha(cRange.insideAlpha)
								end
							else
								if object:GetAlpha() ~= cRange.outsideAlpha then
									object:SetAlpha(cRange.outsideAlpha)
								end
							end
						end

					end
				end
			end
		end
	end
end

local OnSpellsChanged
do
	local IsSpellKnown = IsSpellKnown
	local GetSpellInfo = GetSpellInfo
	local GetSpellName = function(IDs)
		if IDs then
			for _, ID in ipairs(IDs) do
				if IsSpellKnown(ID) then
					return GetSpellInfo(ID)
				end
			end
		end
	end

	OnSpellsChanged = function()
		HelpName, HarmName = GetSpellName(HelpIDs), GetSpellName(HarmIDs)
	end
end

local Enable = function(self, UnitID)
	local cRange = self.cRange

	if cRange then
		if self.Range then
			self:DisableElement("Range")
			self.Range = nil
		end

		table.insert(_FRAMES, self)

		if not OnRangeFrame then
			OnRangeFrame = CreateFrame("Frame")
			OnRangeFrame:SetScript("OnUpdate", OnRangeUpdate)
			OnRangeFrame:SetScript("OnEvent", OnSpellsChanged)
			OnRangeFrame:RegisterEvent("SPELLS_CHANGED")

			ObjectRanges[self] = nil
		end

		OnRangeFrame:Show()
		OnSpellsChanged()
	end
end

local Disable = function(self)
	local cRange = self.cRange

	if cRange then
		for k, frame in next, _FRAMES do
			if frame == self then
				table.remove(_FRAMES, k)
				break
			end
		end

		if #_FRAMES == 0 then
			OnRangeFrame:Hide()
			OnRangeFrame:UnregisterEvent("SPELLS_CHANGED")
		end

		ObjectRanges[self] = nil
	end
end

--- Optional lists of low level baseline skills with greater than 28 yard range.
-- First known spell in the appropriate class list gets used.
-- Note: Spells probably shouldn't have minimum ranges!
HelpIDs = ({
	DEATHKNIGHT = {47541}, -- Death Coil (40yd) - Starter
	DRUID = {5185}, -- Healing Touch (40yd) - Lvl 3
--	HUNTER = {},
	MAGE = {475}, -- Remove Curse (40yd) - Lvl 30
	MONK = {115450}, -- Detox (40yd) - Lvl 20
	PALADIN = {85673}, -- Word of Glory (40yd) - Lvl 9
	PRIEST = {2061}, -- Flash Heal (40yd) - Lvl 3
--	ROGUE = {},
	SHAMAN = {331}, -- Healing Wave (40yd) - Lvl 7
	WARLOCK = {5697}, -- Unending Breath (30yd) - Lvl 16
--	WARRIOR = {},
})[playerClass]

HarmIDs = ({
	DEATHKNIGHT = {47541}, -- Death Coil (30yd) - Starter
	DRUID = {5176}, -- Wrath (40yd) - Starter
	HUNTER = {75}, -- Auto Shot (5-40yd) - Starter
	MAGE = {44614}, -- Frostfire Bolt (40yd) - Starter
	MONK = {115546}, -- Provoke (40yd) - Lvl 14
	PALADIN = {
		62124, -- Hand of Reckoning (30yd) - Lvl 14
		879, -- Exorcism (30yd) - Lvl 18
	},
	PRIEST = {589}, -- Shadow Word: Pain (40yd) - Lvl 4
	ROGUE = {2764}, -- Throw (5-30yd) - Starter
	SHAMAN = {403}, -- Lightning Bolt (30yd) - Starter
	WARLOCK = {686}, -- Shadow Bolt (40yd) - Starter
	WARRIOR = {355}, -- Taunt (30yd) - Lvl 12
})[playerClass]

oUF:AddElement("cRange", nil, Enable, Disable)