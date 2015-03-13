--[[	$Id: petCare.lua 3563 2013-09-13 16:00:46Z sdkyron@gmail.com $	]]

local _, caelUI = ...

if caelUI.playerClass ~= "HUNTER" then return end

caelUI.petcare = caelUI.createModule("PetCare")

local petcare = caelUI.petcare

local CALL_PET = GetSpellInfo(883)
local DISMISS_PET = GetSpellInfo(2641)
local FEED_PET = GetSpellInfo(6991)
local MEND_PET = GetSpellInfo(136)
local REVIVE_PET = GetSpellInfo(982)

local combat, dead, mending, pet, wounded

local mendThreshold = 0.5 -- Mend your pet out of combat by default when its health is below this percent
local mendModifier = "shift" -- Use this modifier key to mend your pet out of combat, or revive it in combat if it's despawned
local dismissModifier = "ctrl" -- Use this modifier key to dismiss your pet

petcare:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, ...) end end)
petcare:RegisterEvent("ADDON_LOADED")

function petcare:ADDON_LOADED(addon)
	if addon ~= "caelUI" then return end

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then
		self:PLAYER_LOGIN(true)
	else
		self:RegisterEvent("PLAYER_LOGIN")
	end
end

function petcare:PLAYER_LOGIN(delayed)
	for _, event in next, {
		"PLAYER_ALIVE",
		"PLAYER_REGEN_DISABLED",
		"PLAYER_REGEN_ENABLED",
		"PLAYER_UNGHOST",
		"UI_ERROR_MESSAGE",
		"UNIT_PET",
		"UNIT_SPELLCAST_SUCCEEDED",
	} do
		self:RegisterEvent(event)
	end

	if not InCombatLockdown() then
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("UNIT_HEALTH")
	end

	if delayed then
		self:UNIT_PET("player")
	end

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

function petcare:PLAYER_ALIVE()
	if UnitIsGhost("player") then return end

	self:UpdateMacro()
end

petcare.PLAYER_UNGHOST = petcare.PLAYER_ALIVE

function petcare:PLAYER_REGEN_DISABLED()
	combat = true

	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("UNIT_HEALTH")

	self:UpdateMacro()
end

function petcare:PLAYER_REGEN_ENABLED()
	combat = false

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_HEALTH")

	self:UNIT_AURA("pet")
	self:UNIT_HEALTH("pet")

	self:UpdateMacro()
end

local ERR_PET_SPELL_NOTDEAD = PETTAME_NOTDEAD.."."

function petcare:UI_ERROR_MESSAGE(message)
	if message == ERR_PET_SPELL_DEAD then
		dead = true
		self:UpdateMacro()
	elseif message == ERR_PET_SPELL_NOTDEAD then
		dead = false
		self:UpdateMacro()
	end
end

function petcare:UNIT_AURA(unit)
	if unit ~= "pet" then return end

	local wasMending = mending

	mending = select(7, UnitBuff("pet", MEND_PET))

	if mending ~= wasMending then
		self:UpdateMacro()
	end
end

function petcare:UNIT_HEALTH(unit)
	if unit ~= "pet" then return end

	local hp, maxhp = UnitHealth("pet"), UnitHealthMax("pet")

	if not dead and hp <= 0 and UnitIsDead("pet") then
		dead = true
		self:UpdateMacro()
	elseif dead and hp > 0 then
		dead = false
		self:UpdateMacro()
	elseif not wounded and hp / maxhp <= mendThreshold then
		wounded = true
		self:UpdateMacro()
	elseif wounded and hp / maxhp > mendThreshold then
		wounded = false
		self:UpdateMacro()
	end
end

function petcare:UNIT_PET(unit)
	if unit ~= "player" then return end

	local family = UnitCreatureFamily("pet")

	if family and select(2, HasPetUI()) then
		if family ~= pet then
			pet = family
		end

		self:UNIT_HEALTH("pet")

		self:UpdateMacro()
	else
		pet = nil
		self:UpdateMacro()
	end
end

local callIDs = { [833] = true, [83242] = true, [83243] = true, [83244] = true, [83245] = true }

function petcare:UNIT_SPELLCAST_SUCCEEDED(unit, spell, spellID)
	if callIDs[spellID] then
		CALL_PET = spell
	end
end

function petcare:UpdateMacro()
	if InCombatLockdown() then return end

	local macroID = GetMacroIndexByName("AutoPet")

	if select(2, GetNumMacros()) >= 18 then
		self:Print("All character macro slots are in use.")

		return
	else
		local body = "#showtooltip"

		if UnitAffectingCombat("player") then
			body = body.."\n/cast [target=pet,dead][nopet,mod:"..mendModifier.."] "..REVIVE_PET.."; [nopet] "..CALL_PET.."; [mod:"..dismissModifier.."] "..DISMISS_PET.."; "..MEND_PET
		elseif dead then
			body = body.."\n/cast "..REVIVE_PET
		elseif not pet then
			body = body.."\n/cast [target=pet,dead][mod:"..mendModifier.."] "..REVIVE_PET.."; "..CALL_PET
		elseif wounded and not (mending and (GetTime() - mending < 0)) then
			body = body.."\n/cast [mod:"..dismissModifier.."] "..DISMISS_PET.."; "..MEND_PET
		else
			body = body.."\n/cast [mod:"..dismissModifier.."] "..DISMISS_PET.."; [mod:"..mendModifier.."] "..MEND_PET.."; "..FEED_PET
		end

		if not macroID or macroID == 0 then
			CreateMacro("AutoPet", "INV_MISC_QUESTIONMARK", body, 1)
		else
			EditMacro(macroID, "AutoPet", "INV_MISC_QUESTIONMARK", body, 1)
		end
	end
end