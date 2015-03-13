--[[	$Id: oUF_cTotems.lua 3521 2013-08-23 11:14:00Z sdkyron@gmail.com $	]]

local _, oUF_Caellian = ...

if not oUF or caelUI.playerClass ~= "SHAMAN" then return end

oUF.colors.totems = {
	[FIRE_TOTEM_SLOT] = {0.752,0.172,0.02},
	[EARTH_TOTEM_SLOT] = {0.741,0.580,0.04},
	[WATER_TOTEM_SLOT] = {0,0.443,0.631},
	[AIR_TOTEM_SLOT] = {0.6,1,0.945}
}

local OnClick = function(self)
	DestroyTotem(self:GetID())
end

local UpdateTooltip = function(self)
	GameTooltip:SetTotem(self:GetID())
end

local OnEnter = function(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	self:UpdateTooltip()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local total = 0
local delay = 0.01

local UpdateTotem = function(self, event, slot)

	local totems = self.TotemBar

	local totem = totems[slot]

	if totem then
		totem:SetStatusBarColor(unpack(oUF.colors.totems[slot]))

		if totem.bg.multiplier then
			local mu = totem.bg.multiplier
			local r, g, b = totem:GetStatusBarColor()
			r, g, b = r * mu, g * mu, b * mu
			totem.bg:SetVertexColor(r, g, b)
		end

		totem:SetMinMaxValues(0, 1)

		totem.ID = slot
		
		local haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(slot)

		if(haveTotem) then
			if(duration > 0) then
				totem:Show()
				totem:SetValue(1 - ((GetTime() - startTime) / duration))	

				totem:SetScript("OnUpdate",function(self, elapsed)
						total = total + elapsed
						if total >= delay then
							total = 0
							haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(self.ID)
								if ((GetTime() - startTime) == 0) then
									self:SetValue(0)
								else
									self:SetValue(1 - ((GetTime() - startTime) / duration))
								end
						end
					end)					
			else
				totem:SetScript("OnUpdate",nil)
--				totem:Hide()
				totem:SetValue(0)
			end 
		else
			totem:SetValue(0)
--			totem:Hide()
		end
	end

	if(totems.PostUpdate) then
		return totems:PostUpdate(slot, haveTotem, name, start, duration, icon)
	end
end

local Path = function(self, ...)
	return (self.TotemBar.Override or UpdateTotem) (self, ...)
end

local Update = function(self, event)
	for i = 1, MAX_TOTEMS do
		Path(self, event, i)
	end
end

local ForceUpdate = function(element)
	return Update(element.__owner, "ForceUpdate")
end

local Enable = function(self)
	local totems = self.TotemBar

	if(totems) then
		totems.__owner = self
		totems.ForceUpdate = ForceUpdate

		for i = 1, MAX_TOTEMS do
			local totem = totems[i]

			totem:SetID(i)

			if(totem:HasScript"OnClick") then
				totem:SetScript("OnClick", OnClick)
			end

			if(totem:IsMouseEnabled()) then
				totem:SetScript("OnEnter", OnEnter)
				totem:SetScript("OnLeave", OnLeave)

				if(not totem.UpdateTooltip) then
					totem.UpdateTooltip = UpdateTooltip
				end
			end
		end

		self:RegisterEvent("PLAYER_TOTEM_UPDATE", Path, true)

		TotemFrame.Show = TotemFrame.Hide
		TotemFrame:Hide()

		TotemFrame:UnregisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:UnregisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:UnregisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:UnregisterEvent"PLAYER_TALENT_UPDATE"

		return true
	end
end

local Disable = function(self)
	if(self.TotemBar) then
		TotemFrame.Show = nil
		TotemFrame:Show()

		TotemFrame:RegisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:RegisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:RegisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:RegisterEvent"PLAYER_TALENT_UPDATE"

		self:UnregisterEvent("PLAYER_TOTEM_UPDATE", Path)
	end
end

oUF:AddElement("TotemBar", Update, Enable, Disable)