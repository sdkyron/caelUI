--[[	$Id: buffs.lua 3681 2013-11-02 15:55:41Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.buffs = caelUI.createModule("Buffs")

local pixelScale = caelUI.scale

local BuffFrame               = _G["BuffFrame"]
local TemporaryEnchantFrame   = _G["TemporaryEnchantFrame"]
local ConsolidatedBuffs       = _G["ConsolidatedBuffs"]

BuffFrame:SetParent(UIParent)
BuffFrame:ClearAllPoints()

local DebuffTypeColor = {
	["Magic"]	= {r = 0.2, g = 0.6, b = 1},
	["Curse"]	= {r = 0.6, g = 0, b = 1},
	["Disease"]	= {r = 0.6, g = 0.4, b = 0},
	["Poison"]	= {r = 0, g = 0.6, b = 0},
}

local durationSetText = function(duration, arg1, arg2)
	duration:SetText(format("|cffD7BEA5"..string.gsub(arg1, " ", "").."|r", arg2))
end

local StyleButton = function(button)
		if not button or (button and button.styled) then return end

		button:SetSize(pixelScale(28), pixelScale(28))

		local name			= button:GetName()
		local icon			= _G[format("%sIcon", name)]
		local count			= _G[format("%sCount", name)]
		local border		= _G[format("%sBorder", name)]
		local duration		= _G[format("%sDuration", name)]
		local background	= _G[format("%sBackground", name)]

		if border then
			border:Hide()
		end

		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		icon:SetDrawLayer("BACKGROUND", 1)

		button.border = CreateFrame("Frame", nil, button)
		button.border:SetPoint("TOPLEFT", pixelScale(-1.5), pixelScale(1.5))
		button.border:SetPoint("BOTTOMRIGHT", pixelScale(1.5), pixelScale(-1.5))
		button.border:SetBackdrop({
			bgFile = caelMedia.files.buttonNormal,
			insets = {top = pixelScale(-1.5), left = pixelScale(-1.5), bottom = pixelScale(-1.5), right = pixelScale(-1.5)},
		})

		button.backdrop = CreateFrame("Frame", nil, button)
		button.backdrop:SetPoint("TOPLEFT", pixelScale(-2.5), pixelScale(2.5))
		button.backdrop:SetPoint("BOTTOMRIGHT", pixelScale(2.5), pixelScale(-2.5))
		button.backdrop:SetBackdrop(caelMedia.backdropTable)
		button.backdrop:SetBackdropColor(0, 0, 0, 0)
		button.backdrop:SetBackdropBorderColor(0, 0, 0, 0.75)
		button.backdrop:SetFrameStrata("BACKGROUND")

		button.gloss = CreateFrame("Frame", nil, button)
		button.gloss:SetAllPoints()
		button.gloss:SetBackdrop({
			bgFile = caelMedia.files.buttonGloss,
			insets = {top = pixelScale(-3.5), left = pixelScale(-3.5), bottom = pixelScale(-3.5), right = pixelScale(-3.5)},
		})
		button.gloss:SetBackdropColor(1, 1, 1, 0.5)

		button.duration:SetParent(button.gloss)
		button.duration:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 9)
		button.duration:ClearAllPoints()
		button.duration:SetPoint("BOTTOM", 0, pixelScale(-2))
		button.duration:SetJustifyH("CENTER")
		button.duration:SetShadowColor(0, 0, 0)
		button.duration:SetShadowOffset(0.75, -0.75)

		hooksecurefunc(button.duration, "SetFormattedText", durationSetText)

		button.count:SetParent(button.gloss)
		button.count:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 9)
		button.count:ClearAllPoints()
		button.count:SetPoint("TOP", 0, pixelScale(-2))
		button.count:SetJustifyH("CENTER")
		button.count:SetShadowColor(0, 0, 0)
		button.count:SetShadowOffset(0.75, -0.75)

		button.styled = true
end

