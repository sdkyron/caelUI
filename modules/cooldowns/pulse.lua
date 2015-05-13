--[[	$Id: pulse.lua 3591 2013-09-21 16:12:54Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.cdpulse = caelUI.createModule("CooldownPulse")

local cdpulse = caelUI.cdpulse

local pixelScale = caelUI.scale

local fadeInTime, fadeOutTime, maxAlpha, animScale, iconSize, holdTime, ignoredSpells
local cooldowns, animating, watching = { }, { }, { }

cdpulse:SetBackdrop(caelMedia.borderTable)

local texture = cdpulse:CreateTexture(nil, "ARTWORK")
texture:SetPoint("TOPLEFT", cdpulse, pixelScale(6), pixelScale(-6))
texture:SetPoint("BOTTOMRIGHT", cdpulse, pixelScale(-6), pixelScale(6))
texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

local border = cdpulse:CreateTexture(nil, "ARTWORK")
border:SetPoint("TOPLEFT", cdpulse, pixelScale(-1), pixelScale(1))
border:SetPoint("BOTTOMRIGHT", cdpulse, pixelScale(1), pixelScale(-1))
border:SetTexture(caelMedia.files.buttonNormal)

local gloss = CreateFrame("Frame", nil, cdpulse)
gloss:SetFrameLevel(gloss:GetFrameLevel() + 1)
gloss:SetPoint("TOPLEFT", cdpulse, pixelScale(-2), pixelScale(2))
gloss:SetPoint("BOTTOMRIGHT", cdpulse, pixelScale(2), pixelScale(-2))
gloss:SetBackdrop({
	bgFile = caelMedia.files.buttonGloss,
	insets = {top = pixelScale(-1), left = pixelScale(-1), bottom = pixelScale(-1), right = pixelScale(-1)}
})
gloss:SetBackdropColor(0.5, 0.5, 0.5, 0.5)

local TabCount = function(tab)
	local num = 0
	for _ in pairs(tab) do
		num = num + 1
	end
	return num
end

cdpulse:RegisterEvent("ADDON_LOADED")
cdpulse:SetScript("OnEvent", function(self, event)
	fadeInTime = 0.5
	fadeOutTime = 0.5
	maxAlpha = 1
	animScale = 1.2
	iconSize = pixelScale(45)
	holdTime = 1

	ignoredSpells = {}

	self:SetPoint("CENTER", UIParent, 0, pixelScale(100))
	self:UnregisterEvent("ADDON_LOADED")
end)

local delay = 0
local runTimer = 0
local cdpulse_OnUpdate = function(self, elapsed)
	delay = delay + elapsed

	if delay > 0.05 then
		for i, v in pairs(watching) do
			if GetTime() >= v[1] + 0.5 then

				if ignoredSpells[i] then 
					watching[i] = nil 
				else 
					local start, duration, enabled, texture

					if v[2] == "spell" then
						texture = GetSpellTexture(v[3])
						start, duration, enabled = GetSpellCooldown(v[3])
					elseif v[2] == "item" then
						texture = v[3]
						start, duration, enabled = GetItemCooldown(i)
					end

					if enabled ~= 0 then
						if duration and duration > 2.0 and texture then
							cooldowns[i] = {start, duration, texture}
						end
					end

					if not enabled == 0 and v[2] == "spell" then
						watching[i] = nil
					end
				end
			end
		end

		for i, v in pairs(cooldowns) do
			local remaining = v[2]-(GetTime()-v[1])

			if remaining <= 0 then
				tinsert(animating, {v[3],v[4]})
				cooldowns[i] = nil
			end
		end

		delay = 0

		if #animating == 0 and TabCount(watching) == 0 and TabCount(cooldowns) == 0 then
			self:SetScript("OnUpdate", nil)
			return
		end
	end

	if #animating > 0 then
		runTimer = runTimer + elapsed

		if runTimer > fadeInTime + holdTime + fadeOutTime then
			tremove(animating, 1)
			runTimer = 0
			texture:SetTexture(nil)
			texture:SetAlpha(0)
			self:SetBackdropBorderColor(0, 0, 0, 0)
			self:SetBackdropColor(0, 0, 0, 0)
			border:SetAlpha(0)
			gloss:SetAlpha(0)
		else
			if not texture:GetTexture() then
				texture:SetTexture(animating[1][1])

				if animating[1][2] then
					texture:SetVertexColor(0, 0, 0)
				end
			end

			local alpha = maxAlpha

			if runTimer < fadeInTime then
				alpha = maxAlpha * (runTimer / fadeInTime)
			elseif runTimer >= fadeInTime + holdTime then
				alpha = maxAlpha - ( maxAlpha * ((runTimer - holdTime - fadeInTime) / fadeOutTime))
			end

			local scale = iconSize + (iconSize * ((animScale - 1) * (runTimer / (fadeInTime + holdTime + fadeOutTime))))
			self:SetWidth(scale)
			self:SetHeight(scale)
			texture:SetAlpha(alpha)
			self:SetBackdropBorderColor(0, 0, 0, alpha)
			self:SetBackdropColor(0, 0, 0, alpha)
			self:SetAlpha(alpha)
			border:SetAlpha(alpha)
			gloss:SetAlpha(alpha)
		end
	end
end

cdpulse:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
cdpulse:HookScript("OnEvent", function(self, event, unit, spell, _, _, spellID)
	if unit == "player" then
		watching[spell] = {GetTime(), "spell", spellID}
		if not self:IsMouseEnabled() then
			self:SetScript("OnUpdate", cdpulse_OnUpdate)
		end
	end
end)

hooksecurefunc("UseAction", function(slot)
	local actionType, itemID = GetActionInfo(slot)
	if actionType == "item" then
		local texture = GetActionTexture(slot)
		watching[itemID] = {GetTime(), "item", texture}
	end
end)

hooksecurefunc("UseInventoryItem", function(slot)
	local itemID = GetInventoryItemID("player", slot)
	if itemID then
		local texture = GetInventoryItemTexture("player", slot)
		watching[itemID] = {GetTime(), "item", texture}
	end
end)

hooksecurefunc("UseContainerItem", function(bag,slot)
	local itemID = GetContainerItemID(bag, slot)
	if itemID then
		local texture = select(10, GetItemInfo(itemID))
		watching[itemID] = {GetTime(), "item", texture}
	end
end)