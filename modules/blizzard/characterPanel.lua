--[[	$Id: characterPanel.lua 3606 2013-09-30 16:54:09Z sdkyron@gmail.com $	]]

local _, caelUI = ...

local dummy = caelUI.dummy

caelUI.characterpanel = caelUI.createModule("CharacterPanel")

local characterpanel = caelUI.characterpanel

local helm = characterpanel.helm
local cloak = characterpanel.cloak
local undress = characterpanel.undress
local rarityGlow = characterpanel.rarityGlow

local ShowCloak, ShowHelm = ShowCloak, ShowHelm
_G.ShowCloak, _G.ShowHelm = dummy, dummy

for k, v in next, {InterfaceOptionsDisplayPanelShowCloak, InterfaceOptionsDisplayPanelShowHelm} do
	v:SetButtonState("DISABLED", true)
end

helm = CreateFrame("CheckButton", nil, CharacterModelFrame, "OptionsCheckButtonTemplate")
helm:SetPoint("LEFT", CharacterHeadSlot, "RIGHT", caelUI.scale(7), caelUI.scale(4))
helm:SetChecked(ShowingHelm())
helm:SetToplevel()
helm:RegisterEvent("PLAYER_FLAGS_CHANGED")
helm:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
helm:SetScript("OnEvent", function(self, event, unit)
	if(unit == "player") then
		self:SetChecked(ShowingHelm())
	end
end)
helm:SetScript("OnEnter", function(self)
 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Toggles helmet model.")
end)
helm:SetScript("OnLeave", function() GameTooltip:Hide() end)

cloak = CreateFrame("CheckButton", nil, CharacterModelFrame, "OptionsCheckButtonTemplate")
cloak:SetPoint("LEFT", CharacterHeadSlot, "RIGHT", caelUI.scale(7), caelUI.scale(-15))
cloak:SetChecked(ShowingCloak())
cloak:SetToplevel()
cloak:RegisterEvent("PLAYER_FLAGS_CHANGED")
cloak:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
cloak:SetScript("OnEvent", function(self, event, unit)
	if(unit == "player") then
		self:SetChecked(ShowingCloak())
	end
end)
cloak:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Toggles cloak model.")
end)
cloak:SetScript("OnLeave", function() GameTooltip:Hide() end)

undress = CreateFrame("Button", nil, DressUpFrame, "UIPanelButtonTemplate")
undress:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT")
undress:SetHeight(caelUI.scale(22))
undress:SetWidth(caelUI.scale(80))
undress:SetText("Undress")
undress:SetScript("OnClick", function() DressUpModel:Undress() end)

local old_PaperDollFrame_SetItemLevel = PaperDollFrame_SetItemLevel
PaperDollFrame_SetItemLevel = function(statFrame, unit, ...)
	old_PaperDollFrame_SetItemLevel(statFrame, unit, ...)

	if unit ~= "player" then
		return
	end

	local overall, equipped = GetAverageItemLevel()

	_G[statFrame:GetName().."StatText"]:SetText(caelUI.round(overall, 1))
end

rarityGlow = CreateFrame("Frame", nil, CharacterFrame)

rarityGlow.slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", [19] = "Tabard",
		}

rarityGlow.create = function(frame)
	-- Create a frame for the rarity glow if it doesn't exist yet
	if not frame.rarityGlow then
		frame.rarityGlow = frame:CreateTexture(nil, "OVERLAY")
		frame.rarityGlow:SetTexture(caelMedia.files.buttonNormal)
		frame.rarityGlow:SetWidth(frame:GetWidth() + 10)
		frame.rarityGlow:SetHeight(frame:GetHeight() + 10)
		frame.rarityGlow:ClearAllPoints()
		frame.rarityGlow:SetPoint("CENTER", frame)
	end
end

rarityGlow.update = function(...)
	if (CharacterFrame:IsShown()) then
		for id, slotName in pairs(rarityGlow.slots) do
			local slotFrame = _G[("Character%sSlot"):format(slotName)]

			rarityGlow.create(slotFrame)

			local itemLink = GetInventoryItemLink("player", id)

			local rarity, rr, rg, rb

			if itemLink then
				_, _, rarity = GetItemInfo(itemLink)
			end

			-- Only show the rarity if it's over the threshold
			-- rarity of 1 is common/white
			slotFrame.rarityGlow:SetVertexColor(1, 1, 1, 0)

			if itemLink and rarity and rarity > 1 then
				rr, rg, rb = GetItemQualityColor(rarity)
				slotFrame.rarityGlow:SetVertexColor(rr, rg, rb, 1)
			end
		end
	end
end

rarityGlow:RegisterEvent("UNIT_INVENTORY_CHANGED")
rarityGlow:SetScript("OnEvent", function(self, event, unit) if (unit == "player") then rarityGlow.update() end end)
CharacterFrame:HookScript("OnShow", rarityGlow.update)