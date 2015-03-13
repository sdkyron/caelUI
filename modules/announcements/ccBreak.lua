--[[	$Id: ccBreak.lua 3966 2014-12-02 08:28:57Z sdkyron@gmail.com $	]]

local _, caelUI = ...

caelUI.ccbreak = caelUI.createModule("CCBreak")

local grouped = nil
--local msg = "|cffD7BEA5%s|r on |cffAF5050%s|r removed by |cff559655%s|r%s"
local msg = GetLocale() == "frFR" and "%s %s enlevé par |cff559655%s|r" or "%s %s removed by |cff559655%s|r"

local hostile = COMBATLOG_OBJECT_REACTION_HOSTILE or 64 or 0x00000040

local GetSpellName = caelUI.getspellname

local spells = {
	GetSpellName(118),		-- Polymorph
	GetSpellName(28272),		-- Polymorph (pig)
	GetSpellName(28271),		-- Polymorph (turtle)
	GetSpellName(59634),		-- Polymorph (penguin)
	GetSpellName(61025),		-- Polymorph (Serpent)
	GetSpellName(61305),		-- Polymorph (black cat)
	GetSpellName(61721),		-- Polymorph (rabbit)
	GetSpellName(61780),		-- Polymorph (turkey)

	GetSpellName(9484),		-- Shackle Undead

	GetSpellName(3355),		-- Freezing Trap
	GetSpellName(19386),		-- Wyvern Sting

	GetSpellName(339),		-- Entangling Roots
	GetSpellName(2637),		-- Hibernatez

	GetSpellName(6770),		-- Sap

	GetSpellName(5782),		-- Fear
	GetSpellName(6358),		-- Seduction (succubus)

	GetSpellName(10326),		-- Turn Evil
	GetSpellName(20066),		-- Repentance

	GetSpellName(51514),		-- Hex
	GetSpellName(76780),		-- Bind Elemental

	GetSpellName(115078),	-- Paralysis
}

caelUI.ccbreak:RegisterEvent("GROUP_ROSTER_UPDATE")
caelUI.ccbreak:SetScript("OnEvent", function(self, event, _, subEvent, _, _, sourceName, _, _, _, destName, destFlags, _, spellId, spellName, _, _, extraSpellName, ...)
	if event == "GROUP_ROSTER_UPDATE" then
		local numGroup = GetNumGroupMembers()
		if not grouped and numGroup > 0 then
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			grouped = true
		elseif grouped and numGroup == 0 then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			grouped = nil
		end
	else
		if subEvent:find("SPELL_AURA_BROKEN") then
			if bit.band(destFlags, hostile) == hostile then
				for k, v in pairs(spells) do
					if v == spellName then
						local srcName = format(sourceName:gsub("%-[^|]+", ""))
--						DEFAULT_CHAT_FRAME:AddMessage(msg:format(spellName, destName, sourceName and sourceName or "Unknown", extraSpellName and "'s "..extraSpellName or ""))
						DEFAULT_CHAT_FRAME:AddMessage(msg:format("|cffD7BEA5cael|rCCBreak:", GetSpellLink(spellId), sourceName and srcName or "Unknown"))
						break
					end
				end
			end
		end
	end
end)