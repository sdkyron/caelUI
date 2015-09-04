--[[	$Id: UIerrorsFrame.lua 3852 2014-02-02 20:38:01Z sdkyron@gmail.com $	]]

local _, caelUI = ...

--[[	Blacklist some UIerrorFrame messages	]]

caelUI.errorFrame = caelUI.createModule("UIerrorFrame")

local errorFrame = caelUI.errorFrame

local eventBlacklist = {
	[ERR_NO_ATTACK_TARGET] = true,
	[ERR_OUT_OF_ENERGY] = true,
	[ERR_OUT_OF_FOCUS] = true,
	[ERR_OUT_OF_RAGE] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_OUT_OF_HOLY_POWER] = true,
	[ERR_ABILITY_COOLDOWN] = true,
	[ERR_ITEM_COOLDOWN] = true,
	[ERR_SPELL_COOLDOWN] = true,
	[ERR_MUST_EQUIP_ITEM] = true,
	[SPELL_FAILED_MOVING] = true,
	[SPELL_FAILED_NOT_SHAPESHIFT] = true,
	[SPELL_FAILED_TARGET_AURASTATE] = true,
	[SPELL_FAILED_NO_COMBO_POINTS] = true,
	[SPELL_FAILED_SPELL_IN_PROGRESS] = true,
	[SPELL_FAILED_CUSTOM_ERROR_32] = true,
	[SPELL_FAILED_AURA_BOUNCED] = true,
	[SPELL_FAILED_NOT_ON_MOUNTED] = true,
	[SPELL_FAILED_LINE_OF_SIGHT] = true,
}

UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")

errorFrame:RegisterEvent("UI_ERROR_MESSAGE")

errorFrame:SetScript("OnEvent", function(self, event, error)
	if(not eventBlacklist[error]) then
--		UIerrorFrame:AddMessage(error, 0.69, 0.31, 0.31)
		caelCombatTextAddText("|cffAF5050"..error.."|r", nil, nil, false, "Error")
	end
end)