local updateBuffAnchors = function()
	local numBuffs = 0
	local buff, previousBuff, aboveBuff

	local _, instanceType = IsInInstance()

	if instanceType ~= "none" then
		BuffFrame:SetPoint("TOPRIGHT", caelPanel11, "TOPLEFT", pixelScale(-5), 0)
	elseif ObjectiveTrackerBlocksFrame.QuestHeader:IsVisible() then
		BuffFrame:SetPoint("TOPRIGHT", ObjectiveTrackerFrame, "TOPLEFT", pixelScale(-30), 0)
	else
		BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", pixelScale(-5), pixelScale(-5))
	end

	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]

		if not buff.styled then StyleButton(buff) end

		buff:SetParent(BuffFrame)
		buff.consolidated = nil
		buff.parent = BuffFrame
		buff:ClearAllPoints()
		numBuffs = numBuffs + 1
		i = numBuffs

		if ((i > 1) and (mod(i, 8) == 1)) then
			buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, pixelScale(-5))
			aboveBuff = buff
		elseif i == 1 then
			buff:SetPoint("TOPRIGHT")
			aboveBuff = buff
		else
			buff:SetPoint("RIGHT", previousBuff, "LEFT", pixelScale(-10), 0)
		end
		previousBuff = buff
	end
end

local updateDebuffAnchors = function(buttonName, i)
	local numBuffs = BUFF_ACTUAL_DISPLAY

	local buffRows = ceil(numBuffs / 8)

	local gap = 5

	if buffRows == 0 then
		gap = 0
	end

	local buff = _G[buttonName..i]
	if ((i > 1) and (mod(i, 8) == 1)) then
		buff:SetPoint("TOP", _G[buttonName..(i - 8)], "BOTTOM", 0, pixelScale(-5))
	elseif (i == 1) then
		buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, pixelScale(-(buffRows * (5 + buff:GetHeight()) + gap)))
	else
		buff:SetPoint("RIGHT", _G[buttonName..(i-1)], "LEFT", pixelScale(-10), 0)
	end
end

local updateTempEnchantAnchors = function()
	local numBuffs = BUFF_ACTUAL_DISPLAY
	local numDebuffs = DEBUFF_ACTUAL_DISPLAY

	local buffRows = ceil(numBuffs / 8)
	local debuffRows = ceil(numDebuffs / 8)

	local gap

	if (buffRows + debuffRows) == 0 then
		gap = 0
	elseif buffRows == 0 and debuffRows ~= 0 then
		gap = 5
	else
		gap = 10
	end

	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local buff = _G["TempEnchant"..i]
		if buff then
			if ((i > 1) and (mod(i, 8) == 1)) then
				buff:SetPoint("TOP", _G["TempEnchant"..(i - 8)], "BOTTOM", 0, pixelScale(-5))
			elseif (i == 1) then
				buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, pixelScale(-((buffRows + debuffRows) * (5 + buff:GetHeight()) + gap)))
			else
				buff:SetPoint("RIGHT", _G["TempEnchant"..(i-1)], "LEFT", pixelScale(-10), 0)
			end
		end

		StyleButton(buff)
	end
end

local checkauras = function(button)
	local color

	for i = 1, BUFF_MAX_DISPLAY do
		local button = _G["BuffButton"..i]

		if button then
			local _, _, _, _, _, _, _, unitCaster = UnitBuff("player", i)

			if unitCaster then
				color = RAID_CLASS_COLORS[select(2, UnitClass(unitCaster))]
				if color then
					button.border:SetBackdropColor(color.r, color.g, color.b)
				else
					button.border:SetBackdropColor(0.5, 0.5, 0.5)
				end
			else
				button.border:SetBackdropColor(0.33, 0.59, 0.33)
			end
		end
	end

	for i = 1, DEBUFF_MAX_DISPLAY do
		local button = _G["DebuffButton"..i]

		if button and button.border then
			local _, _, _, _, debuffType = UnitDebuff("player", i)

			if debuffType then
				color = DebuffTypeColor[debuffType]
				if color then
					button.border:SetBackdropColor(color.r, color.g, color.b)
				else
					button.border:SetBackdropColor(0.69, 0.31, 0.31)
				end
			else
				button.border:SetBackdropColor(0.69, 0.31, 0.31)
			end
		end
	end

	updateTempEnchantAnchors()
end

for i = 1, NUM_TEMP_ENCHANT_FRAMES do
	local button = _G["TempEnchant"..i]
	if button and not button.styled then
		StyleButton(button, "TempEnchant"..i)
		button.border:SetBackdropColor(0.5, 0.5, 0.5)
	end
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)
hooksecurefunc("ObjectiveTracker_Update", updateBuffAnchors)

caelUI.buffs:RegisterEvent("UNIT_AURA")
caelUI.buffs:RegisterEvent("PLAYER_ENTERING_WORLD")
caelUI.buffs:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	if event == "PLAYER_ENTERING_WORLD" then
		checkauras()
	elseif event == "UNIT_AURA" then
		if (unit == PlayerFrame.unit) then
			checkauras()
		end
	end
end)