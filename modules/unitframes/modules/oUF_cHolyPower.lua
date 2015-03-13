--[[	$Id: oUF_cHolyPower.lua 3521 2013-08-23 11:14:00Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

if not oUF or caelUI.playerClass ~= "PALADIN" then return end

local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end

	local hp = self.HolyPower
	if(hp.PreUpdate) then hp:PreUpdate() end

	local maxHolyPower = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
	local num = UnitPower('player', SPELL_POWER_HOLY_POWER)
	for i = 1, maxHolyPower do
		if(i <= num) then
			hp[i]:Show()
		else
			hp[i]:Hide()
		end
	end

	if(hp.PostUpdate) then
		return hp:PostUpdate(num)
	end
end

local Path = function(self, ...)
	return (self.HolyPower.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'HOLY_POWER')
end

local function Enable(self)
	local hp = self.HolyPower
	if(hp) then
		hp.__owner = self
		hp.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', Path)

		return true
	end
end

local function Disable(self)
	local hp = self.HolyPower
	if(hp) then
		self:UnregisterEvent('UNIT_POWER', Path)
	end
end

oUF:AddElement('HolyPower', Path, Enable, Disable)

