--[[	$Id: battlefieldMinimap.lua 3986 2015-01-26 10:23:06Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.battlefield = caelUI.createModule("Battlefield")

local battlefield = caelUI.battlefield

local delay, kill, pixelScale = 0, caelUI.kill, caelUI.scale

local blip, color, unit

caelPanel11:RegisterEvent("GROUP_ROSTER_UPDATE")
caelPanel11:RegisterEvent("PLAYER_ENTERING_WORLD")
caelPanel11:RegisterEvent("ZONE_CHANGED_NEW_AREA")
caelPanel11:SetScript("OnEvent", function(self)
	local _, instanceType = IsInInstance()

	if instanceType == "pvp" or tostring(GetZoneText()) == "Wintergrasp" or tostring(GetZoneText()) == "Tol Barad" or tostring(GetZoneText()) == "Ashran" then
		BattlefieldMinimap_LoadUI()

		self:Show()
		BattlefieldMinimap:Show()

		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetPoint("TOPRIGHT", caelPanel11, "BOTTOMRIGHT", 0, caelUI.scale(-5))

		caelPanel11:SetScript("OnUpdate", function(self, elapsed)
			delay = delay + elapsed
			if delay > 0.01 then
				delay = 0

				local numMembers = GetNumGroupMembers()

				if numMembers > 0 then
					for i = 1, numMembers do
						if IsInRaid() then
							blip = _G["BattlefieldMinimapRaid"..i]

							if blip and blip:IsVisible() then
								unit = "Raid"..i
								color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]

								blip.icon:SetTexture(caelMedia.files.raidIcon)

								if color then
									blip.icon:SetVertexColor(color.r, color.g, color.b)
								end
							end
						else
							blip = _G["BattlefieldMinimapParty"..i]

							if blip and blip:IsVisible() then
								unit = "Party"..i
								color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]

								blip.icon:SetTexture(caelMedia.files.partyIcon)

								if color then
									blip.icon:SetVertexColor(color.r, color.g, color.b)
								end
							end
						end
					end
				else
					self:SetScript("OnUpdate", nil)
				end
			end
		end)
	else
		self:Hide()

		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetPoint("TOPRIGHT", UIParent, caelUI.scale(-5), caelUI.scale(-5))

		if BattlefieldMinimap then
			BattlefieldMinimap:Hide()
		end
	end
end)

battlefield:SetParent(caelPanel11)
battlefield:SetFrameStrata("BACKGROUND")
battlefield:SetAllPoints()

battlefield:RegisterEvent("ADDON_LOADED")
battlefield:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "Blizzard_BattlefieldMinimap" then return end

	BattlefieldMinimap:SetParent(battlefield)
	BattlefieldMinimap:SetPoint("TOPLEFT", pixelScale(2), pixelScale(-2))

	kill(BattlefieldMinimapCorner)
	kill(BattlefieldMinimapBackground)
	kill(BattlefieldMinimapTab)
	kill(BattlefieldMinimapTabLeft)
	kill(BattlefieldMinimapTabMiddle)
	kill(BattlefieldMinimapTabRight)
	kill(BattlefieldMinimapCloseButton)

	BattlefieldMinimap:SetScript("OnShow", function(self)
		OpacityFrameSlider:SetValue(0.15)
		BattlefieldMinimapOptions.opacity = OpacityFrameSlider:GetValue()

		BattlefieldMinimap_Update()
	end)

--	BattlefieldMinimap:SetScript("OnHide", function(self)
--		battlefield:SetScale(0.00001)
--		battlefield:SetAlpha(0)
--	end)
--[[
	battlefield:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			self:StopMovingOrSizing()
			if OpacityFrame:IsShown() then OpacityFrame:Hide() end
		elseif button == "RightButton" then
			ToggleDropDownMenu(nil, nil, BattlefieldMinimapTabDropDown, self:GetName(), 0, -4)
			if OpacityFrame:IsShown() then OpacityFrame:Hide() end
		end
	end)

	battlefield:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			if BattlefieldMinimapOptions and BattlefieldMinimapOptions.locked then
				return
			else
				self:StartMoving()
			end
		end
	end)
--]]
end)